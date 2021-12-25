local M = {}

M.config = function()

    local opt = {
        cmd = { "erlang_ls" },
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        on_init = require("rv-lsp.utils").lsp_on_init,
        capabilities = require("rv-lsp.utils").capabilities,
        filetypes = { "erlang" },
        single_file_support = true,
        root_dir = function(fname)
            local util = require("lspconfig.util")
            local root_files = {
                "rebar.config",
                "erlang.mk",
                ".git",
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
        init_options = {
            hostInfo = "neovim"
        }
    }

    require("lspconfig")["erlangls"].setup(opt)

end

return M
