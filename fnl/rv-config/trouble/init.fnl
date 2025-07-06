(fn after []
   (let [trouble (require :trouble)
         dk (require :def-keymaps)
         opt {}]
     (trouble.setup opt)

     (dk :n
         {:t {:group :Toggle
              :r {:group :Trouble
                  :d [#(trouble.toggle
                         {:mode :diagnostics
                          :filter {:buf 0}})
                      "Buffer Diagnostics"]
                  :D [#(trouble.toggle :diagnostics) :Diagnostics]
                  :s [#(trouble.toggle
                         {:mode :symbols
                          :focus false})
                      :Symbols]
                  :l [#(trouble.toggle
                         {:mode :lsp
                          :focus false
                          :win {:position :right}})
                      :LSP]
                  :Q [#(trouble.toggle :qflist) "Quickfix List"]
                  :L [#(trouble.toggle :loclist) "Location List"]}}}
         {:prefix :<leader>})))

{:src "https://github.com/folke/trouble.nvim"
 :version :v3.1.0
 :data {:keys [:<leader>tr]
        : after}}
