(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:pylsp]
             :filetypes [:python]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:pyproject.toml
                          :setup.py
                          :setup.cfg
                          :requirements.txt
                          :Pipfile
                          :pyrightconfig.json])
             :settings {:python {:analysis {:autoSearchPaths true
                                            :useLibraryCodeForTypes true
                                            :diagnosticMode :workspace}}}
             :single_file_support true}]
    ((. (. (require :lspconfig) :pylsp) :setup) opt)))

{: config}
