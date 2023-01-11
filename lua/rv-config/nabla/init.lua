local M = {}

M.config = function()
    -- require("nabla").popup()
    -- Customize with popup({border = ...})  : `single` (default), `double`, `rounded`

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            n = { require("nabla").popup, "Nabla" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })
end

return M
