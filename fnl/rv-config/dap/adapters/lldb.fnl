(fn after []
  (let [dap (require :dap)]
    (tset dap.adapters :lldb
          {:name :lldb
           :type :executable
           :command :lldb-vscode})))

{: after}
