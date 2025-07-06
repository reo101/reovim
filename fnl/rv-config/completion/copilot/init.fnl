[{:src "https://github.com/zbirenbaum/copilot.lua"
  :event :InsertEnter
  :config #(let [copilot (require :copilot)
                 opt {:suggestion {:enabled false}
                      :panel      {:enabled false}}]
             (copilot.setup opt))}
 {:src "https://github.com/zbirenbaum/copilot-cmp"
  :config #(let [copilot-cmp (require :copilot_cmp)
                 opt {}]
             (copilot-cmp.setup opt))}]
