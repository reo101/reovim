local M = {}

M.config = function()

    local wk = require("which-key")

    local mappings = {
        b = {
            name = "Buffer",
            d = { function() require("bufdelete").bufdelete(0, false) end, "Delete" },
            f = { function() require("bufdelete").bufdelete(0, true) end, "Force Delete" },
        }
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
