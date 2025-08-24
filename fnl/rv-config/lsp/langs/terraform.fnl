(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:terraform-ls
                   :serve]
             :filetypes [:terraform]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:.terraform]
                         true)}]
        ;; opt {:cmd [:terraform-lsp]
        ;;      :filetypes [:terraform
        ;;                  :hcl]
        ;;      :on_init lsp-on-init
        ;;      :on_attach lsp-on-attach
        ;;      :capabilities lsp-capabilities
        ;;      :root_dir (lsp-root-dir
        ;;                  [:.terraform]
        ;;                  true)}]
    ((. (. (require :lspconfig) :terraformls) :setup) opt)))
    ;; ((. (. (require :lspconfig) :terraform_lsp) :setup) opt)))

{: after}
