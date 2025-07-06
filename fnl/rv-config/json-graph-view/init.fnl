(fn after []
  (let [videre (require :videre)
        dk (require :def-keymaps)
        opt {;; Set the window editor type
             :editor_type :split ;; split, floating

             ;; Configure the floating window style
             :floating_editor_style
              {:margin 2
               :border :double
               :zindex 10}

             ;; Number of lines before collapsing
             :max_lines 5

             ;; Set the unit style to round
             :round_units true

             ;; Set the connection style to round
             :round_connections true

             ;; Disable line wrapping for the graph buffer
             :disable_line_wrap true

             ;; Set the priority of keymaps for the quick action keymap
             :keymap_priorities
              {:expand 4
               :collapse 2
               :link_forward 3
               :link_backward 3
               :set_as_root 1}

             ;; Set the keys actions will be mapped to
             :keymaps
              {:expand :E          ;; Expanding collapsed areas
               :collapse :E        ;; Collapse expanded areas
               :link_forward :L    ;; Jump to linked unit
               :link_backward :B   ;; Jump back to unit parent
               :set_as_root :R     ;; Set current unit as root
               :quick_action :<CR> ;; Aliased to first priority available keymap
               :close_window :q}}] ;; Close the window

    (videre.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

[{:src "https://github.com/Owen-Dechow/graph_view_yaml_parser"
  :data {:dep_of [:videre.nvim]}}
 {:src "https://github.com/Owen-Dechow/videre.nvim"
  :data {: after}}]
