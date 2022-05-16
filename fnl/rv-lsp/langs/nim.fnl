(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        opt {:cmd [:nimlsp]
             :filetypes [:nim]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:*.nimble])
             :single_file_support true}]
    ((. (. (require :lspconfig) :nimls) :setup) opt)))

{: config}
