local M = {}

M.config = function()

    -- local opt = require("rv-lualine.evil-lualine")
    local opt = require("rv-lualine.reoline")
    -- local opt = {
    --     options = {
    --         theme = "tokyonight"
    --     }
    -- }

    require("lualine").setup(opt)

end

return M
