local M = {}

M.config = function()
    local opt = {
        cmd = { "lua-language-server", "--start-lsp" },
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        capabilities = require("rv-lsp.utils").lsp_capabilities,
        settings = {
            Lua = {
                completion = {
                    enable = true,
                    callSnippet = "Replace",
                },
                runtime = {
                    version = "LuaJIT",
                    path = (function()
                        local runtime_path = vim.split(package.path, ";")
                        table.insert(runtime_path, "lua/?.lua")
                        table.insert(runtime_path, "lua/?/init.lua")
                        return runtime_path
                    end)(),
                },
                diagnostics = {
                    enanle = true,
                    globals = { "vim" },
                },
                workspace = {
                    library = (function()
                        if require("globals").custom.lua_index_plugins then
                            return vim.api.nvim_get_runtime_file("", true)
                        else
                            return {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                            }
                        end
                    end)(),
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    }

    require("lspconfig")["sumneko_lua"].setup(opt)
end

return M
