local M ={}

M.config = function()

    local opt = {
        overlay_opacity = 50,
        opacity_step = 10,
        --[[ keys = {
            brightness_up    = "<Leader>tsu",
            brightness_down  = "<Leader>tsd",
            toggle           = "<Leader>tsa",
        } ]]
    }

    require("shade").setup(opt)

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            s = {
                name = "Shade",
                o = { function() require("shade").toggle() end, "On/Off" },
                u = { function() require("shade").brightness_up() end, "Brightness up +10" },
                d = { function() require("shade").brightness_down() end, "Brightness down -10" },
            },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
