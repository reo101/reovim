;; BACKUP: Socket relay approach (requires daemon at /tmp/fsac.sock)
;; (fn after []
;;   (let [{: lsp-on-attach} (require :rv-config.lsp.utils)]
;;     (vim.api.nvim_create_autocmd :FileType
;;       {:pattern [:fsharp]
;;        :once true
;;        :callback
;;         #(vim.lsp.start
;;            {:name :fsautocomplete
;;             :cmd [:bash :-c "socat - UNIX-CONNECT:/tmp/fsac.sock"]
;;             :root_dir (vim.fn.getcwd)
;;             :init_options {:AutomaticWorkspaceInit true}
;;             :on_attach lsp-on-attach})})))

(fn before []
  (tset vim.g :fsharp#backend :nvim)
  (tset vim.g :fsharp#exclude_project_directories [:paket-files]))

(fn after []
  (let [ionide (require :ionide)
        {: lsp-on-attach} (require :rv-config.lsp.utils)]
    (ionide.setup {})

    ;; Manually attach LSP handlers after ionide starts the server
    (vim.api.nvim_create_autocmd :LspAttach
      {:callback
        (fn [args]
          (let [client (vim.lsp.get_client_by_id args.data.client_id)]
            ;; ionide can use different names, check for fsharp-related servers
            (when (and client
                       (or (= client.name :fsautocomplete)
                           (= client.name :ionide)
                           (client.name:match "fsharp")))
              (lsp-on-attach client args.buf))))})))

{:src "https://github.com/ionide/ionide-vim"
 :data {: before
         : after}}
