(local {:snippet s
        :snippet_node sn
        :text_node t
        :insert_node i
        :function_node f
        :choice_node c
        :dynamic_node d
        :restore_node r}
       (require :luasnip))
(local {:lambda l
        :rep rep
        :partial p
        :match m
        :nonempty n
        :dynamic_lambda dl}
       (require :luasnip.extras))
(local {:fmt fmt
        :fmta fmta}
       (require :luasnip.extras.fmt))
(local types
       (require :luasnip.util.types))
(local conds
       (require :luasnip.extras.conditions))
(local conds-expand
       (require :luasnip.extras.conditions.expand))

[(s :hole
    (fmt "
         {! !}
         "
         {}))
 (s :prove
    (fmt "
         begin
           ?
         ∼⟨ ? ⟩
           ?
         ∎
         "
         {}))]
