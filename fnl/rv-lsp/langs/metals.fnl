(fn config []
   (set _G.setup_metals
        (fn []
          (let [metals-config ((. (require :metals) :bare_config))]
            (set metals-config.settings
                 {:showImplicitArguments true
                  :showInferredType true
                  :showImplicitConversionsAndClasses true})
            (set metals-config.init_options.statusBarProvider :on)
            (set metals-config.on_attach
                 (fn [client bufnr]
                   ((. (require :rv-lsp.utils) :lsp_on_attach) client
                                                               bufnr)
                   ((. (require :rv-lsp.utils) :lsp_on_init) client)
                   ((. (require :metals) :setup_dap))))
            (vim.cmd 
              " hi! link LspCodeLens CursorColumn
                hi! link LspReferenceText CursorColumn
                hi! link LspReferenceRead CursorColumn
                hi! link LspReferenceWrite CursorColumn
              ")
            (local wk (require :which-key))
            (local mappings
                   {:fm {1 (. (. (. (require :telescope)
                                    :extensions)
                                 :metals)
                              :commands)
                         2 "Metals Commands"}})
            (local visual-mappings
                   {:K {1 (. (require :metals) :type_of_range)
                        2 "Type of Range"}})
            (wk.register mappings {:prefix :<leader>})
            (wk.register visual-mappings {:mode :v :prefix ""})
            ((. (require :metals) :initialize_or_attach) metals-config))))
   (vim.cmd 
     "  augroup lsp
          au!
          au FileType scala,sbt lua _G.setup_metals()
        augroup end
    "))

{: config}
