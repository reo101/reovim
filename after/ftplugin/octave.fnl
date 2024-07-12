(local Terminal (. (require :toggleterm.terminal)
                   :Terminal))

(local octave
       (Terminal:new
         {:close_on_exit true
          :cmd           "octave -qf"
          :hidden        true
          :on_close      #(vim.notify "Octave closed")
          :on_open       #(vim.notify "Octave opened")}))

(let [dk (require :def-keymaps)
      mappings {:t {:group :Toggle
                    :o [#(octave:toggle) :Octave]}}]
  (dk mappings {:prefix :<leader>}))
