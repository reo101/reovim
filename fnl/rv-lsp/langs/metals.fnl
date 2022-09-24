(fn config []
   (let [setup_metals (fn []
                        (let [{: lsp-on-init
                               : lsp-on-attach
                               : lsp-capabilities
                               : lsp-root-dir} (require :rv-lsp.utils)
                              metals (require :metals)
                              metals-config (metals.bare_config)]
                          (set metals-config.settings
                               {:showImplicitArguments true
                                :showInferredType true
                                :showImplicitConversionsAndClasses true})
                          (set metals-config.init_options.statusBarProvider :on)
                          (set metals-config.on_attach
                               (fn [client bufnr]
                                 (lsp-on-attach client bufnr)
                                 (lsp-on-init client)
                                 (metals.setup_dap)))
                          (set metals-config.capabilities lsp-capabilities)
                          (vim.cmd "
                            hi! link LspCodeLens       CursorColumn
                            hi! link LspReferenceText  CursorColumn
                            hi! link LspReferenceRead  CursorColumn
                            hi! link LspReferenceWrite CursorColumn
                          ")
                          (let [dk (require :def-keymaps)]
                              (dk [:n]
                                  {:fm [(. (require :telescope)
                                           :extensions
                                           :metals
                                           :commands)
                                        "Metals Commands"]}
                                  :<leader>)
                              (dk [:v]
                                  {:K [metals.type_of_range
                                       "Type of Range"]}))
                          (metals.initialize_or_attach metals-config)))
         group (vim.api.nvim_create_augroup "LSP_Metals" {:clear true})]
       (vim.api.nvim_create_autocmd [:FileType]
                                    {:pattern [:scala :sbt :java]
                                     : group
                                     :callback #(setup_metals)})))

{: config}
