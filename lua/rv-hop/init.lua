local M = {}

M.config = function()

    local opt = {
        -- you can configure Hop the way you like here; see :h hop-config
        keys = "etovxqpdygfblzhckisuran"
    }

    require("hop").setup(opt)

end

return M
