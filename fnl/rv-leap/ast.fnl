(fn config []
  (let [dk       (require :def-keymaps)
        leap-ast (require :leap-ast)]
    (dk [:n :x :o]
        {:which-key true
         :ha [leap-ast.leap "Leap AST"]}
        :<leader>)))

{: config}
