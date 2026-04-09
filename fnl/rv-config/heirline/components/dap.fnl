(let [{: heirline
       : conditions
       : utils
       : colors
       : navic
       : icons}
      (require :rv-config.heirline.common)

      ;; DAP-Messages - only shows when dap is loaded and active.
      ;; Do not require `dap` here just to probe state; keep it passive.
      DAP-Messages
      {:condition (fn [self]
                   ;; Only check if dap is already loaded - don't trigger require
                   (let [dap (. package.loaded :dap)]
                     (when dap
                       (let [session (dap.session)]
                         (if session
                           (let [filename (vim.api.nvim_buf_get_name 0)]
                             (if session.config
                               (let [progname session.config.progname]
                                 (= filename progname))
                               false))
                           false)))))}]


  {: DAP-Messages})
