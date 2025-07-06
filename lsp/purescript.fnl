{:cmd [:purescript-language-server :--stdio]
 :filetypes [:purescript]
 :settings {:gopls {:staticcheck true
                    :analyses {:unusedparams true}
                    :hints {:parameterNames         true
                            :assignVariableTypes    true
                            :compositeLiteralFields true
                            :compositeLiteralTypes  true
                            :constantValues         true
                            :functionTypeParameters true
                            :rangeVariableTypes     true}}}
 :root_markers [:spago.dhall
                :psc-package.json
                :bower.json]}
