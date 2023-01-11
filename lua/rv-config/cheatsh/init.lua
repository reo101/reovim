local M = {}

M.config = function()

    local wk = require("which-key")

    local mappings = {

    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
