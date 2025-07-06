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

;; Check if we're in Nix build mode (REOVIM_NIX_BUILD set at build time)
(local nix-build? (= "1" vim.env.REOVIM_NIX_BUILD))

;; Check if we're running under Nix (nix-wrapper-modules sets nix_info_plugin_name)
(local nix-runtime? (not= vim.g.nix_info_plugin_name nil))

;; Foreign config is when this file's directory differs from running config
;; Short-circuit to false during Nix (both build and runtime) to avoid read-only errors
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
   :fnl/bootstrap-nfnl true})

(local bootstrap-patterns
  (-> bootstrap-files
      vim.iter
      (: :map #(.. $ ".fnl"))
      (: :totable)))

;;; Output routing

(fn fnl-path->lua-path [fnl-abs-path]
  "Routes fnl files to appropriate lua output locations:
   - Nix build: all files go to `config-dir/lua/` (for derivation)
   - Regular bootstrap files go to `config-dir/lua/` (tracked with git)
   - Nix runtime (foreign config): all files go to `stdpath('data')/nfnl/` (writable)
   - Everything else goes to `stdpath('data')/nfnl/`"
  (let [;; Handle both files in subdirs (config-dir/fnl/foo.fnl) and at root (config-dir/init.fnl)
        rel-path (fnl-abs-path:gsub (.. "^" (vim.pesc config-dir)) "")
        rel-path (if (= (rel-path:sub 1 1) "/")
                     (rel-path:sub 2)
                     rel-path)
        rel-path-no-ext (vim.fn.fnamemodify rel-path ":r")
        to-lua-path #(.. ($:gsub "^fnl/" "lua/") ".lua")
        lua-path (to-lua-path rel-path-no-ext)
        ;; Use nfnl-output-dir at Nix runtime (foreign config) to avoid read-only store
        is-bootstrap? (. bootstrap-files rel-path-no-ext)
        output-dir (if (or nix-build?
                           (and is-bootstrap? (not nix-runtime?)))
                       config-dir
                       nfnl-output-dir)]
    (.. output-dir "/" lua-path)))

;;; Config

;; Only compile Fennel files in these directories (exclude nix result/)
;; Note: need both *.fnl (root level) and **/*.fnl (nested)
(local source-patterns
  ["fnl/*.fnl"
   "fnl/**/*.fnl"
   "lsp/*.fnl"
   "lsp/**/*.fnl"
   "luasnippets/*.fnl"
   "luasnippets/**/*.fnl"
   "after/*.fnl"
   "after/**/*.fnl"
   "init.fnl"]) ; Root init.fnl for bootstrap

;; Setup fennel paths for typed-fennel macro support
(setup-fennel-paths (require :fennel))

;; Get nfnl default config to extend it
(local nfnl-config (require :nfnl.config))
(local default-config (nfnl-config.default))

;; Merge with default config, extending macro path
;; When nix-build? is true, compile ALL files (ignore foreign-config check)
(vim.tbl_extend
  :force
  default-config
  {:source-file-patterns (if nix-build?
                              source-patterns
                              (if foreign-config?
                                  bootstrap-patterns
                                  source-patterns))
   : fnl-path->lua-path
   :orphan-detection {:auto? false}
   ;; Prepend typed-fennel to default macro path
   :fennel-macro-path (.. (typed-fennel-macro-path) ";" default-config.fennel-macro-path)
   :compiler-options {:compilerEnv _G
                      :allowedGlobals false}})
