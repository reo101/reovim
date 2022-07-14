(fn config []
 (let [utils (require :nvim-surround.utils)
       opt {:keymaps {:insert      :ys
                      :insert_line :yss
                      :visual      :S
                      :delete      :ds
                      :change      :cs}
            :delimiters {:pairs {"(" ["( " " )"] ")" ["("   ")"]
                                 "{" ["{ " " }"] "}" ["{"   "}"]
                                 "<" ["< " " >"] ">" ["<"   ">"]
                                 "[" ["[ " " ]"] "]" ["["   "]"]
                                 "i" #[(utils.get_input "Enter the left delimiter: ")
                                       (utils.get_input "Enter the right delimiter: ")]
                                 "f" #[(.. (utils.get_input "Enter the function name: ")
                                           "(")
                                       ")"]}
                         :separators {"'"  ["'"  "'"]
                                      "\"" ["\"" "\""]
                                      "`"  ["`"  "`"]}
                         :HTML {:t :type
                                :T :whole}
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
                                       "`"]}}
            :highlight_motion {:duration 0}}]
  ((. (require :nvim-surround) :setup) opt)))

{: config}
