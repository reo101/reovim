local M = {}

M.config = function()

    local adapters = {
        lldb = require("rv-dap.adapters.lldb").config
    }

    local configurations = {
        cpp = require("rv-dap.configurations.cpp").config,
        c = require("rv-dap.configurations.c").config,
        -- rust = require("rv-dap.configurations.rust").config,
        scala = require("rv-dap.configurations.scala").config,
    }

    local function setup_adapters()
        for name, opt in pairs(adapters) do
            if type(opt) == "function" then
                opt()
            else
                require("dap").adapters[name] = opt
            end
        end
    end

    local function setup_configurations()
        for name, opt in pairs(configurations) do
            if type(opt) == "function" then
                opt()
            else
                require("dap").configurations[name] = opt
            end
        end
    end

    setup_adapters()
    setup_configurations()

    require("rv-dap.utils").dap_mappings()
    require("rv-dap.utils").dap_override_icons()
    require("rv-dap.utils").dap_set_repl()

end

return M
