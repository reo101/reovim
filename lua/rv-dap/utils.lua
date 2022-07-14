local M = {}

local dap_mappings = function()
    local dk = require("def-keymaps")

    local mappings = {
        d = {
            name = "DAP",
            b = {
                name = "Breakpoint",
                t = { require("dap").toggle_breakpoint, "Toggle"},
                c = { function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, "Set conditional" },
            },
            c = { require("dap").continue, "Continue" },
            C = { require("dap").run_to_cursor, "Run to Cursor" },
            s = {
                hydra = true,
                name = "Step",
                o = { require("dap").step_over, "Over" },
                i = { require("dap").step_into, "Into" },
                u = { require("dap").step_out, "Out" },
                b = { require("dap").step_back, "Back" },
            },
            -- p = { require("dap").pause.toggle, "Pause" },
            r = { require("dap").repl.toggle, "REPL"},
            d = { require("dap").disconnect, "Disconnect" },
            q = { require("dap").close, "Quit" },
            g = { require("dap").session, "Get Session" },
        },
    }

    dk("n", mappings, "<leader>")
end

local dap_override_icons = function()
    local signs = {
        Breakpoint = {
            text = "",
            texthl = "DiagnosticSignError",
            linehl = "",
            numhl = "",
        },
        -- TODO: da
        BreakpointCondition = {
            text = "",
            texthl = "DiagnosticSignHint",
            linehl = "",
            numhl = "",
        },
        BreakpointRejected = {
            text = "",
            texthl = "DiagnosticSignHint",
            linehl = "",
            numhl = "",
        },
        Stopped = {
            text = "",
            texthl = "DiagnosticSignInformation",
            linehl = "DiagnosticUnderlineInfo",
            numhl = "DiagnosticSignInformation",
        },
    }

    for type, data in pairs(signs) do
        local name = "Dap" .. type
        vim.fn.sign_define(name, data)
    end
end

local dap_set_repl = function()
    require("dap").defaults.fallback.terminal_win_cmd = "50vsplit new"
    vim.cmd([[
          au FileType dap-repl lua require("dap.ext.autocompl").attach()
    ]])
end

M.dap_mappings = dap_mappings
M.dap_override_icons = dap_override_icons
M.dap_set_repl = dap_set_repl

return M
