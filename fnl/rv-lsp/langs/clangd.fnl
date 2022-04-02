(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        opt {:cmd [:clangd
                        :--background-index
                        :--suggest-missing-includes
                        :--clang-tidy
                        :--all-scopes-completion
                        :--cross-file-rename
                        :--completion-style=detailed
                        :--header-insertion-decorators
                        :--header-insertion=iwyu
                        :--pch-storage=memory]
             :filetypes [:c
                         :cpp
                         :h
                         :hpp]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :on_attach (fn [...]
                          (lsp-on-attach ...)
                          ((. (require :which-key) :register)
                           {:ls [:<Cmd>ClangdSwitchSourceHeader<CR>
                                 "Switch Header"]}
                           {:prefix :<leader>}))
             :capabilities lsp-capabilities
             :init_options {:fallbackFlags [:-std=c++20]}
             :root_dir (lsp-root-dir [:.clang-format]) 
             :single_file_support true}]
    ((. (. (require :lspconfig) :clangd) :setup) opt)))

{: config}
