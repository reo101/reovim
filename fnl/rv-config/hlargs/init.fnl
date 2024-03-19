(fn config []
  (let [hlargs (require :hlargs)
        dk (require :def-keymaps)
        opt {:color :#ef9062
             :excluded_filetypes []
             :paint_arg_declarations true
             :paint_arg_usages true
             :hl_priority 10000
             :performance
               {:parse_delay 1
                :slow_parse_delay 50
                :max_iterations 400
                :max_concurrent_partial_parses 30
                :debounce
                  {:partial_parse 3
                   :partial_insert_mode 100
                   :total_parse 700
                   :slow_parse 5000}}}]
    (hlargs.setup opt)

    (dk [:n]
        {:t {:name :Toggle
             :h [hlargs.toggle "Highlight Arguments"]}}
        {:prefix :<leader>})))

{1 :m-demare/hlargs.nvim
 :dependencies [:nvim-treesitter/nvim-treesitter]
 :event :BufRead
 : config}
