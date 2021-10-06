local M = {}

M.config = function()

    local opt = {
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Highlight request on run
        highlight = {
            enabled = true,
            timeout = 150,
        },
        -- Jump to request line on run
        jump_to_request = false,
    }

    require("rest-nvim").setup(opt)

    local wk = require("which-key")

    local mappings = {
        r = {
            name = "REST",
            r = { function() require("rest-nvim").run()     end, "Run under cursor"},
            p = { function() require("rest-nvim").run(true) end, "Preview current" },
            l = { function() require("rest-nvim").last()    end, "Last request" },
        }
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
