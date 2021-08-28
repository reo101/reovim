local M = {}

M.config = function()

    local opt = {
        cmd = { "cmake-language-server" },
        filetypes = { "cmake" },
        init_options = {
            buildDirectory = "build"
        },
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        capabilities = require("rv-lsp.utils").capabilities,
        root_dir = function(fname)
            local util = require("lspconfig.util")
            local root_files = {
                ".git",
                "compile_commands.json",
                "build",
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
    }

    require("lspconfig")["cmake"].setup(opt)

end

return M
