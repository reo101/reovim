;; TODO: tidy up

(let [dk (require :def-keymaps)]
  (dk :n
      {"]" {:group :Next
            :q [vim.cmd.cnext "Quickfix List"]
            :l [vim.cmd.lnext "Location List"]}
       "[" {:group :Previous
            :q [vim.cmd.cprev "Quickfix List"]
            :l [vim.cmd.lprev "Location List"]}}))

[(require (.. ... :.bqf))
 (require (.. ... :.pqf))]
