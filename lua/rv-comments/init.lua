local M = {}

M.config = function()

    local opt = {
        marker_padding = true,
        comment_empty = true,
        create_mappings = true,
        line_mapping = "<leader>cc",
        operator_mapping = "<leader>c",
        hook = function()
            if vim.api.nvim_buf_get_option(0, "filetype") == "vue" then
                require("ts_context_commentstring.internal").update_commentstring()
            end
        end
    }

    require("nvim_comment").setup(opt)

    local wk = require("which-key")

    local mappings = {
        c = {
            name = "Comment",
            c = { "Line" }
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

    local operatorMappings = {
        c = {
            name = "Comment",
        },
    }

    wk.register(mappings, { prefix = "<leader>", mode = "o" })

end

return M
