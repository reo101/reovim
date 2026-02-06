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

(local {: inject-custom-fennel} (require :fennel-loader))
(inject-custom-fennel)

;;; Foreign config detection

(local foreign-config? (not= config-dir running-config))

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
   - Bootstrap files go to `config-dir/lua/` (tracked with git)
   - Everything else goes to `stdpath('data')/nfnl/`"
  (let [rel-path (fnl-abs-path:gsub (.. "^" (vim.pesc config-dir) "/") "")
        rel-path-no-ext (vim.fn.fnamemodify rel-path ":r")
        to-lua-path #(.. ($:gsub "^fnl/" "lua/") ".lua")]
    (if (. bootstrap-files rel-path-no-ext)
        (.. config-dir "/" (to-lua-path rel-path-no-ext))
        (.. nfnl-output-dir "/" (to-lua-path rel-path-no-ext)))))

;;; Config

{:source-file-patterns (if foreign-config?
                           bootstrap-patterns
                           ["init.fnl" "**/*.fnl"])
 : fnl-path->lua-path
 :orphan-detection {:auto? false}
 :compiler-options {:compilerEnv _G
                    :allowedGlobals false}}
