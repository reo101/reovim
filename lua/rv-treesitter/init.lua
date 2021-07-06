local M = {}

M.config = function()
    
    opt = {
        ensure_installed = "all",
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
        rainbow = {
            enable = true,
        },
    }

    require("nvim-treesitter.configs").setup(opt)

end

return M
