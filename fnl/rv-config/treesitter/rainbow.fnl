(fn after []
  (let [dk (require :def-keymaps)
        rainbow-delimiters (require :rainbow-delimiters)
        opt {:strategy {""   (. rainbow-delimiters :strategy :global)
                        :vim (. rainbow-delimiters :strategy :local)}
             :query    {""   :rainbow-delimiters
                        :lua :rainbow-blocks}
             :priority {:agda 500
                        :fsharp 200}
             :highlight [:RainbowDelimiterRed
                         :RainbowDelimiterYellow
                         :RainbowDelimiterBlue
                         :RainbowDelimiterOrange
                         ;; :RainbowDelimiterGreen
                         :RainbowDelimiterViolet
                         :RainbowDelimiterCyan]}]
    (tset vim.g :rainbow_delimiters opt)

    (dk :n
        {:t {:group :Toggle
             :s {:group  :TreeSitter
                 :r [#(rainbow-delimiters.toggle 0) "Rainbow Delimiters"]}}}
        {:prefix :<leader>})))


{:src "https://github.com/HiPhish/rainbow-delimiters.nvim"
 :data {:dep_of [:indent-blankline.nvim]
        :event :BufRead
        : after}}
