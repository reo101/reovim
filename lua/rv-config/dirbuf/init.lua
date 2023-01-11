local M = {}

M.config = function()
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrw = 1

    local opt = {
        hash_padding = 2,
        show_hidden = true,
        sort_order = "default",
        write_cmd = "DirbufSync",
    }

    require("dirbuf").setup(opt)

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            d = { require("dirbuf").enter, "DirBuf" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })
end

return M
