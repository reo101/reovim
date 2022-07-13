(let [{: colors}
      (require :rv-heirline.common)

      ;; Help-Filename
      Help-Filename
      {:hl        {:fg colors.blue}
       :condition (fn [self]
                    (= vim.bo.filetype :help))
       :provider  (fn [self]
                    (let [filename (vim.api.nvim_buf_get_name 0)]
                      (vim.fn.fnamemodify filename ":t")))}]


  {: Help-Filename})
