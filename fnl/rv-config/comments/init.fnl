(fn config []
  (let [opt {:extended {:above :<leader>cO
                        :below :<leader>co
                        :eol :<leader>cA}
             :extra {:above :<leader>cO
                     :below :<leader>co
                     :eol :<leader>cA}
             :ignore nil
             :mappings {:basic true :extended false :extra true}
             :opleader {:block :<leader>C :line :<leader>c}
             :padding true
             :post_hook nil
             :pre_hook ((. (require :ts_context_commentstring.integrations.comment_nvim)
                           :create_pre_hook))
             :sticky true
             :toggler {:block :<leader>Cc :line :<leader>cc}}]
    ((. (require :Comment) :setup) opt)
    (local comment-api (require :Comment.api))
    (local dk (require :def-keymaps))
    (local mappings
           {:C {:c [comment-api.toggle.blockwise.current
                    "Toggle line"]
                :name "Block Comment"}
            :c {:A [comment-api.insert.linewise.eol :A]
                :O [comment-api.insert.linewise.above :O]
                :c [comment-api.toggle.linewise.current
                    "Toggle Line"]
                :name "Line Comment"
                :o [comment-api.insert.linewise.below :o]}})
    (local operator-mappings
           {:C [comment-api.toggle.blockwise.current]
            :c [comment-api.toggle.linewise.current]})
    (dk :n mappings {:prefix :<leader>})
    (dk :o operator-mappings {:prefix :<leader>})))

[{1 :numToStr/Comment.nvim
  : config}
 {1 :JoosepAlviste/nvim-ts-context-commentstring}]
