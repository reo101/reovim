local M = {}

M.config = function()

    -- local opt = require("rv-lualine.evil-lualine")
    local opt = {
        options = {
            theme = "nightfox"
        }
    }

    require("lualine").setup(opt)

end

return M
