local M = {}

M.config = function()

    local function prequire(...)
        local status, lib = pcall(require, ...)
        if (status) then return lib end
        return nil
    end

    local luasnip = prequire("luasnip")

    require("luasnip").config.set_config({
        history = false,
        updateevents = "TextChanged,TextChangedI",
    })

    require("luasnip.loaders.from_vscode").lazy_load({
        paths = {
            vim.fn.stdpath("data") .. "/site/pack/packer/start/friendly-snippets"
        }
    })

end

return M
