(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        opt {:cmd [:texlab]
             :filetypes [:tex
                         :bib]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:latexmkrc])
             :settings {:texlab {:rootDirectory "."
                                 :build _G.TeXMagicBuildConfig
                                 :forwardSearch {:executable :zathura
                                                 :onSave true
                                                 :args [:--synctex-forward
                                                        "%l:1:%f"
                                                        "%p"]}}}
             :single_file_support true}]
    ((. (. (require :lspconfig) :texlab) :setup) opt)))

{: config}
