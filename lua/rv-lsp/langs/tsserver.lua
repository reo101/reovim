local M = {}

M.config = function()

    local opt = {
        cmd = { "typescript-language-server", "--stdio" },
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        on_init = require("rv-lsp.utils").lsp_on_init,
        capabilities = require("rv-lsp.utils").capabilities,
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        root_dir = function(fname)
            local util = require("lspconfig.util")
            local root_files = {
                "package.json",
                "tsconfig.json",
                "jsconfig.json",
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
        init_options = {
            hostInfo = "neovim"
        }
    }

    require("lspconfig")["tsserver"].setup(opt)

end

return M
