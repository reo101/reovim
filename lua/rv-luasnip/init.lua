local M = {}

M.config = function()

    local function prequire(...)
        local status, lib = pcall(require, ...)
        if (status) then return lib end
        return nil
    end

    local luasnip = prequire("luasnip")

    local esc = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col(".") - 1
        if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
            return true
        else
            return false
        end
    end

    _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return esc("<C-n>")
        elseif luasnip and luasnip.expand_or_jumpable() then
            return esc("<Plug>luasnip-expand-or-jump")
        elseif check_back_space() then
            return esc("<Tab>")
        else
            return vim.fn["compe#complete"]()
        end
    end
    _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return esc("<C-p>")
        elseif luasnip and luasnip.jumpable(-1) then
            return esc("<Plug>luasnip-jump-prev")
        else
            return esc("<S-Tab>")
        end
    end

    vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
    vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})

    -- local wk = require("which-key")

    -- local tabMappings = {
    --     ["<Tab>"] = { function() _G.tab_complete() end, "Tab complete" },
    --     ["<S-Tab>"] = { function() _G.s_tab_complete() end, "S-Tab complete" },
    -- }

    -- wk.register(tabMappings, { mode = "i", prefix = "", expr = true })
    -- wk.register(tabMappings, { mode = "s", prefix = "", expr = true })

    -- local scrollMappings = {
    --     ["<C-E>"] = { "<Plug>luasnip-next-choice", "Next choice" },
    -- }

    -- wk.register(scrollMappings, { mode = "i" })
    -- wk.register(scrollMappings, { mode = "s" })

    require("luasnip").config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
    })

    require("rv-luasnip/snippets")

end

return M
