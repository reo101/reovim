local M = {}

M.config = function()

    local opt = {
        cmd = { "pylsp" },
        filetypes = { "python" },
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        capabilities = require("rv-lsp.utils").capabilities,
        root_dir = function(fname)
            local util = require("lspconfig.util")
            local root_files = {
                'pyproject.toml',
                'setup.py',
                'setup.cfg',
                'requirements.txt',
                'Pipfile',
                'pyrightconfig.json',
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true
                }
            }
        }
    }

    require("lspconfig")["pylsp"].setup(opt)

end

return M
