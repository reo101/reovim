(fn config []
  (let [bufdelete (require :bufdelete)
        dk (require :def-keymaps)]
    (dk [:n]
        {:b {:name :Buffer
             :d [#(bufdelete.bufdelete 0 false) "Delete"]
             :f [#(bufdelete.bufdelete 0 true) "Force Delete"]}}
        {:prefix :<leader>})))

{1 :famiu/bufdelete.nvim
 : config}
