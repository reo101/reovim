;; TODO: tidy up

(let [dk (require :def-keymaps)]
  #_#_
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
  (dk :n
      {:t {:group :Toggle
           :l [(check :loclist)  :Loclist]
           :q [(check :quickfix) :Quickfix]}}
      {:prefix :<leader>})
  (dk :n
      {"]" {:group :Next
            :q [vim.cmd.cnext "Quickfix List"]
            :l [vim.cmd.lnext "Location List"]}
       "[" {:group :Previous
            :q [vim.cmd.cprev "Quickfix List"]
            :l [vim.cmd.lprev "Location List"]}}))

[(require (.. ... :.bqf))
 #_(require (.. ... :.pqf))
 (require (.. ... :.quicker))]
