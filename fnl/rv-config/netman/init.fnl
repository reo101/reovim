(fn after []
  (let [netman (require :netman)
        dk (require :def-keymaps)
        opt {}]
    (netman.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{:src "https://github.com/miversen33/netman.nvim"
 :version :v1.15
 :data {:event :DeferredUIEnter
        : after}}
