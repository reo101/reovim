local M = {}

M.config = function()
    local opt = {
        -- prompt for return type
        prompt_func_return_type = {
            go = true,
            cpp = true,
            c = true,
            java = true,
        },
        -- prompt for function parameters
        prompt_func_param_type = {
            go = true,
            cpp = true,
            c = true,
            java = true,
        },
    }

    require("refactoring").setup(opt)

    local wk = require("which-key")

    local mappings = {
        r = {
            name = "Refactor",
            i = {
                function()
                    require("refactoring").refactor("Inline Variable")
                end,
                "Inline Variable",
            },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

    local visualMappings = {
        r = {
            name = "Refactor",
            e = {
                function()
                    require("refactoring").refactor("Extract Function")
                end,
                "Extract Function",
            },
            f = {
                function()
                    require("refactoring").refactor("Extract Function To File")
                end,
                "Extract Function To File",
            },
            v = {
                function()
                    require("refactoring").refactor("Extract Variable")
                end,
                "Extract Variable",
            },
            i = {
                function()
                    require("refactoring").refactor("Inline Variable")
                end,
                "Inline Variable",
            },
            t = {
                require("telescope").extensions.refactoring.refactors,
                "Refactors",
            },
        },
    }

    wk.register(
        visualMappings,
        { mode = "v", noremap = true, silent = true, expr = false }
    )
end

return M
