(fn config []
  (let [headlines (require :headlines)
        dk (require :def-keymaps)
        opt {:markdown {:codeblock_highlight :CodeBlock
                        :dash_highlight :Dash
                        :dash_string "-"
                        :fat_headline_lower_string "🬂"
                        :fat_headline_upper_string "▃"
                        :fat_headlines true
                        :headline_highlights [:Headline]
                        :bullet_hightlights
                          ["@text.title.1.marker.markdown"
                           "@text.title.2.marker.markdown"
                           "@text.title.3.marker.markdown"
                           "@text.title.4.marker.markdown"
                           "@text.title.5.marker.markdown"
                           "@text.title.6.marker.markdown"]
                        :bullets
                          ["◉" "○" "✸" "✿"]
                        :query (vim.treesitter.query.parse
                                 :markdown
                                 "
                                    (atx_heading [
                                      (atx_h1_marker)
                                      (atx_h2_marker)
                                      (atx_h3_marker)
                                      (atx_h4_marker)
                                      (atx_h5_marker)
                                      (atx_h6_marker)
                                    ] @headline)
                                    (thematic_break) @dash
                                    (fenced_code_block) @codeblock
                                    (block_quote_marker) @quote
                                    (block_quote (paragraph (inline (block_continuation) @quote)))
                                "
                                :quote_highlight :Quote
                                :quote_string "┃")}}]
    (headlines.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{1 :lukas-reineke/headlines.nvim
 :dependencies [;; :nvim-orgmode/orgmode
                :nvim-treesitter/nvim-treesitter]
 :tag :v4.0.0
 :ft [:markdown :neorg]
 : config}
