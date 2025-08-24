(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:solc
                   :--lsp]
             :filetypes [:solidity]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:hardhat.config.*
                          :foundry.toml]
                         true)
             :single_file_support true}]
    ((. (require :lspconfig) :solidity :setup) opt)))

{: after}
