local M = {}

M.config = function()

    local opt = {
        ---Add a space b/w comment and the line
        ---@type boolean
        padding = true,

        ---Whether the cursor should stay at its position
        ---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
        ---@type boolean
        sticky = true,

        ---Lines to be ignored while comment/uncomment.
        ---Could be a regex string or a function that returns a regex string.
        ---Example: Use "^$" to ignore empty lines
        ---@type string|function
        ignore = nil,

        ---LHS of toggle mapping in NORMAL + VISUAL mode
        ---@type table
        toggler = {
            ---line-comment keymap
            line = "<leader>cc",
            ---block-comment keymap
            block = "<leader>Cc",
        },

        ---LHS of operator-pending mapping in NORMAL + VISUAL mode
        ---@type table
        opleader = {
            ---line-comment keymap
            line = "<leader>c",
            ---block-comment keymap
            block = "<leader>C",
        },

        ---LHS of extra mappings
        ---@type table
        extra = {
            ---Add comment on the line above
            above = '<leader>cO',
            ---Add comment on the line below
            below = '<leader>co',
            ---Add comment at the end of line
            eol = '<leader>cA',
        },

        --LHS of extended mappings
        ---@type table
        extended = {
            ---Add comment on the line above
            above = '<leader>cO',
            ---Add comment on the line below
            below = '<leader>co',
            ---Add comment at the end of line
            eol = '<leader>cA',
        },

        ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
        ---@type table
        mappings = {
            ---operator-pending mapping
            ---Includes `<leader>cc`, `<leader>cb` and `<leader>c[count]{motion}`
            basic = true,
            ---extra mapping
            extra = true,
            ---extended mapping
            extended = false,
        },

        ---Pre-hook, called before commenting the line
        ---@type function|nil
        pre_hook = function(ctx)
            local u = require("Comment.utils")
            if ctx.ctype == u.ctype.line and ctx.cmotion == u.cmotion.line then
                -- Only comment when we are doing linewise comment and up-down motion
                return require("ts_context_commentstring.internal").calculate_commentstring()
            end
        end,

        ---Post-hook, called after commenting is done
        ---@type function|nil
        post_hook = nil,
    }

    require("Comment").setup(opt);

    local comment_api = require("Comment.api")

    local wk = require("which-key")

    local mappings = {
        ["c"] = {
            name = "Line Comment",
            c = { comment_api.toggle_current_linewise_op, "Toggle Line" },
            o = { comment_api.insert_linewise_below, "o" },
            O = { comment_api.insert_linewise_above, "O" },
            A = { comment_api.insert_linewise_eol, "A" },
        },
        ["C"] = {
            name = "Block Comment",
            c = { comment_api.toggle_current_blockwise_op, "Toggle line" },
        },
    }

    local operatorMappings = {
        ["c"] = { comment_api.toggle_linewise_op },
        ["C"] = { comment_api.toggle_blockwise_op },
    }

    wk.register(mappings, { prefix = "<leader>" })
    wk.register(operatorMappings, { mode = "o", prefix = "<leader>" })

end

return M
