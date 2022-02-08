local M = {}

M.config = function()

    local opt = {
        cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
            "--clang-tidy",
            -- "--clang-tidy-checks=*",
            "--all-scopes-completion",
            "--cross-file-rename",
            "--completion-style=detailed",
            "--header-insertion-decorators",
            "--header-insertion=iwyu",
            "--pch-storage=memory",
        },
        on_attach = function(...)
            require("rv-lsp.utils").lsp_on_attach(...)
            require("which-key").register({
                ["ls"] = { "<Cmd>ClangdSwitchSourceHeader<CR>", "Switch Header"}
            }, { prefix = "<leader>" })
        end,
        on_init = require("rv-lsp.utils").lsp_on_init,
        capabilities = require("rv-lsp.utils").lsp_capabilities,
        init_options = {
            fallbackFlags = {
                "-std=c++20",
            },
        },
    }

    require("lspconfig")["clangd"].setup(opt)

end

return M
