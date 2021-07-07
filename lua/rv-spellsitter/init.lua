local M = {}

M.config = function()

    local opt = {
        hl = "SpellBad",
        captures = {"comment"},  -- set to {} to spellcheck everything
    }

    require("spellsitter").setup(opt)

end

return M
