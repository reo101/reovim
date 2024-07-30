(fn config []
  (let [dk (require :def-keymaps)
        which-key (require :which-key)]
    (which-key.setup {})
    (dk :n
        {:? [#(which-key.show {:global false}) "Buffer Local Keymaps"]}
        {:prefix :<leader>})))

{1 :folke/which-key.nvim
 :tag :v3.13.2
 :event :VeryLazy
 : config}
