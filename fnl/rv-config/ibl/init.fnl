(fn config []
  (let [ibl (require :ibl)
        hooks (require :ibl.hooks)
        dk (require :def-keymaps)
        opt {:debounce 50
             :indent {:char "¦"
                      :tab_char "|"}
             :whitespace {:highlight [:Whitespace]}
             :scope {:enabled true
                     :show_start false
                     :show_end false
                     :highlight
                      [:RainbowDelimiterRed
                       :RainbowDelimiterYellow
                       :RainbowDelimiterBlue
                       :RainbowDelimiterOrange
                       :RainbowDelimiterGreen
                       :RainbowDelimiterViolet
                       :RainbowDelimiterCyan]}}]

    (ibl.setup opt)
    (hooks.register
      hooks.type.SCOPE_HIGHLIGHT
      hooks.builtin.scope_highlight_from_extmark)

    (dk [:n]
        {:t {:name :Toggle
             :i [#(if vim.o.list
                      (do
                        (set vim.opt.list false)
                        (vim.cmd "IBLDisable")
                        (vim.cmd "IBLDisableScope"))
                      (do
                        (set vim.opt.list true)
                        (vim.cmd "IBLEnable")
                        (vim.cmd "IBLEnableScope")))
                 "Indentations"]}}
        {:prefix :<leader>})))

{: config}
