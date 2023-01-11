local M = {}

M.config = function()

    local opt = {
        -- List of delimiters, in descending order of priority, to automatically
        -- sort on.
        delimiters = {
            ",",
            "|",
            ";",
            ":",
            "s", -- Space
            "t"  -- Tab
        }
    }

    require("sort").setup(opt)

    local wk = require("which-key")

    local mappings = {}

    for _, delimiter in ipairs(opt.delimiters) do
        mappings["gs" .. delimiter] = { function() require("sort").sort("", "") end , "Sort with '" .. delimiter .."'" }
        mappings["gs!" .. delimiter] = { function() require("sort").sort("!", "") end , "Sort! with '" .. delimiter .."'" }
    end

    wk.register(mappings, { mode = "v", prefix = "" })

end

return M
