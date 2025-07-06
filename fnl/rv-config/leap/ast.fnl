(fn after []
  (let [dk       (require :def-keymaps)
        leap-ast (require :leap-ast)]
    (dk [:n :x :o]
        {:ha [leap-ast.leap "Leap AST"]}
        {:prefix :<leader>})))

{:src "https://github.com/ggandor/leap-ast.nvim"
 :data {:keys [:<leader>ha]
        : after
        :enabled false}}
