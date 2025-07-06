(let [{: heirline
       : conditions
       : utils
       : colors
       : navic
       : luasnip
       : icons}
      (require :rv-config.heirline.common)

      NavicNonemptyIndicator
      :Nonempty

      ;; Navic
      Navic
      {:condition (fn [self]
                    (and (navic.is_available)
                         (not= (navic.get_data) nil)
                         (when (not= (next (navic.get_data)) nil)
                            NavicNonemptyIndicator)))
       :static    {:type_hl {:File          "Directory"
                             :Module        "@include"
                             :Namespace     "@namespace"
                             :Package       "@include"
                             :Class         "@struct"
                             :Method        "@method"
                             :Property      "@property"
                             :Field         "@field"
                             :Constructor   "@constructor"
                             :Enum          "@field"
                             :Interface     "@type"
                             :Function      "@function"
                             :Variable      "@variable"
                             :Constant      "@constant"
                             :String        "@string"
                             :Number        "@number"
                             :Boolean       "@boolean"
                             :Array         "@field"
                             :Object        "@type"
                             :Key           "@keyword"
                             :Null          "@comment"
                             :EnumMember    "@field"
                             :Struct        "@struct"
                             :Event         "@keyword"
                             :Operator      "@operator"
                             :TypeParameter "@type"}
                   ;; line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
                   :enc     (fn [line col winnr]
                              (bit.bor (bit.lshift line 16
                                         (bit.lshift col 6)
                                         winnr)))
                   :dec     (fn [c]
                              (let [line  (bit.rshift c 16)
                                    col   (bit.band (bit.rshift c) 1023)
                                    winnr (bit.band c 63)]
                                (values line col winnr)))}
       :init      (fn [self]
                    (let [data (or (navic.get_data) {})
                          children {}]
                      (each [i d (ipairs data)]
                        (local pos (self.enc d.scope.start.line
                                             d.scope.start.character
                                             self.winnr))
                        (local child [{:provider d.icon
                                       :hl (. self.type_hl d.type)}
                                      {:provider (-> d.name
                                                     (: :gsub "%%" "%%%%")
                                                     (: :gsub "%s*->%s*" ""))
                                       :on_click {:minwid pos
                                                  :callback
                                                    (fn [_ minwid]
                                                      (let [(line col winnr) (self.dec minwid)]
                                                         (vim.api.nvim_win_set_cursor
                                                           (vim.fn.win_getid winnr)
                                                           [line
                                                            col])))
                                                  :name :heirline_navic}}])
                        ;; Add separator on all but the last child
                        (when (< (math.max 1 i)
                                 (length data))
                          (table.insert child {:provider "  " ;; NOTE: was >, now 
                                               :hl       {:fg colors.orange}}))
                        (table.insert children child))
                     (set self.child (self:new children 1))))
       :provider (fn [self]
                   (self.child:eval))
       :hl {:fg :gray}
       :update [:BufRead
                :CursorMoved
                :CursorMovedI]}]

  {: Navic
   : NavicNonemptyIndicator})
