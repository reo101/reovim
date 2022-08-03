(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        get-probe-dir (fn [root-dir]
                        (let [project-root ((. (require :lspconfig.util)
                                               :find_node_modules_ancestor)
                                            root-dir)]
                          (or (and project-root (.. project-root :/node_modules)) "")))
        default-probe-dir (get-probe-dir (vim.fn.getcwd))
        cmd (fn [probe-dir]
              [:ngserver
               :--stdio
               :--tsProbeLocations
               probe-dir
               :--ngProbeLocations
               probe-dir])
        opt {
             :cmd (cmd default-probe-dir)
             :on_new_config (fn [new-config new-root-dir]
                              (let [new-probe-dir (get-probe-dir new-root-dir)]
                               (set new-config.cmd (cmd new-probe-dir))))
             :filetypes [:typescript
                         :html
                         :typescriptreact
                         :typescript.tsx]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:angular.json])}]
    ((. (. (require :lspconfig) :angularls) :setup) opt)))

{: config}
