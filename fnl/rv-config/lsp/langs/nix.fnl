(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:nil]
             :filetypes [:nix]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:flake.nix]
                         true)
             :settings {:nil {:formatting {:command ["nixfmt"]}}}
             :single_file_support true}]
    ((. (. (require :lspconfig) :nil_ls) :setup) opt)))

{: config}
