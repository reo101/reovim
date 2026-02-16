;;; Custom Fennel injection
;;; Loads shared `fennel-loader` module from `lua/`

;; NOTE: `debug.getinfo` returns source as `@/path/to/.nfnl.fnl`, strip the `@`
(local this-file (-> (debug.getinfo 1 :S) (. :source) (: :sub 2)))
(local config-dir (vim.fn.fnamemodify this-file ":h"))
(local running-config (vim.fn.stdpath :config))
(local nfnl-output-dir (.. (vim.fn.stdpath :data) "/nfnl"))

(local lua-path (.. config-dir "/lua/?.lua"))
(when (->> lua-path vim.pesc (: package.path :match) not)
  (set package.path (.. lua-path ";" package.path)))

(local {: inject-custom-fennel
        : typed-fennel-macro-path
        : setup-fennel-paths}
  (require :fennel-loader))
(inject-custom-fennel)

;;; Nix detection

(local nix-build? (= "1" vim.env.REOVIM_NIX_BUILD))
(local nix-runtime? (not= vim.g.nix_info_plugin_name nil))

;; False during Nix (both build and runtime) to avoid read-only errors
(local foreign-config?
  (and (not nix-build?)
       (not nix-runtime?)
       (not= config-dir running-config)))

(when foreign-config?
  (vim.notify_once
    (.. "nfnl: Foreign config detected!\n"
        "  This config: `" config-dir "`\n"
        "  Running config: `" running-config "`\n"
        "  Only bootstrap files will be compiled.")
    vim.log.levels.WARN))

;;; Bootstrap files - compiled to tracked `lua/` directory

(local bootstrap-files
  {:init true
   :fnl/fennel-loader true
   :fnl/bootstrap-nfnl true
   :nix/lib/compile-fennel true})

(local bootstrap-patterns
  (-> bootstrap-files
      vim.iter
      (: :map #(.. $ ".fnl"))
      (: :totable)))

;;; Output routing

(fn fnl-path->lua-path [fnl-abs-path]
  "Routes fnl files to appropriate lua output locations:
   - Nix build: all files → `config-dir/lua/`
   - Bootstrap files (non-Nix runtime) → `config-dir/lua/` (tracked)
   - Everything else → `stdpath('data')/nfnl/`"
  (let [rel-path (fnl-abs-path:gsub (.. "^" (vim.pesc config-dir) "/?") "")
        rel-path-no-ext (vim.fn.fnamemodify rel-path ":r")
        lua-path (.. (rel-path-no-ext:gsub "^fnl/" "lua/") ".lua")
        is-bootstrap? (. bootstrap-files rel-path-no-ext)
        output-dir (if (or nix-build?
                           (and is-bootstrap? (not nix-runtime?)))
                       config-dir
                       nfnl-output-dir)]
    (.. output-dir "/" lua-path)))

;;; Config

;; Need both `*.fnl` (root level) and `**/*.fnl` (nested)
(local source-patterns
  ["fnl/*.fnl"
   "fnl/**/*.fnl"
   "lsp/*.fnl"
   "lsp/**/*.fnl"
   "luasnippets/*.fnl"
   "after/**/*.fnl"
   "nix/lib/*.fnl"
   "init.fnl"])

(setup-fennel-paths (require :fennel))

(local nfnl-config (require :nfnl.config))
(local default-config (nfnl-config.default))

;; Foreign config only compiles bootstrap files
(vim.tbl_extend
  :force
  default-config
  {:source-file-patterns (if foreign-config? bootstrap-patterns source-patterns)
   : fnl-path->lua-path
   :orphan-detection {:auto? false}
   :fennel-macro-path (.. (typed-fennel-macro-path) ";" default-config.fennel-macro-path)
   :compiler-options {:compilerEnv _G
                      :allowedGlobals false}})
