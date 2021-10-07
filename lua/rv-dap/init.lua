local M = {}

M.config = function()

    local wk = require("which-key")

    local mappings = {
        d = {
            name = "DAP",
            b = {
                name = "Breakpoint",
                t = { require("dap").toggle_breakpoint, "Toggle"}
            },
            c = { require("dap").continue, "Continue" },
            s = {
                name = "Step",
                o = { require("dap").step_over, "Over" },
                i = { require("dap").step_into, "Into" },
            },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
