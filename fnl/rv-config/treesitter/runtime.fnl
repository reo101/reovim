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

(fn prefer-single-parser-provider [plugin-root]
  ;; Canonical strategy: use rtp ordering to prefer one parser provider.
  ;; De-prioritize nvim-treesitter's bundled parser/ so core runtime parsers
  ;; win when both exist, while still keeping nvim-treesitter available.
  (when (and plugin-root
             (= 1 (vim.fn.isdirectory (vim.fs.joinpath plugin-root "parser")))
             (vim.tbl_contains (vim.opt.runtimepath:get) plugin-root))
    (vim.opt.runtimepath:remove plugin-root)
    (vim.opt.runtimepath:append plugin-root)))

(fn setup []
  ;; Prefer these compilers for building parsers
  (tset (require :nvim-treesitter.install) :compilers
        [:clang "zig cc" :gcc])

  ;; Setup moved to the top-level nvim-treesitter module on main
  (let [treesitter (require :nvim-treesitter)]
    (treesitter.setup {}))

  (let [nvim-treesitter-root (ensure-nvim-treesitter-runtimepath)]
    (prefer-single-parser-provider nvim-treesitter-root)
    nvim-treesitter-root))

{:ensure-nvim-treesitter-runtimepath ensure-nvim-treesitter-runtimepath
 :prefer-single-parser-provider prefer-single-parser-provider
 :setup setup}
