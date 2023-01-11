(fn config []
  (fn register-mappings []
                  (let [wk (require :which-key)
                        mappings {:q {:name :SQL
                                      :w {:name :Switch
                                          :d [:<CMD>SqlsSwitchDatabase<CR>
                                              :Database]
                                          :c [:<CMD>SqlsSwitchConnection<CR>
                                              :Connection]}
                                      :s {:name :Show
                                          :d [:<CMD>SqlsShowDatabases<CR>
                                              :Databases]
                                          :c [:<CMD>SqlsShowConnections<CR>
                                              :Connections]
                                          :s [:<CMD>SqlsShowSchemas<CR>
                                              :Schemas]}
                                      :q {:name :Query
                                          :e [:<CMD>SqlsExecuteQuery<CR>
                                              :Execute]
                                          :v [:<CMD>SqlsExecuteQueryVertical<CR>
                                              "Execute (Vertical)"]}}}]
                    (wk.register mappings {:prefix :<leader>})
                    (local operator-mappings
                           {:q {:name :SQL
                                :q {:name :Query
                                    :e ["<Plug>(sqls-execute-query)"
                                        :Execute]
                                    :v ["<Plug>(sqls-execute-query-vertical)"
                                        "Execute (Vertical)"]}}})
                    (wk.register operator-mappings {:prefix :<leader> :mode :o})
                    (wk.register operator-mappings {:prefix :<leader> :mode :x})))
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:sqls]
             :filetypes [:sql
                         :mysql]
             :on_init lsp-on-init
             :on_attach (fn [client]
                          (lsp-on-attach client)
                          (set client.server_capabilities.execute_command
                               true)
                          (register-mappings)
                          ((. (require :sqls) :setup) {:picker :telescope}))
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [])
             :settings {:sqls {:connections {}}}
             :single_file_support true}]
    (set vim.g.dbext_default_usermaps 0)
    ((. (. (require :lspconfig) :sqls) :setup) opt)))

{: config}
