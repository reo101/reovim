(fn after []
  (let [bufdelete (require :bufdelete)
        dk (require :def-keymaps)]
    (dk :n
        {:b {:group :Buffer
             :d [#(bufdelete.bufdelete 0 false) "Delete"]
             :D [#(bufdelete.bufdelete 0 true) "Force Delete"]}}
        {:prefix :<leader>})))

{:src "https://github.com/famiu/bufdelete.nvim"
 :data {:keys [:<leader>bd
               :<leader>bD]
        : after}}
