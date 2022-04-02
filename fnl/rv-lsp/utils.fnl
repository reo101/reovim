(fn lsp-mappings []
  (let [wk (require :which-key)
        mappings {:l {:w {:r [vim.lsp.buf.remove_workspace_folder :Remove]
                          :l [(fn []
                               (print (vim.inspect (vim.lsp.buf.list_workspace_folders))))
                              :List]
                          :a [vim.lsp.buf.add_workspace_folder :Add]
                          :name :Workspace}
                      :s [vim.lsp.buf.signature_help "Signature Help"]
                      :a [vim.lsp.buf.code_action "Code Action"]
                      :g {:d [vim.lsp.buf.definition :Definition]
                          :i [vim.lsp.buf.implementation :Implementation]
                          :r [vim.lsp.buf.references :References]
                          :name :Go
                          :D [vim.lsp.buf.declaration :Decaration]
                          :y [vim.lsp.buf.type_definition
                              "Type Definition"]}
                      :c {:s [vim.lsp.codelens.save :Save]
                          :a [vim.lsp.codelens.display :Display]
                          :g [vim.lsp.codelens.get :Get]
                          :r [vim.lsp.codelens.run :Run]
                          :f [vim.lsp.codelens.refresh :Refresh]
                          :name :Codelens}
                      :name :LSP
                      :d {:l [vim.diagnostic.open_float "Line Diagnostics"]
                          :n [vim.diagnostic.goto_next :Next]
                          :p [vim.diagnostic.goto_prev :Previous]
                          :q [vim.diagnostic.set_loclist "Send to loclist"]
                          :name :Diagnostics}
                      :f [vim.lsp.buf.formatting :Format]
                      :r [vim.lsp.buf.rename :Rename]}}
        direct-mappings {:K [#(vim.lsp.buf.hover)
                             :Hover]
                         :g {:d [vim.lsp.buf.definition :Definition]
                             :i [vim.lsp.buf.implementation :Implementation]
                             :r [vim.lsp.buf.references :References]
                             :D [vim.lsp.buf.declaration :Decaration]
                             :y [vim.lsp.buf.type_definition "Type Definition"]}}
        motion-mappings {"]d" [vim.diagnostic.goto_next "Next Diagnostic"]
                         "[d" [vim.diagnostic.goto_prev "Previous Diagnostic"]}]
    (wk.register mappings {:prefix :<leader>})
    (wk.register direct-mappings {:mode :n :prefix ""})
    (wk.register motion-mappings {:mode :n :prefix ""})
    (wk.register motion-mappings {:mode :o :prefix ""})))

(fn lsp-on-attach [client bufnr]
  (lsp-mappings)
  (when client.resolved_capabilities.code_lens
    (vim.cmd "        augroup CodeLens
            au!
            au InsertEnter,InsertLeave * lua vim.lsp.codelens.refresh()
        augroup END
        "))
  (when client.resolved_capabilities.document_highlight
    (vim.cmd "            augroup LSPDocumentHighlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        "))
  ((. (require :aerial) :on_attach) client bufnr)
  ((. (require :rv-lsp/signature) :config)))

(fn lsp-on-init [client]
  (vim.notify "Language Server Client successfully started!" :info
              {:title client.name}))

(local lsp-capabilities ((fn []
                           (var capabilities
                                (vim.lsp.protocol.make_client_capabilities))
                           (set capabilities.textDocument.completion.completionItem
                                {:resolveSupport {:properties [:documentation
                                                               :detail
                                                               :additionalTextEdits]}
                                 :documentationFormat [:markdown]
                                 :deprecatedSupport true
                                 :snippetSupport true
                                 :commitCharactersSupport true
                                 :labelDetailsSupport true
                                 :insertReplaceSupport true
                                 :preselectSupport true
                                 :tagSupport {:valueSet [1]}})
                           (set capabilities
                                ((. (require :cmp_nvim_lsp)
                                    :update_capabilities) capabilities))
                           capabilities)))

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
                         :signs true
                         :virtual_text {:spacing 0
                                        :source :always
                                        :prefix ""}}))
    (when (= (. (. (require :globals) :custom) :lsp_progress) :notify)
      (local client-notifs [])
      (local spinner-frames ["◜"
                             "◠" 
                             "◝" 
                             "◞" 
                             "◡"
                             "◟"])

      (fn update-spinner [client-id token]
        (let [notif-data (. (. client-notifs client-id) token)]
          (when (and notif-data notif-data.spinner)
            (local new-spinner
                   (% (+ notif-data.spinner 1) (length spinner-frames)))
            (local new-notif
                   (vim.notify nil nil
                               {:replace notif-data.notification
                                :icon (. spinner-frames new-spinner)
                                :hide_from_history true}))
            (tset (. client-notifs client-id) token
                  {:spinner new-spinner :notification new-notif})
            (vim.defer_fn (fn []
                            (update-spinner client-id token))
                          100))))

      (fn format-title [title client]
        (.. client.name (or (and (> (length title) 0) (.. ": " title)) "")))

      (fn format-message [message percentage]
        (.. (or (and percentage (.. percentage "%\t")) "") (or message "")))

      (fn lsp-progress-notification [_ result ctx]
        (let [client-id ctx.client_id
              val result.value]
          (when val.kind
            (when (not (. client-notifs client-id))
              (tset client-notifs client-id {}))
            (local notif-data (. (. client-notifs client-id) result.token))
            (if (= val.kind :begin)
                (let [message (format-message val.message val.percentage)
                      notification (vim.notify message :info
                                               {:title (format-title val.title
                                                                     (vim.lsp.get_client_by_id client-id))
                                                :icon (. spinner-frames 1)
                                                :hide_from_history true
                                                :timeout false})]
                  (tset (. client-notifs client-id) result.token
                        {:spinner 1 : notification})
                  (update-spinner client-id result.token))
                (and (= val.kind :report) notif-data)
                (let [new-notif (vim.notify (format-message val.message
                                                            val.percentage)
                                            :info
                                            {:replace notif-data.notification
                                             :hide_from_history false})]
                  (tset (. client-notifs client-id) result.token
                        {:spinner notif-data.spinner :notification new-notif}))
                (and (= val.kind :end) notif-data)
                (let [new-notif (vim.notify (or (and val.message
                                                     (format-message val.message))
                                                :Complete)
                                            :info
                                            {:replace notif-data.notification
                                             :icon ""
                                             :timeout 3000})]
                  (tset (. client-notifs client-id) result.token
                        {:notification new-notif}))))))

      (tset vim.lsp.handlers :$/progress lsp-progress-notification)
      (local orig-set-signs vim.lsp.diagnostic.set_signs)

      (fn set-signs-limited [diagnostics bufnr client-id sign-ns opts]
        (when (not diagnostics)
          (lua "return "))
        (local max-severity-per-line {})
        (each [_ d (pairs diagnostics)]
          (if (. max-severity-per-line d.range.start.line)
              (let [current-d (. max-severity-per-line d.range.start.line)]
                (when (< d.severity current-d.severity)
                  (tset max-severity-per-line d.range.start.line d)))
              (tset max-severity-per-line d.range.start.line d)))
        (local filtered-diagnostics {})
        (each [_ v (pairs max-severity-per-line)]
          (table.insert filtered-diagnostics v))
        (orig-set-signs filtered-diagnostics bufnr client-id sign-ns opts))

      (set vim.lsp.diagnostic.set_signs set-signs-limited))
    (local signs {:Info "" :Warn "" :Error "" :Hint ""})
    (each [type icon (pairs signs)]
      (local hl (.. :DiagnosticSign type))
      (vim.fn.sign_define hl {:numhl "" :text icon :texthl hl}))))

(fn lsp-root-dir [root-files]
  (fn [fname]
      (local util (require :lspconfig.util))
      (or (or ((util.root_pattern (unpack root-files)) fname)
              (util.find_git_ancestor fname))
          (util.path.dirname fname))))

{: lsp-mappings
 : lsp-on-attach
 : lsp-on-init
 : lsp-capabilities
 : lsp-override-handlers
 : lsp-root-dir}
