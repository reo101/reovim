(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:pest-language-server]
             :filetypes [:pest]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [])
             :single_file_support true}]
    ((. (require :lspconfig) :pest_ls :setup) opt)))

{: after}
