(fn config []
  (let [dap (require :dap)]
    (tset dap.adapters :lldb
          {:name :lldb
           :type :executable
           :command :lldb-vscode})))

{: config}
