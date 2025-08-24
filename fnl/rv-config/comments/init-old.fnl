(fn after []
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
           {:c {:group "Line Comment"
                :c [comment-api.toggle.linewise.current
                    "Toggle Line"]
                :o [comment-api.insert.linewise.below :o]
                :O [comment-api.insert.linewise.above :O]
                :A [comment-api.insert.linewise.eol :A]}
            :C {:group "Block Comment"
                :c [comment-api.toggle.blockwise.current
                    "Toggle line"]}})
    (local operator-mappings
           {:c [comment-api.toggle.linewise.current]
            :C [comment-api.toggle.blockwise.current]})
    (dk :n mappings {:prefix :<leader>})
    (dk :o operator-mappings {:prefix :<leader>})))

[{:src "https://github.com/numToStr/Comment.nvim"
  :dependencies [:JoosepAlviste/nvim-ts-context-commentstring]
  :keys [{1 :<leader>c :desc "Line Comment"  :mode [:n :o]}
         {1 :<leader>C :desc "Block Comment" :mode [:n :o]}]
  : after}]
