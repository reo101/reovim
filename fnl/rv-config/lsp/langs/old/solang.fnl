(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:solang
                   :language-server
                   :--target
                   :evm]
             :filetypes [:solidity]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         []
                         true)
             :init_options {}}]
    ((. (. (require :lspconfig) :solang) :setup) opt)))

{: config}
