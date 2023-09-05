(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:nixd]
             :filetypes [:nix]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:.nixd.json
                          :flake.nix]
                         true)
             :single_file_support true}]
    ((. (. (require :lspconfig) :nixd) :setup) opt)))

{: config}
