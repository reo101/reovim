(let [{: conditions
       : colors}
      (require :rv-heirline.common)

      ;; LSP-Active
      LSP-Active
      {:condition conditions.lsp_attached
       :update    [:LspAttach
                   :LspDetach]
       :provider  (fn [self]
                    (let [names {}]
                      (each [i server (pairs (vim.lsp.buf_get_clients 0))]
                        (table.insert names server.name))
                      (.. " [" (table.concat names ", ") "]")))
       :hl        {:fg   colors.green
                   :bold true}}]

  {: LSP-Active})
