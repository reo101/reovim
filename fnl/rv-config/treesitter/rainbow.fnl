(fn config []
  (let [rainbow-delimiters (require "rainbow-delimiters")]
    (tset vim.g :rainbow_delimiters
          {:strategy {""   (. rainbow-delimiters :strategy :global)
                      :vim (. rainbow-delimiters :strategy :local)}
           :query    {""   :rainbow-delimiters
                      :lua :rainbow-blocks}
           :highlight [:RainbowDelimiterRed
                       :RainbowDelimiterYellow
                       :RainbowDelimiterBlue
                       :RainbowDelimiterOrange
                       :RainbowDelimiterGreen
                       :RainbowDelimiterViolet
                       :RainbowDelimiterCyan]})))

{: config}
