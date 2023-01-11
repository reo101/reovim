(let [{: heirline
       : conditions
       : utils
       : colors
       : gps
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-config.heirline.common)

      ;; Gps
      Gps
      {:static {:type_hl {}}
       :condition gps.is_available
       :init (fn [self]
               (local data (or (gps.get_data) {}))
               (local children {})
               (each [i d (ipairs data)]
                 (let [child [{:provider d.icon
                               :hl       (or (. self.type_hl d.type)
                                             {:fg colors.cyan})}
                              {:provider d.text
                               :hl       {:fg colors.white}}]]
                      ;; Add separator on all but the last child
                   (when (and (> (length data) 1)
                              (< i (length data)))
                     (table.insert child {:provider "  " ;; NOTE: was >, now 
                                          :hl       {:fg colors.orange}}))
                   (table.insert children child)))
               (tset self 1 (self:new children 1)))}]

  {: Gps})
