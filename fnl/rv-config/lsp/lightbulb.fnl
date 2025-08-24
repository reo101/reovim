(fn after []
   (let [opt {:status_text {:text "💡"
                            :text_unavailable ""
                            :enabled false}
              :sign {:enabled true
                     :priority 10}
              :virtual_text {:enabled false
                             :text "💡"}
              :float {:text "💡"
                      :enabled false
                      :win_opts {}}}]
     ((. (require :nvim-lightbulb) :update_lightbulb) opt)
     (vim.cmd "autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()")))

{: after}
