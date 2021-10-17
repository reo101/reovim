local M = {}

M.config = function()

    local dap = require("dap")

    dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb"
    }

end

return M
