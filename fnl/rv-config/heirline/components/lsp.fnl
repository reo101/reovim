(let [{: conditions
       : colors}
      (require :rv-config.heirline.common)

      ;; LSP-Active
      LSP-Active
      {:condition conditions.lsp_attached
       :update    [:LspAttach
                   :LspDetach]
       :provider  (fn [self]
                    (let [servers (vim.lsp.buf_get_clients 0)
                          names (icollect [_ server (ipairs servers)]
                                  server.name)]
                      (.. " [" (table.concat names ", ") "]")))
       :hl        {:fg   colors.green
                   :bold true}}]

  {: LSP-Active})
