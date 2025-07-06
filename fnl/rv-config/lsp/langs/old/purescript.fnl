(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:purescript-language-server :--stdio]
             :filetypes [:purescript]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :settings {:gopls {:staticcheck true
                                :analyses {:unusedparams true}
                                :hints {:parameterNames         true
                                        :assignVariableTypes    true
                                        :compositeLiteralFields true
                                        :compositeLiteralTypes  true
                                        :constantValues         true
                                        :functionTypeParameters true
                                        :rangeVariableTypes     true}}}
             :root_dir (lsp-root-dir
                         [:spago.dhall
                          :psc-package.json
                          :bower.json
                          :flake.nix
                          :shell.nix])}]
    ((. (. (require :lspconfig) :purescriptls) :setup) opt)))

{: config}
