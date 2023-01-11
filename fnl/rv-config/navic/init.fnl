(fn config []
  (let [opt {:depth_limit_indicator ".."
             :icons {:File          " "
                     :Module        " "
                     :Namespace     " "
                     :Package       " "
                     :Class         " "
                     :Method        " "
                     :Property      " "
                     :Field         " "
                     :Constructor   " "
                     :Enum          "練"
                     :Interface     "練"
                     :Function      " "
                     :Variable      " "
                     :Constant      " "
                     :String        " "
                     :Number        " "
                     :Boolean       "◩ "
                     :Array         " "
                     :Object        " "
                     :Key           " "
                     :Null          "ﳠ "
                     :EnumMember    " "
                     :Struct        " "
                     :Event         " "
                     :Operator      " "
                     :TypeParameter " "}
             :highlight true
             :separator " > "
             :depth_limit 0}]

    ((. (require :nvim-navic) :setup) opt)))

{: config}

