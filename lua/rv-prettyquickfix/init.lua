local M = {}

M.config = function()

    local opt = {
        signs = {
            error = "E",
            warning = "W",
            info = "I",
            hint = "H"
        }
    }

    require("pqf").setup(opt)

end

return M
