(fn config []
  (let [wk                  (require :def-keymaps)
        luasnip             (require :luasnip)
        luasnip-types       (require :luasnip.util.types)
        luasnip-from-vscode (require :luasnip.loaders.from_vscode)
        luasnip-from-lua    (require :luasnip.loaders.from_lua)
        opt {:history
               false
             :updateevents
               "InsertLeave,TextChanged,TextChangedI"
             :region_check_events
               "CursorMoved,CursorHold,InsertEnter"
             :ext_opts
               {luasnip-types.choiceNode
                  {:active
                     {:virt_text
                        [["●" "DiagnosticError"]]}}
                luasnip-types.insertNode
                  {:active
                     {:virt_text
                        [["●" "DiagnosticInfo"]]}}}}]
    (luasnip.config.setup opt)
    (luasnip-from-vscode.lazy_load)
    (luasnip-from-lua.lazy_load)

    (wk :n
        {:t {:name "Toggle"
             :l    [luasnip-from-lua.edit_snippet_files
                    "LuaSnip snippets"]}}
        {:prefix :<leader>})))

[{1 :L3MON4D3/LuaSnip
  :tag :v2.0.0
  :event :InsertEnter
  : config}
 {1 :rafamadriz/friendly-snippets}]
