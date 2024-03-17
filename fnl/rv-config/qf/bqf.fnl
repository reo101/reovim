(fn config []
  (let [opt {}]
    ((. (require :bqf) :setup) opt)
    (local wk (require :which-key))

    (fn check [want]
      #(each [_ info (ipairs (vim.fn.getwininfo))]
         (vim.cmd
           (match want
             :quickfix
               (if (= info.quickfix 0)
                   :copen
                   :cclose)
             :loclist
               (if (= info.loclist 0)
                   :lopen
                   :lclose)))))

    (local mappings
           {:t {:l [(check :loclist) :Loclist]
                :name :Toggle
                :q [(check :quickfix) :Quickfix]}})
    (wk.register mappings {:mode :n :prefix :<leader>})))

{1 :kevinhwang91/nvim-bqf
 :ft :qf
 : config}
