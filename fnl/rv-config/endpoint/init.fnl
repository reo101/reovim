(fn after []
  (let [endpoint (require :endpoint)
        dk (require :def-keymaps)
        opt {:picker {:type :vim_ui_select
                      :options {:vim_ui_select {:enable_filter true
                                                :filter_prompt "Filter: "
                                                :filter_threshold 20
                                                :show_filter_examples true}}
                      :previewer {:enable_highlighting true}}
             :cache {:mode :session}
             :ui {:show_icons true
                  :show_method true
                  :methods {:GET {:color :TelescopeResultsNumber :icon "📥"}
                            :POST {:color :TelescopeResultsConstant :icon "📤"}
                            :PUT {:color :TelescopeResultsKeyword :icon "✏️"}
                            :DELETE {:color :TelescopeResultsSpecialChar :icon "🗑️"}
                            :PATCH {:color :TelescopeResultsFunction :icon "🔧"}
                            :ROUTE {:color :TelescopeResultsIdentifier :icon "🔗"}}}}]
    (endpoint.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{:src "https://github.com/zerochae/endpoint.nvim"
 :version "v2.6.0"
 :data {: after
        :cmd [:Endpoint :EndpointRefresh]}}
