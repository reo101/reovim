(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:wgsl_analyzer]
             :filetypes [:wgsl]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir [] true)
             :single_file_support true}]
    ((. (. (require :lspconfig) :wgsl_analyzer) :setup) opt)))

{: config}
