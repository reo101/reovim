local M = {}

M.config = function()

    local opt = {
        cmd = { "texlab" },
        on_attach = require("rv-lsp.utils").on_attach,
        on_init = require("rv-lsp.utils").on_init,
        capabilities = require("rv-lsp.utils").capabilities,
        filetypes = { "tex", "bib" },
        root_dir = function(fname)
            local util = require("lspconfig.util")
            local root_files = {
                ".latexmkrc",
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
        settings = {
            texlab = {
                rootDirectory = ".",
                build = _G.TeXMagicBuildConfig,
                forwardSearch = {
                    executable = "zathura",
                    args = { "--synctex-forward", "%l:1:%f", "%p" },
                    onSave = true,
                },
            },
        },
    }

    require("lspconfig")["texlab"].setup(opt)

end

return M
