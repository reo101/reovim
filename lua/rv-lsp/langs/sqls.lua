local M = {}

M.config = function()

    local opt = {
        on_attach = function(client)
            require("rv-lsp.utils").lsp_on_attach(client)

            client.resolved_capabilities.execute_command = true

            require("sqls").setup({
                picker = "telescope",
            })
        end,
        capabilities =require("rv-lsp.utils").capabilities,

    }

    require("lspconfig")["sqls"].setup(opt)

    -- Available commands:
    local wk = require("which-key")

    local mappings = {
        ["ls"] = {
            name = "SQL",
            q = {
                name = "Query",
                -- :SqlsExecuteQuery: In normal mode, executes the query in the current buffer. In visual mode, executes the selected query (only works line-wise). Shows the results in a preview buffer.
                e = { "<CMD>SqlsExecuteQuery<CR>", "Execute" },
                -- :SqlsExecuteQueryVertical: Same as :SqlsExecuteQuery, but the results are displayed vertically.
                v = { "<CMD>SqlsExecuteQueryVertical<CR>", "Execute (Vertical)" },
            },
            s = {
                name = "Show",
                -- :SqlsShowDatabases: Shows a list of available databases in a preview buffer.
                d = { "<CMD>SqlsShowDatabases<CR>", "Databases" },
                -- :SqlsShowSchemas: Shows a list of available schemas in a preview buffer.
                s = { "<CMD>SqlsShowSchemas<CR>", "Schemas" },
                -- :SqlsShowConnections: Shows a list of available database connections in a preview buffer.
                c = { "<CMD>SqlsShowConnections", "Connections" }
            },
            w = {
                name = "Switch",
                -- :SqlsSwitchDatabase {database_name}: Switches to a different database. If {database_name} is omitted, displays an interactive prompt to select a database.
                d = { "<CMD>SqlsSwitchDatabase<CR>", "Database" },
                -- :SqlsSwitchConnection {connection_index}: Switches to a different database connection. If {connection_index} is omitted, displays an interactive prompt to select a connection.
                -- ands using a preview buffer also support modifiers like :vertical or :tab.
                c = { "<CMD>SqlsSwitchConnection<CR>", "Connection" },
            }
        }
    }

    wk.register(mappings, { prefix = "<leader>" })

    -- lable mappings:

    -- <Plug>(sqls-execute-query): In visual mode, executes the selected range. In normal mode, executes a motion (like ip or aw)
    -- <Plug>(sqls-execute-query-vertical): same as <Plug>(sqls-execute-query), but the results are displayed vertically

    local operatorMappings = {
        l = {
            name = "LSP",
            s = {
                name = "SQL",
                q = {
                    name = "Query",
                    e = { "<Plug>(sqls-execute-query)", "Execute"},
                    v = { "<Plug>(sqls-execute-query-vertical)", "Execute (Vertical)"},
                },
            },
        }
    }

    wk.register(operatorMappings, { mode = "o", prefix = "<leader>" })
    wk.register(operatorMappings, { mode = "x", prefix = "<leader>" })

end

return M
