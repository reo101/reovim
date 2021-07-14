local M = {}

M.config = function()

    local opt = {
        -- auto_enable = {
            -- description = [[enable nvim-bqf in quickfix window automatically]],
            -- default = true
        -- },
        -- magic_window = {
            -- description = [[give the window magic, when the window is splited horizontally, keep
            -- the distance between the current line and the top/bottom border of neovim unchanged.
            -- It"s a bit like a floating window, but the window is indeed a normal window, without
            -- any floating attributes.]],
            -- default = true
        -- },
        -- auto_resize_height = {
            -- description = [[resize quickfix window height automatically.
            -- Shrink higher height to size of list in quickfix window, otherwise extend height
            -- to size of list or to default height (10)]],
            -- default = true
        -- },
        -- preview = {
            -- auto_preview = {
                -- description = [[enable preview in quickfix window automatically]],
                -- default = true
            -- },
            -- border_chars = {
                -- description = [[border and scroll bar chars, they respectively represent:
                -- vline, vline, hline, hline, ulcorner, urcorner, blcorner, brcorner, sbar]],
                -- default = {"│", "│", "─", "─", "╭", "╮", "╰", "╯", "█"}
            -- },
            -- delay_syntax = {
                -- description = [[delay time, to do syntax for previewed buffer, unit is millisecond]],
                -- default = 50
            -- },
            -- win_height = {
                -- description = [[the height of preview window for horizontal layout]],
                -- default = 15
            -- },
            -- win_vheight = {
                -- description = [[the height of preview window for vertical layout]],
                -- default = 15
            -- },
            -- wrap = {
                -- description = [[wrap the line, `:h wrap` for detail]],
                -- default = false
            -- }
        -- },
        -- func_map = {
            -- description = [[the table for {function = key}]],
            -- default = [[see ###Function table for detail]],
        -- },
        -- filter = {
            -- fzf = {
                -- action_for = {
                    -- ["ctrl-t"] = {
                        -- description = [[press ctrl-t to open up the item in a new tab]],
                        -- default = "tabedit"
                    -- },
                    -- ["ctrl-v"] = {
                        -- description = [[press ctrl-v to open up the item in a new vertical split]],
                        -- default = "vsplit"
                    -- },
                    -- ["ctrl-x"] = {
                        -- description = [[press ctrl-x to open up the item in a new horizontal split]],
                        -- default = "split"
                    -- },
                    -- ["ctrl-q"] = {
                        -- description = [[press ctrl-q to toggle sign for the selected items]],
                        -- default = "signtoggle"
                    -- }
                -- },
                -- extra_opts = {
                    -- description = "extra options for fzf",
                    -- default = {"--bind", "ctrl-o:toggle-all"}
                -- }
            -- }
        -- }
    }

    require("bqf").setup(opt)
end

return M
