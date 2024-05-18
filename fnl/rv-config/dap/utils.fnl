(local dk (require :def-keymaps))
(local dap (require :dap))

(fn dap-mappings []
  (dk :n
      {:d {:name :DAP
           :b {:name :Breakpoint
               :t [dap.toggle_breakpoint :Toggle]
               :c [#(dap.set_breakpoint
                      (vim.fn.input
                        "Breakpoint condition: "))
                   "Set conditional"]}
            :c [dap.continue :Continue]
            :C [dap.run_to_cursor "Run to Cursor"]
            :s {:name :Step
                :hydra true
                :o [dap.step_over :Over]
                :i [dap.step_into :Into]
                :u [dap.step_out  :Out]
                :b [dap.step_back :Back]}
            :p [dap.pause :Pause]
            :r [dap.repl.toggle :REPL]
            :d [dap.disconnect :Disconnect]
            :q [dap.close :Quit]
            :g [dap.session "Get Session"]}}
      {:prefix :<leader>}))

(fn dap-override-icons []
    (local signs
           {:Breakpoint
              {:linehl ""
               :numhl ""
               :text "󰃤"
               :texthl :DiagnosticSignError}
            :BreakpointCondition
              {:linehl ""
               :numhl ""
               :text "󰃤"
               :texthl :DiagnosticSignHint}
            :BreakpointRejected
              {:linehl ""
               :numhl ""
               :text "󰃤"
               :texthl :DiagnosticSignHint}
            :Stopped
              {:linehl :DiagnosticUnderlineInfo
               :numhl :DiagnosticSignInformation
               :text ""
               :texthl :DiagnosticSignInformation}})
    (each [dap-type sign-data (pairs signs)]
      (vim.fn.sign_define
        (.. :Dap dap-type)
        sign-data)))

(fn dap-set-repl []
  (set dap.defaults.fallback.terminal_win_cmd "50vsplit new")
  (vim.api.nvim_create_autocmd
    :FileType
    {:pattern :dap-repl
     :callback #((. (require :dap.ext.autocompl)
                    :attach))}))

{: dap-mappings
 : dap-override-icons
 : dap-set-repl}
