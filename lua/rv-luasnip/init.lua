local M = {}

M.config = function()
    local opt = {
        history = false,
        updateevents = "InsertLeave,TextChanged,TextChangedI",
        region_check_events = "CursorMoved,CursorHold,InsertEnter",
        ext_opts = {
            [require("luasnip.util.types").choiceNode] = {
                active = {
                    virt_text = { { "●", "DiagnosticError" } },
                },
            },
            [require("luasnip.util.types").insertNode] = {
                active = {
                    virt_text = { { "●", "DiagnosticInfo" } },
                },
            },
        },
    }

    require("luasnip").config.setup(opt)
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load()

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            l = {
                require("luasnip.loaders.from_lua").edit_snippet_files,
                "LuaSnip snippets",
            },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })
end

return M
