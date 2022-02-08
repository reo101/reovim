local M = {}

M.config = function()

    local opt = {
        cmd = { "vscode-json-language-server", "--stdio" },
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        on_init = require("rv-lsp.utils").lsp_on_init,
        capabilities =  require("cmp_nvim_lsp").update_capabilities(require("rv-lsp.utils").lsp_capabilities),
        filetypes = { "json", "jsonc" },
        root_dir = function(fname)
            local util = require("lspconfig.util")
            local root_files = {
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
            },
        },
        init_options = {
            provideFormatter = true,
        },
        single_file_support = true,
    }

    require("lspconfig")["jsonls"].setup(opt)

end

return M
