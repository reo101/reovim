(fn after []
  (let [nvim-dap-virtual-text (require :nvim-dap-virtual-text)
        opt {:enable_commands true
             :highlight_changed_variables true
             :highlight_new_as_changed true
             :show_stop_reason true
             :commented false
             :only_first_definition false
             :all_references false
             :clear_on_continue false
             :display_callback
               (fn [{: name : value}]
                 (if (let [name (name:lower)
                           value (value:lower)
                           keywords [:secret :api]]
                       (-> keywords
                           vim.iter
                           (: :any #(or (name:match $)
                                        (value:match $)))))
                     "*****"
                     (> (length value) 15)
                     (.. " " (value:sub 1 15) "...")
                     ;; else
                     (.. " " value)))
             :virt_text_pos :inline
             :all_frames true
             :virt_lines false
             :virt_text_win_col nil}]
    (nvim-dap-virtual-text.setup opt)))

{:src "https://github.com/theHamsta/nvim-dap-virtual-text"
 :data {:dependencies [:mfussenegger/nvim-dap]
        :keys [:<leader>d]
        : after}}
