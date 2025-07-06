(fn after []
  (let [dap
          (require :dap)
        dap-utils
          (require :rv-config.dap.utils)
        adapters
          {:lldb (. (require :rv-config.dap.adapters.lldb)
                    :config)}
        configurations
          (collect [_ lang (ipairs [:cpp
                                    :c
                                    ;; :rust
                                    :scala])]
            (values lang (. (require
                              (.. "rv-config.dap.configurations."
                                  lang))
                            :config)))]
    ;; Setup adapters
    (each [name opt (pairs adapters)]
      (if (= (type opt) :function)
          (opt)
          (tset dap.adapters name opt)))

    ;; Setup configurations
    (each [name opt (pairs configurations)]
      (if (= (type opt) :function)
          (opt)
          (tset dap.configurations name opt)))

    (dap-utils.dap-mappings)
    (dap-utils.dap-override-icons)
    (dap-utils.dap-set-repl)))

[{:src "https://github.com/mfussenegger/nvim-dap"
  :data {:dep_of [:nvim-dap-ui :nvim-dap-virtual-text]
         :keys [:<leader>d]
         : after}}
 ;; TODO: add those as pseudo-dependencies
 (require (.. ... :.virttext))
 (require (.. ... :.dapui))]
