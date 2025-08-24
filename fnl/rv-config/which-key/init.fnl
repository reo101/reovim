(fn after []
  (let [dk (require :def-keymaps)
        which-key (require :which-key)]
    (which-key.setup {})
    (dk :n
        {:? [#(which-key.show {:global false}) "Buffer Local Keymaps"]}
        {:prefix :<leader>})))

{:src "https://github.com/folke/which-key.nvim"
 :version :v3.13.2
 :data {:event :DeferredUIEnter
        : after}}
