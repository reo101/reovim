(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:racket
                   :--lib
                   :racket-langserver]
             :filetypes [:racket
                         :scheme]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [])
             :settings {}
             :single_file_support true}]
    ((. (. (require :lspconfig) :racket_langserver) :setup) opt)))

{: after}
