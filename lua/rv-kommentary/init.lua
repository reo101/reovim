local M = {}

M.config = function()

    require('kommentary.config').configure_language('typescriptreact', {
        single_line_comment_string = 'auto',
        multi_line_comment_strings = 'auto',
        hook_function = function()
            require('ts_context_commentstring.internal').update_commentstring()
        end,
    })

end

return M
