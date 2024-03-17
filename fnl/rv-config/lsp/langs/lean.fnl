(fn config []
   (let [{: lsp-on-init
          : lsp-on-attach
          : lsp-capabilities
          : lsp-root-dir} (require :rv-config.lsp.utils)
         opt {:lsp {: lsp-on-init
                    : lsp-on-attach
                    : lsp-capabilities
                    : lsp-root-dir}
              :ft  {:default :lean}
              :abbreviations {:enable false} ;; Using cmp-latex-symbols
              :infoview {:autoopen     #true
                         :separate_tab false}
              :progress_bars {:enable   true
                              :priority 10}
              :stderr {:enable   true
                       :height   5
                       :on_lines nil}}]
        ((. (require :lean) :setup) opt)))

{1 :Julian/lean.nvim
 :ft ["lean"]
 : config}
