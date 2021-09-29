local M = {}

M.config = function()

    require("lspconfig")["clangd"].setup({
        cmd = { "clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy" },
        on_attach = function(...)
            require("rv-lsp.utils").lsp_on_attach(...)
            require("which-key").register({
                ["ls"] = { "<Cmd>ClangdSwitchSourceHeader<CR>", "Switch Header"}
            }, { prefix = "<leader>" })
        end,
        on_init = require("rv-lsp.utils").lsp_on_init,
        capabilities = require("rv-lsp.utils").capabilities,
        cross_file_rename = true,
        header_insertion = "always",
    })

end

return M
