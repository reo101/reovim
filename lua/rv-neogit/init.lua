local M = {}

M.config = function()
    
    require("neogit").setup()

    local wk = require("which-key")

    local mappings = {
        g = {
            name = "Git",
            s = { function() require("neogit").open() end, "Status" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
