local M = {}

M.config = function()

    vim.g.copilot_no_tab_map = true

    vim.g.copilot_filetypes = {
        ["*"] = true,
        -- ["cpp"] = true,
    }

    vim.cmd [[
        highlight CopilotSuggestion guifg=#555555 ctermfg=8
    ]]

    local wk = require("which-key")

    local mappings = {
        ["<A-Tab>"] = { function() vim.fn["copilot#Accept"]("") end , "Copilot" },
    }

    wk.register(mappings,
        {
            mode   = "i",
            silent = true,
            script = true,
            expr   = true,
            prefix = "",
        }
    )

end

return M
