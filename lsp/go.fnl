{:cmd [:gopls :-remote=auto]
 :filetypes [:go
             :gomod]
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
 :root_markers [:go.mod]
 :single_file_support true}
