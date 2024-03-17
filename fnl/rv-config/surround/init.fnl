(fn config []
 (let [utils (require :nvim-surround.config)
       opt {:keymaps {:insert          :<C-g>s
                      :insert_line     :<C-g>S
                      :normal          :ys
                      :normal_cur      :yss
                      :normal_line     :yS
                      :normal_cur_line :ySS
                      :visual          :S
                      :visual_line     :gS
                      :delete          :ds
                      :change          :cs}
            :surrounds {"(" {:find #(utils.get_selection {:motion "a("})
                             :add    ["( " " )"]
                             :change {:target "^(. ?)().-( ?.)()$"}
                             :delete "^(. ?)().-( ?.)()$"}
                        ")" {:find #(utils.get_selection {:motion "a)"})
                             :add    ["(" ")"]
                             :change {:target "^(.)().-(.)()$"}
                             :delete "^(.)().-(.)()$"}
                        "{" {:find #(utils.get_selection {:motion "a{"})
                             :add    ["{ " " }"]
                             :change {:target "^(. ?)().-( ?.)()$"}
                             :delete "^(. ?)().-( ?.)()$"}
                        "}" {:find #(utils.get_selection {:motion "a}"})
                             :add    ["{" "}"]
                             :change {:target "^(.)().-(.)()$"}
                             :delete "^(.)().-(.)()$"}
                        ">" {:find #(utils.get_selection {:motion "a>"})
                             :add    ["<" ">"]
                             :change {:target "^(.)().-(.)()$"}
                             :delete "^(.)().-(.)()$"}
                        "<" {:find #(utils.get_selection {:motion "a<"})
                             :add    ["< " " >"]
                             :change {:target "^(. ?)().-( ?.)()$"}
                             :delete "^(. ?)().-( ?.)()$"}
                        "[" {:find #(utils.get_selection {:motion "a["})
                             :add    ["[ " " ]"]
                             :change {:target "^(. ?)().-( ?.)()$"}
                             :delete "^(. ?)().-( ?.)()$"}
                        "]" {:find #(utils.get_selection {:motion "a]"})
                             :add    ["[" "]"]
                             :change {:target "^(.)().-(.)()$"}
                             :delete "^(.)().-(.)()$"}
                        "'" {:find #(utils.get_selection {:motion "a'"})
                             :add    ["'" "'"]
                             :change {:target "^(.)().-(.)()$"}
                             :delete "^(.)().-(.)()$"}
                        "\"" {:find #(utils.get_selection {:motion "a\""})
                              :add    ["\"" "\""]
                              :change {:target "^(.)().-(.)()$"}
                              :delete "^(.)().-(.)()$"}
                        "`" {:find #(utils.get_selection {:motion "a`"})
                             :add    ["`" "`"]
                             :change {:target "^(.)().-(.)()$"}
                             :delete "^(.)().-(.)()$"}
                        :i {:find (fn [])
                            :add (fn []
                                   (local left-delimiter
                                          (utils.get_input "Enter the left delimiter: "))
                                   (local right-delimiter
                                          (and left-delimiter
                                               (utils.get_input "Enter the right delimiter: ")))
                                   (when right-delimiter
                                     [[left-delimiter]
                                      [right-delimiter]]))
                            :change {:target (fn [])}
                            :delete (fn [])}
                        :t {:find (fn []
                                    (utils.get_selection {:textobject :t}))
                            :add (fn []
                                   (local input
                                          (utils.get_input "Enter the HTML tag: "))
                                   (when input
                                     (local element (input:match "^<?([%w-]*)"))
                                     (local attributes
                                            (input:match "%s+([^>]+)>?$"))
                                     (local open
                                            (or (and attributes
                                                     (.. element " " attributes))
                                                element))
                                     (local close element)
                                     [[(.. "<" open ">")]
                                      [(.. "</" close ">")]]))
                            :change {:replacement (fn []
                                                    (local element
                                                           (utils.get_input "Enter the HTML element: "))
                                                    (when element
                                                      [[element]
                                                       [element]]))
                                     :target "^<([%w-]*)().-([^/]*)()>$"}
                            :delete "^(%b<>)().-(%b<>)()$"}
                        :T {:find (fn []
                                    (utils.get_selection {:textobject :t}))
                            :add (fn []
                                   (local input
                                          (utils.get_input "Enter the HTML tag: "))
                                   (when input
                                     (local element (input:match "^<?([%w-]*)"))
                                     (local attributes
                                            (input:match "%s+([^>]+)>?$"))
                                     (local open
                                            (or (and attributes
                                                     (.. element " " attributes))
                                                element))
                                     (local close element)
                                     [[(.. "<" open ">")]
                                      [(.. "</" close ">")]]))
                            :change {:replacement (fn []
                                                    (local input
                                                           (utils.get_input "Enter the HTML tag: "))
                                                    (when input
                                                      (local element
                                                             (input:match "^<?([%w-]*)"))
                                                      (local attributes
                                                             (input:match "%s+([^>]+)>?$"))
                                                      (local open
                                                             (or (and attributes
                                                                      (.. element
                                                                          " "
                                                                          attributes))
                                                                 element))
                                                      (local close element)
                                                      [[open]
                                                       [close]]))
                                     :target "^<([^>]*)().-([^%/]*)()>$"}
                            :delete "^(%b<>)().-(%b<>)()$"}
                        :f {:find "[%w%-_:.>]+%b()"
                            :add (fn []
                                   (local result
                                          (utils.get_input "Enter the function name: "))
                                   (when result
                                     [[(.. result "(")]
                                      [")"]]))
                            :change {:replacement (fn []
                                                    (local result
                                                           (utils.get_input "Enter the function name: "))
                                                    (when result
                                                      [[result]
                                                       [""]]))
                                     :target "^.-([%w_]+)()%b()()()$"}
                            :delete "^([%w%-_:.>]+%()().-(%))()$"}
                        :invalid_key_behavior {:find (fn [char]
                                                       (utils.get_selection {:pattern (..
                                                                                        (vim.pesc char)
                                                                                        ".-"
                                                                                        (vim.pesc char))}))
                                               :add (fn [char]
                                                      [[char]
                                                       [char]])
                                               :change {:target (fn [char]
                                                                  (utils.get_selections {:pattern "^(.)().-(.)()$"
                                                                                         : char}))}
                                               :delete (fn [char]
                                                         (utils.get_selections {:pattern "^(.)().-(.)()$"
                                                                                : char}))}
                        :l {:find "%b[]%b()"
                            :add (fn []
                                   (local clipboard (: (vim.fn.getreg "+") :gsub "\n" ""))
                                   [["["]
                                    [(.. "](" clipboard ")")]])
                            :change {:target "^()()%b[]%((.-)()%)$"
                                     :replacement (fn []
                                                    (local clipboard
                                                           (: (vim.fn.getreg "+") :gsub
                                                              "\n" ""))
                                                    [[""]
                                                     [clipboard]])}
                            :delete "^(%[)().-(%]%b())()$"}
                        :t {:add (fn []
                                   [["\"${"]
                                    ["}\""]])}}
            :aliases {:a ">"
                      :b ")"
                      :B "}"
                      :r "]"
                      :q ["\""
                          "'"
                          "`"]
                      :s [")"
                          "]"
                          "}"
                          ">"
                          "'"
                          "\""
                          "`"]}
            :highlight {:duration 0}
            :move_cursor :begin}]
  ((. (require :nvim-surround) :setup) opt)))

{1 :kylechui/nvim-surround
 : config}
