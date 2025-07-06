{:cmd [:lua-language-server
       :--start-lsp]
 :filetypes [:lua]
 :root_markers [:.luarc.json
                :.luacheckrc
                :.stylua.toml
                :selene.toml]
 :settings {:Lua
             {:runtime
               {:version :LuaJIT
                :path (do (local runtime-path (vim.split package.path ";"))
                          (table.insert runtime-path
                                        :lua/?.lua)
                          (table.insert runtime-path
                                        :lua/?/init.lua)
                          runtime-path)}
              :workspace
               {:preloadFileSize 10000
                :maxPreload 100000
                :library (if false
                             (vim.api.nvim_get_runtime_file "" true)
                             ;; else
                             {(vim.fn.expand :$VIMRUNTIME/lua) true
                              (vim.fn.expand :$VIMRUNTIME/lua/vim/lsp) true})}
              :completion
               {:callSnippet :Replace
                :enable true}
              :telemetry
               {:enable false}
              :diagnostics
               {:enanle true
                :globals [:vim]}}}
 :single_file_support true}
