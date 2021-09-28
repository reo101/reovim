local M = {}

M.config = function()

    local opt = {
        cmd = { "rust-analyzer" },
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        on_init = require("rv-lsp.utils").lsp_on_init,
        capabilities = require("rv-lsp.utils").capabilities,
        filetypes = { "rust" },
        root_dir = function(fname)
            local util = require("lspconfig.util")
            local root_files = {
                "Cargo.toml",
                "rust-project.json",
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
        settings = {
            ["rust-analyzer"] = {}
        },
    }

    require("lspconfig")["rust_analyzer"].setup(opt)

end

return M
