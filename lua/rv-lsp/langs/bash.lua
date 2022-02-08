local M = {}

M.config = function()

    local opt = {
        cmd = { "bash-language-server", "start" },
        cmd_env = {
            GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)",
        },
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        on_init = require("rv-lsp.utils").lsp_on_init,
        capabilities = require("rv-lsp.utils").lsp_capabilities,
        filetypes = { "sh" },
        root_dir = function(fname)
            local util = require("lspconfig.util")
            local root_files = {
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
    }

    require("lspconfig")["bashls"].setup(opt)

end

return M
