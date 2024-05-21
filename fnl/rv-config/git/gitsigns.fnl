(fn config []
  (let [gitsigns (require :gitsigns)
        gitsigns-actions (require :gitsigns.actions)
        dk (require :def-keymaps)
        opt {:signs
               {:add
                  {:hl :GitSignsAdd
                   :text "│"
                   :numhl :GitSignsAddNr
                   :linehl :GitSignsAddLn}
                :change
                  {:hl :GitSignsChange
                   :text "│"
                   :numhl :GitSignsChangeNr
                   :linehl :GitSignsChangeLn}
                :changedelete
                  {:hl :GitSignsChange
                                :text "~"
                                :numhl :GitSignsChangeNr
                                :linehl :GitSignsChangeLn}
                :delete
                  {:hl :GitSignsDelete
                   :text "_"
                   :numhl :GitSignsDeleteNr
                   :linehl :GitSignsDeleteLn}
                :topdelete
                  {:hl :GitSignsDelete
                   :text "‾"
                   :numhl :GitSignsDeleteNr
                   :linehl :GitSignsDeleteLn}}
             :numhl false
             :linehl false
             :watch_gitdir
               {:interval 1000
                :follow_files true}
             :sign_priority 6
             :update_debounce 100
             ;; Use default
             :status_formatter nil
             :word_diff false
             :diff_opts
               {;; If luajit is present
                :internal true}}]
    (gitsigns.setup opt)

    (let [mappings
            {:g {:name :Git
                 :h {:name :Hunks
                     :s [gitsigns.stage_hunk         "Stage Hunk"]
                     :u [gitsigns.undo_stage_hunk    "Undo Stage Hunk"]
                     :r [gitsigns.reset_hunk         "Reset Hunk"]
                     :R [gitsigns.reset_buffer       "Reset Buffer"]
                     :p [gitsigns.preview_hunk       "Preview Hunk"]
                     :b [#(gitsigns.blame_line true) "Blame Line"]}}
             :t {:name :Toggle
                 :g {:name :Git
                     :w [gitsigns.toggle_word_diff          "Word Diff"]
                     :n [gitsigns.toggle_numhl              "Number HL"]
                     :l [gitsigns.toggle_linehl             "Line HL"]
                     :s [gitsigns.toggle_signs              :Signs]
                     :b [gitsigns.toggle_current_line_blame "Current Line Blame"]}}}
          visual-mappings
            {:h {:name :Hunk
                 :s [#(gitsigns.stage_hunk
                        [(vim.fn.line ".")
                         (vim.fn.line :v)])
                     :Stage]
                 :r [#(gitsigns.reset_hunk
                        [(vim.fn.line ".")
                         (vim.fn.line :v)])
                     :Reset]}}
          operator-mappings
            {:i {:name :Inside
                 :h [gitsigns-actions.select_hunk :Hunk]}}
          direct-mappings
            {"]c" [gitsigns-actions.next_hunk "Next Hunk"]
             "[c" [gitsigns-actions.prev_hunk "Prev Hunk"]}]
      (dk :n
          mappings
          {:prefix :<leader>})
      (dk :v
          visual-mappings
          {:prefix :<leader>})
      (dk [:o :x]
          operator-mappings
          {:prefix :<leader>})
      (dk :n
          direct-mappings))))

{1 :lewis6991/gitsigns.nvim
 :dependencies [:nvim-lua/plenary.nvim]
 :event :BufRead
 : config}
