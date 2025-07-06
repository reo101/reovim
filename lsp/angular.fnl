(local get-probe-dir (fn [root-dir]
                       (let [project-root ((. (require :lspconfig.util)
                                              :find_node_modules_ancestor)
                                           root-dir)]
                         (or (and project-root (.. project-root :/node_modules)) ""))))
(local default-probe-dir (get-probe-dir (vim.fn.getcwd)))
(local cmd (fn [probe-dir]
             [:ngserver
              :--stdio
              :--tsProbeLocations
              probe-dir
              :--ngProbeLocations
              probe-dir]))

{:cmd (cmd default-probe-dir)
 :on_new_config (fn [new-config new-root-dir]
                  (let [new-probe-dir (get-probe-dir new-root-dir)]
                   (set new-config.cmd (cmd new-probe-dir))))
 :filetypes [:typescript
             :html
             :typescriptreact
             :typescript.tsx]
 :root_markers [:angular.json]}
