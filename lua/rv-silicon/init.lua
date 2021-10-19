local M = {}

M.config = function()

    vim.g.silicon = {
        ["theme"] = "Dracula",
        ["font"] = "Hack",
        ["background"] = "#AAAAFF",
        ["shadow-color"] = "#555555",
        ["line-pad"] = 2,
        ["pad-horiz"] = 80,
        ["pad-vert"] = 100,
        ["shadow-blur-radius"] = 0,
        ["shadow-offset-x"] = 0,
        ["shadow-offset-y"] =             0,
        ["line-number"] = true,
        ["round-corner"] = true,
        ["window-controls"] = true,
    }

end

return M
