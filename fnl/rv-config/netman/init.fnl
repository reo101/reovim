(fn config []
  (let [netman (require :netman)
        dk (require :def-keymaps)
        opt {}]
    (netman.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{1 :miversen33/netman.nvim
 :tag :v1.15
 :event :VeryLazy
 : config}
