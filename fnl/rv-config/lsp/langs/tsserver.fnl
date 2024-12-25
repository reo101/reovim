(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:typescript-language-server
                   :--stdio]
             :filetypes [:javascript
                         :javascriptreact
                         :javascript.jsx
                         :typescript
                         :typescriptreact
                         :typescript.tsx]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:package.json
                          :jsconfig.json
                          :tsconfig.json])
             :init_options {:hostInfo :neovim}
             :single_file_support true}]
    ((. (. (require :lspconfig) :ts_ls) :setup) opt)))

{: config}
