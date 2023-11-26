(fn config []
  (let [headlines (require :headlines)
        dk (require :def-keymaps)
        opt {:markdown {:codeblock_highlight :CodeBlock
                        :dash_highlight :Dash
                        :dash_string "-"
                        :fat_headline_lower_string "🬂"
                        :fat_headline_upper_string "▃"
                        :fat_headlines false
                        :headline_highlights [:Headline]
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

    (dk [:n]
        {}
        {:prefix :<leader>})))

{: config}
