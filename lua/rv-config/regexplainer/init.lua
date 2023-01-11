local M = {}

M.config = function()
    local opt = {
        -- 'narrative'
        mode = "narrative", -- TODO: 'ascii', 'graphical'

        -- automatically show the explainer when the cursor enters a regexp
        auto = false,

        -- Whether to log debug messages
        debug = false,

        -- 'split', 'popup'
        display = "popup",

        mappings = {
            toggle = "<leader>tr",
            -- examples, not defaults:
            -- show = 'gS',
            -- hide = 'gH',
            -- show_split = 'gP',
            -- show_popup = 'gU',
        },

        narrative = {
            separator = "\n",
        },
    }

    -- defaults
    require("regexplainer").setup(opt)

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            r = { "Regexplainer" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })
end

return M
