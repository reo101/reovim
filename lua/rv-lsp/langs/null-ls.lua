local M = {}

M.config = function()

    local opt = {
        sources = {
            require("null-ls").builtins.formatting.stylua,
            -- require("null-ls").builtins.formatting.shellcheck,
            require("null-ls").builtins.formatting.eslint_d,
            require("null-ls").builtins.formatting.prettierd,
            require("null-ls").builtins.formatting.fixjson,

            -- require("null-ls").builtins.diagnostics.cppcheck,
        },
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        on_init = require("rv-lsp.utils").lsp_on_init,
        capabilities = require("rv-lsp.utils").lsp_capabilities,
    }

    require("null-ls").setup(opt)

end

return M
