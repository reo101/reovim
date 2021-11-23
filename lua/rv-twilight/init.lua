local M = {}

M.config = function()
    local opt = {
        dimming = {
            alpha = 0.25, -- amount of dimming
            -- we try to get the foreground from the highlight groups or fallback color
            color = { "Normal", "#ffffff" },
            inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
        },
        context = 15, -- amount of lines we will try to show around the current line
        treesitter = true, -- use treesitter when available for the filetype
        -- treesitter is used to automatically expand the visible text,
        -- but you can further control the types of nodes that should always be fully expanded
        expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
            "function",
            "for_statement",
            "while_statement",
            "method",
            "table",
        },
        exclude = {}, -- exclude these filetypes
    }

    require("twilight").setup(opt)

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            w = { require("twilight").toggle, "Twilight" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })
end

return M
