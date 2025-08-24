(fn after []
   (let [dk (require :def-keymaps)
         tiny-inline-diagnostic (require :tiny-inline-diagnostic)
         opt {:preset :modern
              :options {:multilines true
                        :multiple_diag_under_cursor true
                        :show_all_diags_on_cursorline true}}]
     (tiny-inline-diagnostic.setup opt)

     (vim.diagnostic.config
       {:virtual_text false
        :float false})
     (dk :n
         {:t {:group :Toggle
              :d [tiny-inline-diagnostic.toggle
                  "Diagnostics"]}}
         {:prefix :<leader>})))

{:src "https://github.com/rachartier/tiny-inline-diagnostic.nvim"
 :data {:priority 1000
        :event :DeferredUIEnter
        : after}}
