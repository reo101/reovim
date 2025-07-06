(fn config []
  (local configs (require :lspconfig.configs))
  (local util (require :lspconfig.util))
  (local server_name :noir)
  (tset configs server_name
          {:default_config {:cmd [:nargo
                                  :lsp]
                            :filetypes [:noir]
                            :root_dir (util.root_pattern :Nargo.toml)}
           :docs {:description "https://github/noir-lang/noir"}})
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:nargo
                   :lsp]
             :filetypes [:noir]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:Nargo.toml])
             :single_file_support true}]
    ((. (require :lspconfig) :noir :setup) opt)))

{: config}
