local M = {}

M.config = function()

    local opt = {
        cmd = { "zls" },
        filetypes = { "zig", "zir" },
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        on_init = require("rv-lsp.utils").lsp_on_init,
        capabilities = require("rv-lsp.utils").lsp_capabilities,
        root_dir = function(fname)
            local util = require("lspconfig.util")
            local root_files = {
                "zls.json",
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
        single_file_support = true,
    }

    require("lspconfig")["zls"].setup(opt)

end

return M
