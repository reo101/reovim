(fn config []
  (let [configs     (require :lspconfig.configs)
        server-name :circom-lsp
        {: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:circom-lsp]
             :filetypes [:circom]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:package.json])
             :single_file_support true}]
    (tset configs server-name
          {:default_config
            {:cmd [:circom-lsp]
             :filetypes [:circom]
             :root_dir ((. (require :lspconfig) :util :root_pattern) :package.json)
             :single_file_support true}})
    ((. (require :lspconfig) server-name :setup) opt)))

{: config}
