(fn config []
   (let [dk (require :def-keymaps)
         lsp-lines (require :lsp_lines)
         opt {}]
     (lsp-lines.setup opt)

     (vim.diagnostic.config {:virtual_text  false
                             :virtual_lines true})
     (dk :n
         {:t {:name :Toggle
              :d [lsp-lines.toggle
                  "Diagnostics"]}}
         {:prefix :<leader>})))

{: config}
