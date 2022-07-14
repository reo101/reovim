(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        opt {:cmd [:emmet-ls
                   :--stdio]
             :filetypes [:html
                         :svelte
                         :vue
                         :javascriptreact
                         :typescriptreact
                         :php
                         :xml
                         :css
                         :less
                         :postcss
                         :sass
                         :scss]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [])
             :single_file_support true}]
    ((. (. (require :lspconfig) :emmet_ls) :setup) opt)))

{: config}
