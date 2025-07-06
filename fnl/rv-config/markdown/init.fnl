(fn after []
  (let [markdown (require :markview)
        presets  (require :markview.presets)
        dk (require :def-keymaps)
        opt {:preview
              {;; Whether to show preview automatically
               :enable true
               ;; Buffer types to ignore
               :buf_ignore ["nofile"]
               ;; Delay, in miliseconds
               ;; to wait before a redraw occurs(after an event is triggered)
               :debounce 50
               ;; Filetypes where the plugin is enabled
               :filetypes ["markdown" "quarto" "rmd"]
               ;; Modes where preview is shown
               :modes ["n" "c"]
               ;; Modes where hybrid mode is enabled
               :hybrid_modes ["n"]
               ;; Max buffer size that is rendered entirely
               :max_buf_lines 1000
               ;; Lines from the cursor to draw when the
               ;; file is too big
               :draw_range 100
               ;; Window configuration for split view
               :splitview_winopts {}
               :callbacks {}}
             ;; Rendering related configuration
             :escaped {}
             :markdown_inline
              {:footnotes {:default {}}
               :checkboxes presets.checkboxes.nerd}
             :markdown
              {:headings (vim.tbl_deep_extend
                           :force
                           presets.headings.arrowed
                           {:heading_1 {:sign ""}
                            :heading_2 {:sign ""}
                            :heading_3 {:sign ""}
                            :heading_4 {:sign ""}
                            :heading_5 {:sign ""}
                            :heading_6 {:sign ""}})
               :block_quotes {}
               :code_blocks {}
               :horizontal_rules presets.horizontal_rules.arrowed
               :html {}
               :inline_codes {}
               :latex {}
               :links {}
               :list_items {:indent_size 1
                            :shift_width 1}
               :tables {}}}]
    (markdown.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{:src "https://github.com/OXY2DEV/markview.nvim"
 :version :25
 :data {:ft [:markdown]
        : after}}
