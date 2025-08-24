(fn after []
  (let [opt {:lsp
              {:override
                {:vim.lsp.util.stylize_markdown                true
                 :vim.lsp.util.convert_input_to_markdown_lines true
                 :cmp.entry.get_documentation                  true
                 :hover    {:opts {:border :single}}}}
             :cmdline
              {:format
                {:fennel
                   {:pattern ["^:%s*Fnl%s+"]
                    :icon "🌱"
                    :lang :fennel}}}
             :presets {:bottom_search         false
                       :command_palette       true
                       :long_message_to_split false
                       :lsp_doc_border        false
                       :inc_rename            false}}]

    ((. (require :noice) :setup) opt)))

{:src "https://github.com/folke/noice.nvim"
 :data {:dependencies [:MunifTanjim/nui.nvim
                       :rcarriga/nvim-notify]
        :enabled false
        : after}}
