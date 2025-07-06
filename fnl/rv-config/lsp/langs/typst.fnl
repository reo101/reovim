(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:tinymist]
             :filetypes [:typst]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         []
                         true)
             :settings {:exportPdf :onType
                        :outputPath :$root/target/$dir/$name
                        :preview true
                        :preview.invertColors :auto
                        :preview.cursorIndicator true
                        :preview.showInActivityBar true}
             :single_file_support true}]
    ((. (require :lspconfig) :tinymist :setup) opt)))

{: config}
