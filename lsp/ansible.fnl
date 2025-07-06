{:cmd [:ansible-language-server
       :--stdio]
 :filetypes [:yaml.ansible]
 :root_markers [:ansible.cfg
                :.ansible-lint]
 :settings {:ansible {:python {:interpreterPath :python}
                      :ansible {:path :ansible}
                      :executionEnvironment {:enabled false}
                      :ansibleLint {:enabled true
                                    :path :ansible-lint}}}
 :single_file_support true}
