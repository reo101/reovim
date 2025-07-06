(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:docker-langserver
                   :--stdio]
             :filetypes [:dockerfile]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:Dockerfile])
             :single_file_support true}]
    ((. (. (require :lspconfig) :dockerls) :setup) opt)))

{: config}
