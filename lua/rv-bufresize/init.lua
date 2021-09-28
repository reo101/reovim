local M = {}

M.config = function()

    local keymapOpts= { noremap=true, silent=true }

    local opt = {
        register = {
            keys = {
                { "n", "<C-w><",        "<C-w><",               keymapOpts },
                { "n", "<C-w>>",        "<C-w>>",               keymapOpts },
                { "n", "<C-w>+",        "<C-w>+",               keymapOpts },
                { "n", "<C-w>-",        "<C-w>-",               keymapOpts },
                { "n", "<C-w>_",        "<C-w>_",               keymapOpts },
                { "n", "<C-w>=",        "<C-w>=",               keymapOpts },
                { "n", "<C-w>|",        "<C-w>|",               keymapOpts },
                { "",  "<LeftRelease>", "<LeftRelease>",        keymapOpts },
                { "i", "<LeftRelease>", "<LeftRelease><C-o>",   keymapOpts },
            },
            trigger_events = { "BufWinEnter", "WinEnter" },
        },
        resize = {
            keys = {},
            trigger_events = { "VimResized" },
        },
    }

    require("bufresize").setup(opt)

end

return M
