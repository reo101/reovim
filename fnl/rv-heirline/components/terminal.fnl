(let [{: colors}
      (require :rv-heirline.common)

      ;; Terminal-Name
      Terminal-Name
      {:provider (fn [self]
                   (let [(tname _)
                         (: (vim.api.nvim_buf_get_name 0) :gsub
                            ".*;"
                            "")]
                     (.. " " tname)))
       :hl       {:fg   colors.blue
                  :bold true}}]


  {: Terminal-Name})
