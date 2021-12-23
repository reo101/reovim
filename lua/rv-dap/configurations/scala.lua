local M = {}

M.config = function()

    local dap = require("dap")

    dap.configurations.scala = {
        {
            type = "scala",
            request = "launch",
            name = "Run",
            metals = {
                runType = "run",
                -- again... example, don't leave these in here
                -- args = { "firstArg", "secondArg", "thirdArg" },
            },
        },
        {
            type = "scala",
            request = "launch",
            name = "Test File",
            metals = {
                runType = "testFile",
            },
        },
        {
            type = "scala",
            request = "launch",
            name = "Test Target",
            metals = {
                runType = "testTarget",
            },
        },
    }

end

return M
