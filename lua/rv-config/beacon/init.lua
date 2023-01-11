local M = {}

M.config = function()

    local opt = {
        show_jumps  = true,
        min_jump = 30,
        popup = {
            delay_ms = 0, -- delay before popup displays
            inc_ms = 10, -- time increments used for fade/resize effects 
            blend = 33, -- starting blend, between 0-100 (fully transparent), see :h winblend
            width = 20,
            winhl = "TSVariable", -- "PMenu",
            fader = require("specs").exp_fader,
            resizer = require("specs").shrink_resizer
        },
        ignore_filetypes = {},
        ignore_buftypes = {
            nofile = true,
        },
    }

    require("specs").setup(opt)

end

return M
