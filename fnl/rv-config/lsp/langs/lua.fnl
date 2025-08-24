(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        lua_index_plugins false
        opt {:cmd [:lua-language-server
                   :--start-lsp]
             :filetypes [:lua]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:.luarc.json
                          :.luacheckrc
                          :.stylua.toml
                          :selene.toml])
             :settings {:Lua {:runtime {:path ((fn []
                                                 (local runtime-path
                                                        (vim.split package.path
                                                                   ";"))
                                                 (table.insert runtime-path
                                                               :lua/?.lua)
                                                 (table.insert runtime-path
                                                               :lua/?/init.lua)
                                                 runtime-path))
                                        :version :LuaJIT}
                              :workspace {:preloadFileSize 10000
                                          :maxPreload 100000
                                          :library (if lua_index_plugins
                                                       (vim.api.nvim_get_runtime_file "" true)
                                                       ;; else
                                                       {(vim.fn.expand :$VIMRUNTIME/lua) true
                                                        (vim.fn.expand :$VIMRUNTIME/lua/vim/lsp) true})}
                              :completion {:callSnippet :Replace
                                           :enable true}
                              :telemetry {:enable false}
                              :diagnostics {:enanle true
                                            :globals [:vim]}}}
             :single_file_support true}]
    ((. (. (require :lspconfig) :lua_ls) :setup) opt)))

{: after}
