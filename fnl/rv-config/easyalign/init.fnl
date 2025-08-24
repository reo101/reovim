(fn after []
  (let [dk (require :def-keymaps)]
    (let [mappings
           {:ga ["<Plug>(EasyAlign)" :EasyAlign]}
          visual-mappings
           {:< ["<gv" :Deindent]
            :> [">gv" :Indent]}]
      (dk [:n :v]
          mappings)
      (dk :v
          visual-mappings))))

{:src "https://github.com/junegunn/vim-easy-align"
 :data {:event :DeferredUIEnter
        : after}}
