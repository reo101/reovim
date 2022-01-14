local M = {}

M.config = function()

    local opt = {
        history = false,
        updateevents = "InsertLeave,TextChanged,TextChangedI",
        region_check_events = "CursorMoved,CursorHold,InsertEnter",
        ext_opts = {
            [require("luasnip.util.types").choiceNode] = {
                active = {
                    virt_text = {{"●", "DiagnosticError"}}
                }
            },
            [require("luasnip.util.types").insertNode] = {
                active = {
                    virt_text = {{"●", "DiagnosticInfo"}}
                }
            }
        },
    }

    require("luasnip").config.setup(opt)
    require("luasnip.loaders.from_vscode").lazy_load()

    local luasnip = require("luasnip")

    function _G.snippets_clear()
        for m, _ in pairs(luasnip.snippets) do
            package.loaded["snippets."..m] = nil
        end
        luasnip.snippets = setmetatable({}, {
            __index = function(t, k)
                local ok, m = pcall(require, "snippets." .. k)
                if not ok and not string.match(m, "module.*not found:") then
                    error(m)
                end
                t[k] = ok and m or {}
                return t[k]
            end
        })
    end

    _G.snippets_clear()

    vim.cmd [[
    augroup snippets_clear
    au!
    au BufWritePost ~/.config/nvim/lua/snippets/*.lua lua _G.snippets_clear()
    augroup END
    ]]

    function _G.edit_ft()
        -- returns table like {"lua", "all"}
        local fts = require("luasnip.util.util").get_snippet_filetypes()
        vim.ui.select(fts, {
            prompt = "Select which filetype to edit:"
        }, function(item, idx)
            -- selection aborted -> idx == nil
            if idx then
                vim.cmd("edit ~/.config/nvim/lua/snippets/"..item..".lua")
            end
        end)
    end

    vim.cmd [[command! LuaSnipEdit :lua _G.edit_ft()]]
end

return M
