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

(fn jdocsnip [args _ old-state]
  (let [nodes [(t ["/**" " * "])
               (i 1 "A short Description")
               (t ["" ""])]
        ;; These will be merged with the snippet; that way, should the snippet be updated,
        ;; some user input e.g. text can be referred to in the new snippet
        param-nodes {}]

    (when old-state
      (tset nodes 2 (i 1 (old-state.descr:get_text))))
    (set param-nodes.descr (. nodes 2))

    ;; At least one param
    (when (string.find (. args 2 1) ", ")
      (vim.list_extend nodes [(t [" * " ""])]))

    (var insert 2)
    (each [index argument (ipairs (vim.split (. args 2 1) ", " true))]
      ;; Get actual name parameter
      (set-forcibly! argument (. (vim.split argument " " true) 2))
      (when argument
        ;; if there was some text in this parameter, use it as static_text for this new snippet
        (local inode
               (if (and old-state (. old-state argument))
                   (i insert (-> old-state
                                 (. (.. :arg argument))
                                 (: :get_text)))
                   (i insert)))
        (vim.list_extend
          nodes
          [(t [(.. " * @param " argument " ")])
           inode
           (t ["" ""])])
        (tset param-nodes (.. :arg argument) inode)
        (set insert (+ insert 1))))

    (when (not= (. args 1 1) :void)
      (local inode
             (if (and old-state old-state.ret)
                 (i insert (old-state.ret:get_text))
                 (i insert)))
      (vim.list_extend
        nodes
        [(t [" * " " * @return "])
         inode
         (t ["" ""])])
      (set param-nodes.ret inode)
      (set insert (+ insert 1)))

    (when (not= (vim.tbl_count (. args 3)) 1)
      (local exc (string.gsub (. (. args 3) 2) " throws " ""))
      (local ins
             (if (and old-state old-state.ex)
                 (i insert (old-state.ex:get_text))
                 (i insert)))
      (vim.list_extend
        nodes
        [(t [" * " (.. " * @throws " exc " ")])
         ins
         (t ["" ""])])
      (set param-nodes.ex ins)
      (set insert (+ insert 1)))

    (vim.list_extend nodes [(t [" */"])])

    (local snip (sn nil nodes))
    (set snip.old_state param-nodes)
    snip))

[(s :fn [(d 6 jdocsnip [2 4 5])
         (t ["" ""])
         (c 1 [(t "public ")
               (t "private ")])
         (c 2 [(t :void)
               (t :String)
               (t :char)
               (t :int)
               (t :double)
               (t :boolean)
               (i nil "")])
         (t " ")
         (i 3 :myFunc)
         (t "(")
         (i 4)
         (t ")")
         (c 5 [(t "")
               (sn nil [(t ["" " throws "])
                        (i 1)])])
         (t [" {" "\t"])
         (i 0)
         (t ["" "}"])])
 (s :sout [(t :System)
           (c 1 [(t :.out)
                 (t :.err)])
           (c 2 [(t :.println)
                 (t :.printf)
                 (t :.print)])
           (t "(")
           (i 3 "\"Hello Gaguri\"")
           (t ");")])]
