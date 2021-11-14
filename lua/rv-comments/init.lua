local M = {}

M.config = function()

    local opt = {
        ---Add a space b/w comment and the line
        ---@type boolean
        padding = true,

        ---Lines to be ignored while comment/uncomment.
        ---Could be a regex string or a function that returns a regex string.
        ---Example: Use "^$" to ignore empty lines
        ---@type string|function
        ignore = nil,

        ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
        ---@type table
        mappings = {
            ---operator-pending mapping
            ---Includes `<leader>cc`, `<leader>cb`, `<leader>cc[count]{motion}` and `<leader>cb[count]{motion}`
            basic = true,
            ---extra mapping
            -- HACK: Done using which-key
            extra = false,
            ---extended mapping
            -- TODO: Do using which-key
            extended = false,
        },

        ---LHS of toggle mapping in NORMAL + VISUAL mode
        ---@type table
        toggler = {
            ---line-comment keymap
            line = "<leader>cc",
            ---block-comment keymap
            block = "<leader>cb",
        },

        ---LHS of operator-pending mapping in NORMAL + VISUAL mode
        ---@type table
        opleader = {
            ---line-comment keymap
            line = "<leader>cC",
            ---block-comment keymap
            block = "<leader>cB",
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

    local wk = require("which-key")

    local E = require("Comment.extra")
    local U = require("Comment.utils")

    local mappings = {
        c = {
            name = "Comment",
            c = "Toggle Line",
            C = "Toggle Line Op",
            b = "Toggle Block",
            B = "Toggle Block Op",
            o = { function() E.norm_o(U.ctype.line, opt) end, "o" },
            O = { function() E.norm_O(U.ctype.line, opt) end, "O" },
            A = { function() E.norm_A(U.ctype.line, opt) end, "A" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
