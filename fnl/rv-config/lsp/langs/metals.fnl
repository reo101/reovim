(fn config []
   (let [{: lsp-on-init
          : lsp-on-attach
          : lsp-capabilities
          : lsp-root-dir} (require :rv-config.lsp.utils)
         dk (require :def-keymaps)
         metals (require :metals)]
     ;; Setup config
     (local
       metals-config
       (vim.tbl_deep_extend
         :force
         (metals.bare_config)
         {:settings {:showImplicitArguments true
                     :showInferredType true
                     :showImplicitConversionsAndClasses true}
          :init_options {:statusBarProvider :on}
          :on_attach (fn [client bufnr]
                       (lsp-on-attach client bufnr)
                       (lsp-on-init client)
                       (metals.setup_dap))
          :capabilities lsp-capabilities}))
     (vim.cmd "hi! link LspCodeLens       CursorColumn
               hi! link LspReferenceText  CursorColumn
               hi! link LspReferenceRead  CursorColumn
               hi! link LspReferenceWrite CursorColumn")

     ;; Setup keybinds
     (dk :n
         {:fm [(. (require :telescope)
                  :extensions
                  :metals
                  :commands)
               "Metals Commands"]}
         {:prefix :<leader>})
     (dk :v
         {:K [metals.type_of_range
              "Type of Range"]})

     ;; Autocommand for loading
     (let [group (vim.api.nvim_create_augroup
                   "LSP_Metals"
                   {:clear true})]
       (vim.api.nvim_create_autocmd
         :FileType
         {:pattern [:scala :sbt :java]
          : group
          :callback #(metals.initialize_or_attach metals-config)}))))

{1 :scalameta/nvim-metals
 :dependencies [:nvim-lua/plenary.nvim]
 :ft [:scala :sbt]
 : config}
