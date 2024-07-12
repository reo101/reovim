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

(fn return-type [args]
  (if (= (. args 1 1) :void)
      ""
      (.. " -> " (. args 1 1) " ")))

(fn params [args snip old-state ...]
  (let [nodes {}]
    (if (or (= (. args 1 1) "")
            (= (. args 1 1) :void))
        (table.insert nodes (t ""))
        (do
          (each [index node-type
                 (-> (.. (. args 1 1) ",")
                     (: :gmatch "(.-)%s*,%s*")
                     vim.iter
                     (: :enumerate))]
            (table.insert nodes (t (.. node-type " ")))
            (table.insert nodes (i index (.. :param index)))
            (table.insert nodes (t ", ")))
          (table.remove nodes (length nodes))))
    (sn nil nodes)))

[(s :func
    (fmt "
         std::function<{}({})> {} = [{}]({}){}{{
             {}
         }};
         "
         [;; return type
          (i 1 :void)
          ;; param types
          (i 2 :int)
          ;; name
          (i 3 :func)
          ;; captures
          (c 4 [(t "")
                (t "&")
                (t "=")])
          (d 5 params [2])
          (f return-type [1])
          (i 0)]))
 (s :magic
    (fmt "
         std::ios::sync_with_stdio(false);
         std::cin.tie(nullptr);
         "
         {}))
 (s :main
    (fmt "
         int main() {{
             {}

             return 0;
         }}
         "
         [(i 0)]))]
