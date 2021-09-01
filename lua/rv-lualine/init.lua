local M = {}

M.config = function()

    local opt = require("rv-lualine.evil-lualine")

    require("lualine").setup(opt)

end

return M
