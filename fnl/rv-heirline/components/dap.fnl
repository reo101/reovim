(let [{: heirline
       : conditions
       : utils
       : colors
       : gps
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-heirline.common)

      ;; DAP-Messages
      DAP-Messages
      {:condition (fn [self]
                    (let [session (dap.session)]
                      (if session
                        (let [filename (vim.api.nvim_buf_get_name 0)]
                          (if session.config
                            (let [progname session.config.progname]
                              (= filename progname))
                            false))
                        false)))}]


  {: DAP-Messages})
