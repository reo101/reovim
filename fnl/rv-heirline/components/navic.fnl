(let [{: heirline
       : conditions
       : utils
       : colors
       : gps
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-heirline.common)

      ;; Navic
      Navic
      {:static {:type_hl {:File          :Directory
                          :Module        :Include
                          :Namespace     :TSNamespace
                          :Package       :Include
                          :Class         :Struct
                          :Method        :Method
                          :Property      :TSProperty
                          :Field         :TSField
                          :Constructor   :TSConstructor
                          :Enum          :TSField
                          :Interface     :Type
                          :Function      :Function
                          :Variable      :TSVariable
                          :Constant      :Constant
                          :String        :String
                          :Number        :Number
                          :Boolean       :Boolean
                          :Array         :TSField
                          :Object        :Type
                          :Key           :TSKeyword
                          :Null          :Comment
                          :EnumMember    :TSField
                          :Struct        :Struct
                          :Event         :Keyword
                          :Operator      :Operator
                          :TypeParameter :Type}}
       :condition (fn [self]
                    (and (navic.is_available)
                         (not= (navic.get_data) nil)
                         (not= (length (navic.get_data)) 0)))
       :hl {:fg :gray}
       :init (fn [self]
               (local data (or (navic.get_data) {}))
               (local children {})
               (each [i d (ipairs data)]
                 (local child
                   [{:provider d.icon
                     :hl       (. self.type_hl d.type)}
                    {:provider d.name
                     :hl       {:fg colors.cyan}}])
                 ;; Add separator on all but the last child
                 (when (and (> (length data) 1)
                            (< i (length data)))
                   (table.insert child {:provider "  " ;; NOTE: was >, now 
                                        :hl       {:fg colors.orange}}))
                 (table.insert children child))
               (tset self 1 (self:new children 1)))}]

  {: Navic})
