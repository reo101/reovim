(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:lemminx]
             :filetypes [:xml
                         :xsd
                         :xsl
                         :xslt
                         :svg
                         :dtd]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         []
                         true)
             :single_file_support true}]
    ((. (. (require :lspconfig) :lemminx) :setup) opt)))

{: config}
