local M = {}

M.config = function()

    -- virtual text deactivated (default)
    -- vim.g.dap_virtual_text = false

    -- show virtual text for current frame (recommended)
    -- vim.g.dap_virtual_text = true
    --
    -- request variable values for all frames (experimental)
    -- vim.g.dap_virtual_text = "all frames"

    require("nvim-dap-virtual-text").setup()

end

return M
