(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        opt {:cmd [:erlang_ls]
             :filetypes [:erlang]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:rebar.config
                          :erlang.mk])
             :single_file_support true}]
    ((. (. (require :lspconfig) :erlangls) :setup) opt)))

{: config}
