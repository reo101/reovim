(fn config []
  (let [quicker (require :quicker)
        dk (require :def-keymaps)
        opt {:keys
              [{1 :>
                2 #(quicker.expand {:before 2
                                    :after 2
                                    :add_to_existing true})
                :desc "Expand quickfix context"}
               {1 :<
                2 #(quicker.collapse)
                :desc "Collapse quickfix context"}]}]
    (quicker.setup opt)
    (dk :n
        {:t {:group :Toggle
             :l [#(quicker.toggle {:loclist true})  :Loclist]
             :q [#(quicker.toggle {:loclist false}) :Quickfix]}}
        {:prefix :<leader>})))

{1 :stevearc/quicker.nvim
 :tag :v1.0.0
 : config}
