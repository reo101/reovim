(fn config []
  (let [netman (require :netman)
        dk (require :def-keymaps)
        opt {}]
    (netman.setup opt)

    (dk [:n]
        {}
        {:prefix :<leader>})))

{: config}
