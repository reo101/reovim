(fn config []
  (let [dk                  (require :def-keymaps)
        luasnip             (require :luasnip)
        luasnip-types       (require :luasnip.util.types)
        luasnip-from-vscode (require :luasnip.loaders.from_vscode)
        luasnip-from-lua    (require :luasnip.loaders.from_lua)
        luasnip-filetype    (require :luasnip.extras.filetype_functions)
        opt {:keep_roots
               true
             :link_roots
               true
             :link_children
               true
             :history
               false
             :updateevents
               "InsertLeave,TextChanged,TextChangedI"
             :region_check_events
               "CursorMoved,CursorHold,InsertEnter"
             :delete_check_events
               "TextChanged"
             :snip_env
               {}
             :ext_opts
               {luasnip-types.choiceNode
                  {:active
                     {:virt_text
                        [["●" "DiagnosticError"]]}}
                luasnip-types.insertNode
                  {:active
                     {:virt_text
                        [["●" "DiagnosticInfo"]]}}}
             ;; :ft_func #(vim.split vim.bo.filetype "." true)
             :ft_func luasnip-filetype.from_cursor}]
    (luasnip.config.setup opt)
    (luasnip-from-vscode.lazy_load)
    (luasnip-from-lua.lazy_load
      {:paths (.. (vim.fn.stdpath "config")
                  :/luasnippets)})

    (dk :n
        {:t {:group :Toggle
             :l [luasnip-from-lua.edit_snippet_files "LuaSnip snippets"]}}
        {:prefix :<leader>})))

[{1 :L3MON4D3/LuaSnip
  :dependencies [:nvim-treesitter/nvim-treesitter]
  ;; :tag :v2.2.0
  :event :InsertEnter
  : config}
 {1 :rafamadriz/friendly-snippets}]
