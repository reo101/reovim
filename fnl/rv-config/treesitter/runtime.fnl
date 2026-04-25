;;; Runtime setup for nvim-treesitter itself.

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
  ;; Prefer these compilers for building parsers
  (tset (require :nvim-treesitter.install) :compilers
        [:clang "zig cc" :gcc])

  ;; nvim-treesitter/main only needs its runtime queries on rtp.
  ;; Parser ownership is chosen by packaging: TSInstall outside Nix, `treesitter-parsers`
  ;; inside Nix.
  (ensure-nvim-treesitter-runtimepath))

{:ensure-nvim-treesitter-runtimepath ensure-nvim-treesitter-runtimepath
 :setup setup}
