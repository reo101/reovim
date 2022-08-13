(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        opt {:cmd [:gopls :-remote=auto]
             :filetypes [:go
                         :gomod]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             ;; https://github.com/golang/tools/blob/master/gopls/doc/settings.md
             :settings {:gopls {:staticcheck true
                                :analyses {:unusedparams true}
                                ;; https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
                                :hints {:parameterNames         true
                                        :assignVariableTypes    true
                                        :compositeLiteralFields true
                                        :compositeLiteralTypes  true
                                        :constantValues         true
                                        :functionTypeParameters true
                                        :rangeVariableTypes     true}}}
             :root_dir (lsp-root-dir
                         [:go.mod])
             :single_file_support true}]
    ((. (. (require :lspconfig) :gopls) :setup) opt)))

{: config}
