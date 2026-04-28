(fn after []
   (let [lean (require :lean)
         opt {:ft  {:default :lean}
              :abbreviations {:enable false} ;; Using cmp-latex-symbols
              :infoview {:autoopen     true
                         :separate_tab false}
              :progress_bars {:enable   true
                              :priority 10}
              :stderr {:enable   true
                       :height   5
                       :on_lines nil}}]
        (lean.setup opt)))

{:src "https://github.com/Julian/lean.nvim"
 :version :v2026.4.1
 :data {;; :ft ["lean"]
        :event ["BufReadPre *.lean"
                "BufNewFile *.lean"]
        : after}}
