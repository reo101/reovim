(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        opt {:cmd [:terraform-ls
                   :serve]
             :filetypes [:terraform]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:.terraform]
                         true)}]
    ((. (. (require :lspconfig) :terraformls) :setup) opt)))

{: config}
