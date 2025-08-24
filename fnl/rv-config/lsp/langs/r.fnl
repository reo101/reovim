(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:R
                   :--slave
                   :-e "languageserver::run()"]
             :filetypes [:r :rmd]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :log_level 2
             :root_dir (lsp-root-dir
                         []
                         true)}]
    ((. (. (require :lspconfig) :r_language_server) :setup) opt)))

{: after}
