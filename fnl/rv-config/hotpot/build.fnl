(local dk (require :def-keymaps))
(local {: build} (require :hotpot.api.make))

;; Build all fnl files inside config dir
(build (vim.fn.stdpath "config")
       ;;; Settings
       {:atomic?   true
        :verbosity 0
        :force?    false}
       ;;; config/after/*/*.fnl -> config/after/*/*.lua
       (.. "(" (vim.fn.stdpath "config") "/after/.+/.+)")
       (fn [whole-path] (values whole-path))
       ;;; config/ftdetect/*.fnl -> config/ftdetect/*.lua
       (.. "(" (vim.fn.stdpath "config") "/ftdetect/.+)")
       (fn [whole-path] (values whole-path))
       ;;; config/ftplugins/*.fnl -> config/ftplugins/*.lua
       (.. "(" (vim.fn.stdpath "config") "/ftplugins/.+)")
       (fn [whole-path] (values whole-path)))

(dk :n
    {:pC [#(let [{: check} (require :hotpot.api.make)]
             (check (vim.fn.stdpath "config") {:force? true}
                    "(.+)/fnl/(.+)"
                    (fn [root part {: join-path}]
                      (if (not (string.find part "macros"))
                        (join-path root :lua part)))))
          "Config"]}
    {:prefix :<leader>})
