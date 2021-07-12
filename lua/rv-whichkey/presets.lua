local M = {}

M.config = function()

    vim.api.nvim_set_keymap("n", "<leader>w", "<C-w>", {})

    local wk = require("which-key")

    local presetMappings = {
        ["w"] = {
            name = "Windows",
            s = "Split window",
            v = "Split window vertically",
            w = "Switch windows",
            q = "Quit a window",
            T = "Break out into a new tab",
            x = "Swap current with next",
            ["-"] = "Decrease height",
            ["+"] = "Increase height",
            ["<lt>"] = "Decrease width",
            [">"] = "Increase width",
            ["|"] = "Max out the width",
            ["="] = "Equally high and wide",
            h = "Go to the left window",
            l = "Go to the right window",
            k = "Go to the up window",
            j = "Go to the down window",
        },
    }

    wk.register(presetMappings, { mode = "n", prefix = "<leader>", preset = true })

end

return M
