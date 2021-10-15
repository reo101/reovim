local M = {}

M.config = function()

    require("luasnip").config.setup({
        history = false,
        updateevents = "InsertLeave,TextChanged,TextChangedI",
        region_check_events = "CursorMoved,CursorHold,InsertEnter",
    })

end

return M
