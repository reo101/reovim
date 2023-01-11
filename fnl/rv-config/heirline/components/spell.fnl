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

      ;; Spell
      Spell
      {:condition (fn [self]
                    vim.wo.spell)
       :provider  "SPELL "
       :hl        {:fg   colors.orange
                   :bold true}}]
  {: Spell})
