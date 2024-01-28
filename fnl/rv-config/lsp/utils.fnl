(fn lsp-mappings []
  (let [dk (require :def-keymaps)
        mappings {:l {:name :LSP
                      :w {:name :Workspace
                          :a [vim.lsp.buf.add_workspace_folder    :Add]
                          :r [vim.lsp.buf.remove_workspace_folder :Remove]
                          :l [#(print (vim.inspect (vim.lsp.buf.list_workspace_folders)))
                              :List]}
                      :s [vim.lsp.buf.signature_help "Signature Help"]
                      :a [vim.lsp.buf.code_action    "Code Action"]
                      :g {:name :Go
                          :d [vim.lsp.buf.definition      :Definition]
                          :i [vim.lsp.buf.implementation  :Implementation]
                          :r [vim.lsp.buf.references      :References]
                          :D [vim.lsp.buf.declaration     :Decaration]
                          :y [vim.lsp.buf.type_definition "Type Definition"]}
                      :c {:name :Codelens
                          :s [vim.lsp.codelens.save    :Save]
                          :a [vim.lsp.codelens.display :Display]
                          :g [vim.lsp.codelens.get     :Get]
                          :r [vim.lsp.codelens.run     :Run]
                          :f [vim.lsp.codelens.refresh :Refresh]}
                      :d {:name :Diagnostics
                          :l [vim.diagnostic.open_float  "Line Diagnostics"]
                          :n [vim.diagnostic.goto_next   :Next]
                          :p [vim.diagnostic.goto_prev   :Previous]
                          :q [vim.diagnostic.setloclist  "Send to loclist"]}
                      :f [#(vim.lsp.buf.format {:async true}) :Format]
                      :r [vim.lsp.buf.rename                  :Rename]
                      :i [#(vim.lsp.inlay_hint.enable 0 (not (vim.lsp.inlay_hint.is_enabled 0)))
                          "Toggle inlay hints"]}}
        direct-mappings {:K [vim.lsp.buf.hover :Hover]
                         :g {:d [vim.lsp.buf.definition      :Definition]
                             :i [vim.lsp.buf.implementation  :Implementation]
                             :r [vim.lsp.buf.references      :References]
                             :D [vim.lsp.buf.declaration     :Decaration]
                             :y [vim.lsp.buf.type_definition "Type Definition"]}}
        insert-mappings {"<C-h>" [vim.lsp.buf.signature_help "Signature Help"]}
        motion-mappings {"]d" [vim.diagnostic.goto_next "Next Diagnostic"]
                         "[d" [vim.diagnostic.goto_prev "Previous Diagnostic"]}]
    (dk :n
        mappings
        {:prefix :<leader>})
    (dk :n
        direct-mappings)
    (dk :i
        insert-mappings)
    (dk [:n :o]
        motion-mappings)))

(fn lsp-on-attach [client bufnr]
  (lsp-mappings)

  (when client.server_capabilities.codeLensProvider
    (vim.api.nvim_create_augroup :LspCodeLens {:clear true})
    (vim.api.nvim_create_autocmd [:InsertEnter
                                  :InsertLeave]
                                 {:buffer   0
                                  :group    :LspCodeLens
                                  :callback vim.lsp.codelens.refresh}))

  (when client.server_capabilities.documentHighlightProvider
    (vim.api.nvim_create_augroup :LspDocumentHighlight {:clear true})
    (vim.api.nvim_create_autocmd [:CursorHold]
                                 {:buffer   0
                                  :group    :LspDocumentHighlight
                                  :callback vim.lsp.buf.document_highlight})
    (vim.api.nvim_create_autocmd [:CursorMoved]
                                 {:buffer   0
                                  :group    :LspDocumentHighlight
                                  :callback vim.lsp.buf.clear_references}))

  (when client.server_capabilities.documentSymbolProvider
    ((. (require :nvim-navic) :attach) client bufnr))

  (when client.server_capabilities.inlayHintProvider
    (vim.lsp.inlay_hint.enable bufnr true)))

(fn lsp-on-init [client]
  (vim.notify "Language Server Client successfully started!"
              :info
              {:title client.name}))

(local lsp-capabilities
  (do
    (var capabilities
         (vim.lsp.protocol.make_client_capabilities))
    (set capabilities.textDocument.completion.completionItem
         {:resolveSupport {:properties [:documentation
                                        :detail
                                        :additionalTextEdits]}
          :documentationFormat     [:markdown]
          :deprecatedSupport       true
          :snippetSupport          true
          :commitCharactersSupport true
          :labelDetailsSupport     true
          :insertReplaceSupport    true
          :preselectSupport        true
          :tagSupport              {:valueSet [1]}})
    capabilities))

(fn lsp-override-handlers []
  (let [border :single]
    (tset vim.lsp.handlers :textDocument/hover
          (vim.lsp.with vim.lsp.handlers.hover {: border}))
    (tset vim.lsp.handlers :textDocument/signatureHelp
          (vim.lsp.with vim.lsp.handlers.signature_help {: border}))
    (tset vim.lsp.handlers :textDocument/publishDiagnostics
          (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics
                        {:underline true
                         :update_in_insert false
                         :severity_sort false
                         :signs true}))
                         ;; :virtual_text {:spacing 0
                         ;;                :source :always
                         ;;                :prefix ""}}))
    (local signs {:Info  ""
                  :Warn  ""
                  :Error ""
                  :Hint  ""})
    (each [type icon (pairs signs)]
      (local hl (.. :DiagnosticSign type))
      (vim.fn.sign_define hl {:numhl "" :text icon :texthl hl}))))

(fn lsp-root-dir [root-files git?]
  (fn [fname]
      (local util (require :lspconfig.util))
      (or (or ((util.root_pattern (unpack root-files)) fname)
              (and git? (util.find_git_ancestor fname))))))
          ;; (util.path.dirname fname))))

{: lsp-mappings
 : lsp-on-attach
 : lsp-on-init
 : lsp-capabilities
 : lsp-override-handlers
 : lsp-root-dir}
