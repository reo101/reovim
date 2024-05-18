(fn config []
  (let [dk (require :def-keymaps)
        rainbow-delimiters (require "rainbow-delimiters")
        opt {:strategy {""   (. rainbow-delimiters :strategy :global)
                        :vim (. rainbow-delimiters :strategy :local)}
             :query    {""   :rainbow-delimiters
                        :lua :rainbow-blocks}
             :priority {:agda 500}
             :highlight [:RainbowDelimiterRed
                         :RainbowDelimiterYellow
                         :RainbowDelimiterBlue
                         :RainbowDelimiterOrange
                         ;; :RainbowDelimiterGreen
                         :RainbowDelimiterViolet
                         :RainbowDelimiterCyan]}]
    (tset vim.g :rainbow_delimiters opt)

    (dk :n
        {:t {:name :Toggle
             :s {:name  :TreeSitter
                 :r [#(rainbow-delimiters.toggle 0) "Rainbow Delimiters"]}}}
        {:prefix :<leader>})))


{1 :HiPhish/rainbow-delimiters.nvim
 :event :BufRead
 : config}
