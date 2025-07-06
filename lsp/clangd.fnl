{:cmd [:clangd
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
 :on_attach (fn [...]
              ((. (require :rv-config.lsp.utils) :lsp-on-attach) ...)
              ((require :def-keymaps)
               :n
               {:ls [:<Cmd>ClangdSwitchSourceHeader<CR>
                     "Switch Header"]}
               {:prefix :<leader>}))
 ;; :init_options {:fallbackFlags [:-std=c++20]}
 :root_markers [:.clang-format
                :.clang-tidy
                :.clang-format
                :compile_commands.json
                :compile_flags.txt
                :configure.ac]
 :single_file_support true}
