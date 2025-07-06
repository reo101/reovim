;; (fn register-mappings []
;;                 (let [wk (require :which-key)
;;                       mappings {:q {:group :SQL
;;                                     :w {:group :Switch
;;                                         :d [:<CMD>SqlsSwitchDatabase<CR>
;;                                             :Database]
;;                                         :c [:<CMD>SqlsSwitchConnection<CR>
;;                                             :Connection]}
;;                                     :s {:group :Show
;;                                         :d [:<CMD>SqlsShowDatabases<CR>
;;                                             :Databases]
;;                                         :c [:<CMD>SqlsShowConnections<CR>
;;                                             :Connections]
;;                                         :s [:<CMD>SqlsShowSchemas<CR>
;;                                             :Schemas]}
;;                                     :q {:group :Query
;;                                         :e [:<CMD>SqlsExecuteQuery<CR>
;;                                             :Execute]
;;                                         :v [:<CMD>SqlsExecuteQueryVertical<CR>
;;                                             "Execute (Vertical)"]}}}]
;;                   (wk.register mappings {:prefix :<leader>})
;;                   (local operator-mappings
;;                          {:q {:group :SQL
;;                               :q {:group :Query
;;                                   :e ["<Plug>(sqls-execute-query)"
;;                                       :Execute]
;;                                   :v ["<Plug>(sqls-execute-query-vertical)"
;;                                       "Execute (Vertical)"]}}})
;;                   (wk.register operator-mappings {:prefix :<leader> :mode :o})
;;                   (wk.register operator-mappings {:prefix :<leader> :mode :x})))

;; (set vim.g.dbext_default_usermaps 0)

{:cmd [:sql-language-server
       :up
       :--method
       :stdio]
 :filetypes [:sql
             :mysql]
 ;; :on_attach (fn [client]
 ;;              (set client.server_capabilities.execute_command
 ;;                  true)
 ;;              (register-mappings)
 ;;              ((. (require :sqls) :setup) {:picker :telescope}))
 ;; :settings {:sqls {:connections {}}}
 :single_file_support true}
