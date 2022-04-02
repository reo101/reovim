(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        opt {:cmd [:gopls]
             :filetypes [:go
                         :gomod]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:go.mod]) 
             :single_file_support true}]
    ((. (. (require :lspconfig) :gopls) :setup) opt)))

{: config}
