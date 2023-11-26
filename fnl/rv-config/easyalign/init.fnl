(fn config []
  (let [dk (require :def-keymaps)]
    (let [mappings
           {:ga ["<Plug>(EasyAlign)" :EasyAlign]}
          visual-mappings
           {:< ["<gv" :Deindent]
            :> [">gv" :Indent]}]
      (dk [:n :v]
          mappings)
      (dk [:v]
          visual-mappings))))

{: config}
