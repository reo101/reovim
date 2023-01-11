(fn config []
   (let [opt {:on_attach (. (require :rv-config.lsp.utils) :lsp_on_attach)
              :sources {1 (. (. (. (require :null-ls) :builtins)
                                :formatting)
                             :stylua)
                        2 (. (. (. (require :null-ls) :builtins)
                                :formatting)
                             :eslint_d)
                        3 (. (. (. (require :null-ls) :builtins)
                                :formatting)
                             :prettierd)
                        4 (. (. (. (require :null-ls) :builtins)
                                :formatting)
                             :fixjson)}
              :on_init (. (require :rv-config.lsp.utils) :lsp_on_init)
              :capabilities (. (require :rv-config.lsp.utils)
                               :lsp_capabilities)}]
     ((. (require :null-ls) :setup) opt)))

{: config}
