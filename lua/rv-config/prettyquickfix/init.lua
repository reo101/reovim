local M = {}

M.config = function()

    local opt = {
        signs = {
            error = "E",
            warning = "W",
            info = "I",
            hint = "H"
        },

        show_multiple_lines = true,

        max_filename_length = 0,
    }

    require("pqf").setup(opt)

end

return M
