[{1 :zbirenbaum/copilot.lua
  :event :InsertEnter
  :config #(let [copilot (require :copilot)
                 opt {:suggestion {:enabled false}
                      :panel      {:enabled false}}]
             (copilot.setup opt))}
 {1 :zbirenbaum/copilot-cmp
  :config #(let [copilot-cmp (require :copilot_cmp)
                 opt {}]
             (copilot-cmp.setup opt))}]
