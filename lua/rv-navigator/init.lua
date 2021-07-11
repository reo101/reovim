local M = {}

M.config = function()

    local opt = {
        auto_save = nil,
        --[[
            nil - Don't save (default)
            current - Only save the current modified buffer
            all - Save all the buffers
        --]]
        disable_on_zoom = true,
    }

    require("Navigator").setup(opt)

    local wk = require("which-key")

    local mappings = {
        ["<C-h>"] = { function() require("Navigator").left() end, "Navigate left" },
        ["<C-j>"] = { function() require("Navigator").down() end, "Navigate down" },
        ["<C-k>"] = { function() require("Navigator").up() end, "Navigate up" },
        ["<C-l>"] = { function() require("Navigator").right() end, "Navigate right" },
        ["<C-\\>"] = { function() require("Navigator").previous() end, "Navigate previous" },
    }

    wk.register(mappings, { prefix = "" })

end

return M
