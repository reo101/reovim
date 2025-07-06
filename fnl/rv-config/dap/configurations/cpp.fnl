(fn config []
  (let [dap (require :dap)
        dap-utils (require :dap.utils)]
    (tset dap.configurations :cpp
          [{:name :Launch
            :type :lldb
            :request :launch
            :program #(vim.fn.input
                        "Path to executable: "
                        (.. (vim.fn.getcwd)
                            :/)
                        :file)
            :cwd "${workspaceFolder}"
            :stopOnEntry false
            :args {}

            ;; if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
            ;;
            ;;    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
            ;;
            ;; Otherwise you might get the following error:
            ;;
            ;;    Error on launch: Failed to attach to the target process
            ;;
            ;; But you should be aware of the implications:
            ;; https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
            :runInTerminal false}
           {:name "Attach to process"
            :type :lldb
            :request :attach
            :pid dap-utils.pick_process
            :args {}}])))

{: config}
