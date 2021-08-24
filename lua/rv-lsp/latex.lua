local M = {}

M.setup = function(on_attach, capabilities)

    local opt = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            latex = {
                rootDirectory = ".",
                build = {
                    args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-pvc" },
                    forwardSearchAfter = true,
                    onSave = true,
                },
                forwardSearch = {
                    executable = "zathura",
                    args = { "--synctex-forward", "%l:1:%f", "%p" },
                    onSave = true,
                },
            },
        },
    }

    require("lspconfig")["latex"].setup(opt)
end

return M
