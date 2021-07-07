local M = {}

M.config = function()

    -- uses globals
    local opt = { }

    require("surround").setup(opt)

    vim.g.surround_prefix = "s"
    vim.g.surround_pairs = {
        nestable = {
            {"(", ")"},
            {"[", "]"},
            {"{", "}"} },
        linear = {
            {"'", "'"},
            {'"', '"'}
        }
    }
    vim.g.surround_context_offset = 100
    vim.g.surround_load_autogroups = false
    vim.g.surround_mappings_style = "surround"
    vim.g.surround_load_keymaps = true
    vim.g.surround_quotes = {"'", '"'}
    vim.g.surround_brackets = {"(", "{", "["}

end

return M
