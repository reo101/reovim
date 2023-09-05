(fn config []
  (let [ibl (require :ibl)
        hooks (require :ibl.hooks)
        dk (require :def-keymaps)
        opt {:debounce 50
             :indent {:char "¦"}
             :whitespace {:highlight [:Whitespace]}
             :scope {:highlight
                      [:RainbowDelimiterRed
                       :RainbowDelimiterYellow
                       :RainbowDelimiterBlue
                       :RainbowDelimiterOrange
                       :RainbowDelimiterGreen
                       :RainbowDelimiterViolet
                       :RainbowDelimiterCyan]}}]

    (tset vim.opt :listchars
          {;; :space  "."
           :nbsp "␣"
           :trail ""
           ;; :eol "↴"
           :tab "󰁍󰁔"})
    (tset vim.opt :list true)

    (tset vim.opt :showbreak "☇") ;; "↪"
    (tset vim.opt :breakat " \t;:,])}")
    (tset vim.opt :breakindent true)
    (tset vim.opt :breakindentopt ["shift:0" "list:0" "min:40" "sbr"])
    ;; (tset vim.opt :showbreak ">>")

    ;; (vim.cmd "highlight ExtraWhitespace ctermbg=red guibg=red")
    ;; (vim.cmd "match ExtraWhitespace /\s\+$/")
    ;; (vim.cmd "autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/")

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
