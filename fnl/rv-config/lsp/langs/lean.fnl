(fn after []
   (let [{: lsp-on-init
          : lsp-on-attach
          : lsp-capabilities
          : lsp-root-dir} (require :rv-config.lsp.utils)
         opt {:lsp {:on-init      lsp-on-init
                    :on-attach    lsp-on-attach
                    :capabilities lsp-capabilities
                    :root-dir     lsp-root-dir}
              :ft  {:default :lean}
              :abbreviations {:enable false} ;; Using cmp-latex-symbols
              :infoview {:autoopen     true
                         :separate_tab false}
              :progress_bars {:enable   true
                              :priority 10}
              :stderr {:enable   true
                       :height   5
                       :on_lines nil}}]
        ((. (require :lean) :setup) opt)))

{:src "https://github.com/Julian/lean.nvim"
 :data {:dependencies [:neovim/nvim-lspconfig
                       :nvim-lua/plenary.nvim]
        ;; :ft ["lean"]
        :event ["BufReadPre *.lean"
                "BufNewFile *.lean"]
        : after}}
