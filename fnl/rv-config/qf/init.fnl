;; TODO: tidy up

(let [dk (require :def-keymaps)]
  (dk :n
      {"]" {:name :Next
            :q [vim.cmd.cnext "Quickfix List"]
            :l [vim.cmd.lnext "Location List"]}
       "[" {:name :Previous
            :q [vim.cmd.cprev "Quickfix List"]
            :l [vim.cmd.lprev "Location List"]}}))

[(require (.. ... :.bqf))
 (require (.. ... :.pqf))]
