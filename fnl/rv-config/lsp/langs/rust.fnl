(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:rust-analyzer]
             :filetypes [:rust]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:Cargo.toml
                          :rust-project.json])
             :settings {:rust-analyzer {}}
             :single_file_support true}]
    ((. (. (require :lspconfig) :rust_analyzer) :setup) opt)))

{: after}
