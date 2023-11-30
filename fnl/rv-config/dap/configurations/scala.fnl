(fn config []
  (let [dap (require :dap)
        dap-utils (require :dap.utils)]
    (tset dap.configurations :scala
          [{:type :scala
            :request :launch
            :name :Run
            :metals {:runType :run
                     :args []}}
           {:type :scala
            :request :launch
            :name "Test File"
            :metals {:runType :testFile
                     :args []}}
           {:type :scala
            :request :launch
            :name "Test Target"
            :metals {:runType :testTarget
                     :args []}}])))

{: config}
