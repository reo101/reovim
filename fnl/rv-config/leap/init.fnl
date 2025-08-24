(fn after []
  (let [leap (require :leap)
        dk  (require :def-keymaps)
        opt {:case_sensitive false
             ;; Groups of characters that should match each other.
             ;; Obvious candidates are braces & quotes
             :equivalence_classes [" \t\r\n"]
             :highlight_unlabeled_phase_one_targets false
             :substitute_chars {}
             ;; Leaving the appropriate list empty effectively disables "smart" mode,
             ;; and forces auto-jump to be on or off.
             :safe_labels nil
             :labels      nil
             ;; These keys are captured directly by the plugin at runtime.
             ;; (For `prev_match`, I suggest <s-enter> if possible in the terminal/GUI.)
             :special_keys {;; :repeat_search :<enter>
                            :next_match    :<enter>
                            :prev_match    :<tab>
                            :next_group    :<space>
                            :prev_group    :<tab>}}]
    (dk [:n :x :o]
        {:h {:group "Leap (Hop)"
             :s ["<Plug>(leap-forward)"     "Leap Forward"]
             :S ["<Plug>(leap-backward)"    "Leap Backward"]
             :w ["<Plug>(leap-from-window)" "Leap From Window"]}}
        {:prefix :<leader>})
    (dk :o
        {:h {:group "Leap (Hop)"
             :x ["<Plug>(leap-forward-x)"  "Leap Forward (x)"]
             :X ["<Plug>(leap-backward-x)" "Leap Backward (x)"]}}
        {:prefix :<leader>})
    (vim.tbl_extend :force leap.opts opt)))
    ;; (tset leap :opts opt)))

[{:src "https://github.com/ggandor/leap.nvim"
  :data {:dependencies [:tpope/vim-repeat]
         : after
         :enabled false}}
 (require (.. ... :.ast))]
