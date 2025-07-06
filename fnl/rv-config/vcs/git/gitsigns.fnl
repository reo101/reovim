(fn after []
  (let [gitsigns (require :gitsigns)
        gitsigns-actions (require :gitsigns.actions)
        dk (require :def-keymaps)
        opt {:signs
               {:add          {:text "│"}
                :change       {:text "│"}
                :delete       {:text "_"}
                :topdelete    {:text "‾"}
                :changedelete {:text "~"}
                :untracked    {:text "┆"}}
             ;; FIXME: signs
             :signcolumn true
             :numhl false
             :linehl false
             :word_diff false
             :watch_gitdir
               {:interval 1000
                :follow_files true}
             :auto_attach true
             :attach_to_untracked true
             :current_line_blame false
             :current_line_blame_opts
               {:virt_text true
                ;; :eol | :overlay | :right_align
                :virt_text_pos :eol
                :delay 1000
                :ignore_whitespace false
                :virt_text_priority 100}
             :current_line_blame_formatter "<author>, <author_time:%R> - <summary>"
             ;; NOTE: higher than `gitsigns`
             :sign_priority 10
             :update_debounce 100
             ;; Use default
             :status_formatter nil
             ;; Disable if file is longer than this (in lines)
             :max_file_length 40000
             :preview_config
               {;; Options passed to nvim_open_win
                :border "single"
                :style "minimal"
                :relative "cursor"
                :row 0
                :col 1}}]
    (gitsigns.setup opt)

    (let [mappings
            {:g {:group :Git
                 :h {:group :Hunks
                     :s [gitsigns.stage_hunk      "Stage Hunk"]
                     :u [gitsigns.undo_stage_hunk "Undo Stage Hunk"]
                     :r [gitsigns.reset_hunk      "Reset Hunk"]
                     :R [gitsigns.reset_buffer    "Reset Buffer"]
                     :p [gitsigns.preview_hunk    "Preview Hunk"]
                     :d [gitsigns.diffthis        "Diff Hunk"]
                     :d [#(gitsigns.diffthis "~") "Diff Hunk"]
                     :b [#(gitsigns.blame_line {:full true}) "Blame Line"]}}
             :t {:group :Toggle
                 :g {:group :Git
                     :w [gitsigns.toggle_word_diff "Word Diff"]
                     :n [gitsigns.toggle_numhl     "Number HL"]
                     :l [gitsigns.toggle_linehl    "Line HL"]
                     :s [gitsigns.toggle_signs     "Signs"]
                     :b [gitsigns.toggle_current_line_blame "Current Line Blame"]}}}
          visual-mappings
            {:h {:group :Hunk
                 :s [#(gitsigns.stage_hunk
                        [(vim.fn.line ".")
                         (vim.fn.line :v)])
                     :Stage]
                 :r [#(gitsigns.reset_hunk
                        [(vim.fn.line ".")
                         (vim.fn.line :v)])
                     :Reset]}}
          operator-mappings
            {:i {:group :Inside
                 ;; :h [gitsigns-actions.select_hunk :Hunk]}}
                 :h [":<C-U>Gitsigns select_hunk<CR>" :Hunk]}}
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
          operator-mappings)
      (dk :n
          direct-mappings))))

{:src "https://github.com/lewis6991/gitsigns.nvim"
 :version :v0.9.0
 :data {:dependencies [:nvim-lua/plenary.nvim]
        :event :BufRead
        : after
        ;; FIXME: slows down markdown for some reason
        :enabled true}}
