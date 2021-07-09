local M = {}

M.config = function()
    
    local opt = {
        enable = false,
        extra_groups = {
            -- "BufferLineTabClose",
            -- "BufferlineBufferSelected",
            -- "BufferLineFill",
            -- "BufferLineBackground",
            -- "BufferLineSeparator",
            -- "BufferLineIndicatorSelected",
            "WhichKeyGroup",
        },
        exclude = {-- table: groups you don't want to clear
            -- "IndentBlanklineChar",
            "IndentBlanklineSpaceChar",
            "IndentBlanklineSpaceCharBlankline",
            -- "IndentBlanklineContextChar",
        }, 
    }

    require("transparent").setup(opt)

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            t = { function() require("transparent").toggle_transparent() end, "Transparency" },
        },
    }
    
    wk.register(mappings, { prefix = "<leader>" })

end

return M
