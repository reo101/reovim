local M = {}

M.config = function()

    local opt = {
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        filetypes = { "javascript", "javascriptreact", "json", "typescript", "typescriptreact", "css", "less", "scss", "markdown", "pandoc" },
        init_options = {
            linters = {
                eslint = {
                    command = "eslint_d",
                    rootPatterns = { ".git" },
                    debounce = 100,
                    args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json" },
                    sourceName = "eslint_d",
                    parseJson = {
                        errorsRoot = "[0].messages",
                        line = "line",
                        column = "column",
                        endLine = "endLine",
                        endColumn = "endColumn",
                        message = "[eslint] ${message} [${ruleId}]",
                        security = "severity"
                    },
                    securities = {
                        [2] = "error",
                        [1] = "warning"
                    }
                },
            },
            filetypes = {
                javascript = "eslint",
                javascriptreact = "eslint",
                typescript = "eslint",
                typescriptreact = "eslint",
            },
            formatters = {
                eslint_d = {
                    command = "eslint_d",
                    args = { "--stdin", "--stdin-filename", "%filename", "--fix-to-stdout" },
                    rootPatterns = { ".git" },
                },
                prettier = {
                    command = "prettier",
                    args = { "--stdin-filepath", "%filename" }
                }
            },
            formatFiletypes = {
                css = "prettier",
                javascript = "eslint_d",
                javascriptreact = "eslint_d",
                scss = "prettier",
                less = "prettier",
                typescript = "eslint_d",
                typescriptreact = "eslint_d",
                json = "prettier",
                markdown = "prettier",
            }
        }
    }

    require("lspconfig")["diagnosticls"].setup(opt)

end

return M
