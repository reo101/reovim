(fn config []
  (let [opt {:lsp {:override {:vim.lsp.util.stylize_markdown                true
                              :vim.lsp.util.convert_input_to_markdown_lines true
                              :cmp.entry.get_documentation                  true}
                   :hover    {:opts {:border :single}}}
             :presets {:bottom_search         true
                       :command_palette       true
                       :long_message_to_split true
                       :lsp_doc_border        false
                       :inc_rename            false}}]

    ((. (require :noice) :setup) opt)))

{: config}
