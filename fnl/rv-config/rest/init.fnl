(fn config []
  (let [rest (require :rest)
        dk (require :def-keymaps)
        ;; TODO: tidy up <https://github.com/rest-nvim/rest.nvim>
        opt {:custom_dynamic_variables {}
             :encode_url true
             :env_edit_command :tabedit
             :env_file :.env
             :env_pattern "\\.env$"
             :highlight {:enabled true
                         :timeout 150}
             :jump_to_request false
             :result {:formatters {:html (fn [body]
                                           (vim.fn.system [:tidy
                                                           :-i
                                                           :-q
                                                           "-"]
                                                          body))
                                   :json :jq}
                      :show_curl_command false
                      :show_headers true
                      :show_http_info true
                      :show_statistics false
                      :show_url true}
             :result_split_horizontal false
             :result_split_in_place false
             :search_back true
             :skip_ssl_verification false
             :stay_in_current_window_after_split false
             :yank_dry_run true
             :requires [:nvim-lua/plenary.nvim]}]
    (rest.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{1 :rest-nvim/rest.nvim
 :dependencies [:nvim-lua/plenary.nvim]
 :ft [:http]
 : config
 :enabled false}
