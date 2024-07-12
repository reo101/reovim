(fn config []
  (let [bqf (require :bqf)
        dk (require :def-keymaps)
        opt {}]
    (bqf.setup opt)
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

    (dk [:n]
        {:t {:group :Toggle
             :l [(check :loclist)  :Loclist]
             :q [(check :quickfix) :Quickfix]}}
        {:prefix :<leader>})))

{1 :kevinhwang91/nvim-bqf
 :ft :qf
 : config}
