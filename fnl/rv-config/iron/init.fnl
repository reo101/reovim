(fn after []
  (let [iron (require :iron.core)
        iron-view (require :iron.view)
        dk (require :def-keymaps)
        opt {:config {;; Whether a repl should be discarded or not
                      :scratch_repl true
                      ;; Your repl definitions come here
                      :repl_definition
                        {:sh
                          {;; Can be a table or a function that
                           ;; returns a table (see below)
                           :command
                            [:zsh]}}
                      :repl_open_cmd
                        (iron-view.bottom 40)}
             ;; Iron doesn't set keymaps by default anymore.
             ;; You can set them here or manually add keymaps to the functions in iron.core
             :keymaps
               {:send_motion       :<leader>isc
                :visual_send       :<leader>isc
                :send_file         :<leader>isf
                :send_line         :<leader>isl
                :send_until_cursor :<leader>isu
                :send_mark         :<leader>ism
                :mark_motion       :<leader>imc
                :mark_visual       :<leader>imc
                :remove_mark       :<leader>imd
                :cr                :<leader>is<cr>
                :interrupt         :<leader>is<leader>
                :exit              :<leader>isq
                :clear             :<leader>icl}
             ;; If the highlight is on, you can change how it looks
             ;; For the available options, check nvim_set_hl
             :highlight {:italic true}
             ;; Ignore blank lines when sending visual select lines
             :ignore_blank_lines true}]
    (iron.setup opt)

    (dk :n
        {:r {:group :Repl
             :s [:<cmd>IronRepl<cr>]
             :r [:<cmd>IronRestart<cr>]
             :f [:<cmd>IronFocus<cr>]
             :h [:<cmd>IronHide<cr>]}}
        {:prefix :<leader>})))

{:src "https://github.com/Vigemus/iron.nvim"
 :version :v9.1.1
 :data {:enabled false
        : after}}
