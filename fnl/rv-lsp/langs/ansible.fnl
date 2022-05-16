(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        opt {:cmd [:ansible-language-server
                   :--stdio]
             :filetypes [:yaml.ansible]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir [:ansible.cfg
                                      :.ansible-lint])
             :settings {:ansible {:python {:interpreterPath :python}
                                  :ansible {:path :ansible}
                                  :executionEnvironment {:enabled false}
                                  :ansibleLint {:enabled true
                                                :path :ansible-lint}}}
             :single_file_support true}]
    ((. (. (require :lspconfig) :ansiblels) :setup) opt)))

{: config}
