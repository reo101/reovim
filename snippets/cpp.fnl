(local ls (require :luasnip))
(local s ls.snippet)
(local sn ls.snippet_node)
(local t ls.text_node)
(local i ls.insert_node)
(local f ls.function_node)
(local c ls.choice_node)
(local d ls.dynamic_node)
(local r ls.restore_node)
(local l (. (require :luasnip.extras) :lambda))
(local rep (. (require :luasnip.extras) :rep))
(local p (. (require :luasnip.extras) :partial))
(local m (. (require :luasnip.extras) :match))
(local n (. (require :luasnip.extras) :nonempty))
(local dl (. (require :luasnip.extras) :dynamic_lambda))
(local fmt (. (require :luasnip.extras.fmt) :fmt))
(local fmta (. (require :luasnip.extras.fmt) :fmta))
(local types (require :luasnip.util.types))
(local conds (require :luasnip.extras.conditions.expand))

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
          (var index 1)
          (each [node-type (-> (.. (. args 1 1) ",")
                               (: :gmatch "(.-)%s*,%s*"))]
            (table.insert nodes (t (.. node-type " ")))
            (table.insert nodes (i index (.. :param index)))
            (table.insert nodes (t ", "))
            (set index (+ index 1)))
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
