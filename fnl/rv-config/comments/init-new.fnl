(fn after []
  (let [Comment (require :Comment)
        Comment-api (require :Comment.api)
        dk (require :def-keymaps)
        opt {;;; Add a space between comment and the line
             :padding true

             ;;; Whether the cursor should stay at its position
             :sticky true

             ;;; Lines to be ignore while commenting/uncommenting
             ;;; Could be a regex string or a function that return a regex string
             ;;; Example: Use "^$" to ignore empty lines
             :ignore nil

             ;;; LHS of togggle mapping in NORMAL + VISUAL mode
             :toggler {;;; Line-comment keymap
                       :line  :<leade>cc
                       ;;; Block-comment keymap
                       :block :<leader>Cc}

             ;;; LHS of operator-pending mapping in NORMAL + VISUAL mode
             :opleader {;;; Line-comment keymap
                        :line  :<leade>c
                        ;;; Block-comment keymap
                        :block :<leader>C}

             ;;; LHS of extra mappings
             :extra {;;; Add comment on the line above
                     :above :<leader>cO
                     ;;; Add comment on the line below
                     :block :<leader>co
                     ;;; Add comment at the end of the line
                     :eol   :<leader>cA}

             ;;; LHS of extended mappings
             :extended {;;; Add comment on the line above
                        :above :<leader>cO
                        ;;; Add comment on the line below
                        :block :<leader>co
                        ;;; Add comment at the end of the line
                        :eol   :<leader>cA}

             ;;; Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
             :mappings {;;; Operator-pending mapping
                        ;;; Includes `<leader>cc`, `<leader>cb` and `<leader>c[count]{motion}`
                        :basic true
                        ;;; Extra mappings
                        :extra true
                        ;;; Extended mappings
                        :extended false}

             ;;; Pre-hook, called before commenting the line
             :pre_hook  (fn [ctx]
                          (let [ts-context-integration
                                 (require :ts_context_commentstring.integrations.comment_nvim)]
                            (or (ts-context-integration.create_pre_hook ctx)
                                (vim.opt_local.commentstring:get))))

             ;;; Post-hook, called after commenting is done
             :post_hook nil}]
    (Comment.setup opt)

    (dk :n
        {:c {:group "Line Comment"
             :c [Comment-api.toggle.linewise.current "Toggle Line"]
             :o [Comment-api.toggle.linewise.below "o"]
             :O [Comment-api.toggle.linewise.above "O"]
             :A [Comment-api.toggle.linewise.eol "A"]}
         :C {:group "Block Comment"
             :c [Comment-api.toggle.blockwise.current "Toggle Line"]}}
        {:prefix :<leader>})

    (dk :o
        {:c [Comment-api.toggle.linewise.current "Line Comment"]
         :C [Comment-api.toggle.blockwise.current "Block Comment"]}
        {:prefix :<leader>})))

    ;; (dk :n
    ;;     {:c {:group "Line Comment"}})))
    ;;          :c [(Comment-api.call :toggle.linewise.current "g@$") "Toggle Line"]}})))
    ;;          :o [(Comment-api.call :insert.linewise.below   "g@")  "o"]}})))
    ;;          :O [(Comment-api.call :insert.linewise.above   "g@")  "O"]}})))
    ;;          :A [(Comment-api.call :insert.linewise.eol     "g@")  "A"]}})))
    ;;      :C {:group "Block Comment"}})))
    ;;          :c [(Comment-api.call :toggle.blockwise.current "g@$") "Toggle Line"]}})))
    ;;     {:prefix :<leader> :expr true})))

    ;; (dk :n
    ;;     {:c [(Comment-api.call :toggle.linewise  "g@")]})))
    ;;      :C [(Comment-api.call :toggle.blockwise "g@")]})))
    ;;     {:prefix :<leader> :expr true})))

    ;; (dk :x
    ;;     {:c [#((Comment-api.locked :toggle.linewise)  (vim.fn.visualmode)) "Toggle Linewise"]
    ;;      :C [#((Comment-api.locked :toggle.blockwise) (vim.fn.visualmode)) "Toggle Blockwise"]}
    ;;     {:prefix :<leader> :expr true})))

{:src "https://github.com/numToStr/Comment.nvim"
 :data {: after}}
