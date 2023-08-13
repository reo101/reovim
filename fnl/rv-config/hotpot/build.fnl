(local dk (require :def-keymaps))
(local {: build} (require :hotpot.api.make))

(local config (vim.fn.stdpath :config))

;; Build all fnl files inside config dir
(build config
       ;;; Settings
       {:atomic?   true
        :verbosity 0
        :force?    false}
       ;; ;;; config/*fnl*/*.fnl -> config/*lua*/*.lua
       ;; (.. "(" config "/.+/.+%.fnl)")
       ;; (fn [whole-path]
       ;;   (when (not (string.match
       ;;                 whole-path
       ;;                 (.. config "/fnl/.+")))
       ;;     (string.gsub whole-path "fnl" "lua")))
       ;;; config/ftdetect/*.fnl -> config/ftdetect/*.lua
       (.. "(" config "/ftdetect/.+)")
       (fn [whole-path] (values whole-path))
       ;;; config/ftplugins/*.fnl -> config/ftplugins/*.lua
       (.. "(" config "/ftplugins/.+)")
       (fn [whole-path] (values whole-path)))

(dk :n
    {:p {:name :HotPot
         :C [#(let [{: check} (require :hotpot.api.make)]
                (check config
                       {:force? true}
                       "(.+)/fnl/(.+)"
                       (fn [root part {: join-path}]
                         (if (not (string.find part "macros"))
                           (join-path root :lua part)))))
             "Config"]}}
    {:prefix :<leader>})
