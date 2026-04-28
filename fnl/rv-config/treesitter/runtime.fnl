;;; Runtime setup for nvim-treesitter itself.

(fn neovim-runtime-dir []
  (let [runtime-file (. (vim.api.nvim_get_runtime_file "lua/vim/treesitter/language.lua" false) 1)]
    (or (and runtime-file
             (: runtime-file :gsub "/lua/vim/treesitter/language%.lua$" ""))
        vim.env.VIMRUNTIME
        (vim.fn.expand "$VIMRUNTIME"))))

(fn neovim-parser-dir []
  (let [runtime-root (neovim-runtime-dir)]
    (when (and runtime-root (not= runtime-root ""))
      (-> runtime-root
          vim.fs.dirname
          vim.fs.dirname
          vim.fs.dirname
          (vim.fs.joinpath :lib :nvim :parser)))))

(fn parser-entry-path [parser-dir name]
  (let [path (vim.fs.joinpath parser-dir name)
        stat (vim.uv.fs_stat path)]
    (when (and stat (= stat.type :file))
      path)))

(fn neovim-parser-paths []
  (let [parser-dir (neovim-parser-dir)
        parser-paths {}]
    (when parser-dir
      (each [name _ (vim.fs.dir parser-dir)]
        (let [parser-path (parser-entry-path parser-dir name)
              lang (and parser-path (name:match "^(.*)%.[^.]+$"))]
          (when (and lang (not= lang ""))
            (tset parser-paths lang parser-path)))))
    parser-paths))

(fn ensure-neovim-parser-ownership []
  ;; Neovim runtime features compile against bundled queries.
  ;; Pin bundled parsers early so stale plugin parser dirs don't win by rtp order.
  (each [lang parser-path (pairs (neovim-parser-paths))]
    (vim.treesitter.language.add lang {:path parser-path})))

(fn ensure-nvim-treesitter-runtimepath []
  ;; nvim-treesitter/main ships bundled queries under runtime/queries.
  ;; Make sure that runtime dir is on rtp so query discovery can find them.
  (let [lua-files (vim.api.nvim_get_runtime_file "lua/nvim-treesitter/init.lua" true)
        lua-path (. lua-files 1)]
    (if lua-path
        (let [plugin-root (: lua-path :gsub "/lua/nvim%-treesitter/init%.lua$" "")
              runtime-dir (vim.fs.joinpath plugin-root "runtime")]
          (when (and (= 1 (vim.fn.isdirectory runtime-dir))
                     (not (vim.tbl_contains (vim.opt.runtimepath:get) runtime-dir)))
            (vim.opt.runtimepath:append runtime-dir))
          plugin-root)
        nil)))

(fn setup []
  (ensure-neovim-parser-ownership)

  ;; Prefer these compilers for building parsers
  (tset (require :nvim-treesitter.install) :compilers
        [:clang "zig cc" :gcc])

  ;; nvim-treesitter/main only needs its runtime queries on rtp.
  ;; Parser ownership is chosen by packaging: TSInstall outside Nix, `treesitter-parsers`
  ;; inside Nix.
  (ensure-nvim-treesitter-runtimepath))

{:ensure-neovim-parser-ownership ensure-neovim-parser-ownership
 :ensure-nvim-treesitter-runtimepath ensure-nvim-treesitter-runtimepath
 :setup setup}
