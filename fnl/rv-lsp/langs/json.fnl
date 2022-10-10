(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        opt {:cmd [:vscode-json-language-server
                   :--stdio]
             :filetypes [:json
                         :jsonc]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         []
                         true)
             :init_options {:provideFormatter true}
             :settings {:json {:schemas ((. (. (require :schemastore)
                                               :json)
                                            :schemas))}}
             :single_file_support true}]
    ((. (. (require :lspconfig) :jsonls) :setup) opt)))

{: config}
