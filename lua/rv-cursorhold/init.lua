local M = {}

M.config = function()

    -- in millisecond, used for both CursorHold and CursorHoldI,
    -- use updatetime instead if not defined
    vim.g.cursorhold_updatetime = 100

end

return M