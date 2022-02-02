local M = {}

M.config = function()

    local opt = {
        prefix = "s",
        context_offset = 100,
        load_autogroups = false,
        mappings_style = "surround",
        map_insert_mode = false,
        prompt = false,
        quotes = {[[']], [["]]},
        brackets = {"(", "{", "["},
        pairs = {
            nestable = {
                b = {"(", ")"},
                s = {"[", "]"},
                B = {"{", "}"},
                a = {"<", ">"},
            },
            linear = {
                q = {"'", "'"},
                t = {"`", "`"},
                d = {'"', '"'},
                p = {"|", "|"},
            },
        },
    }

    require("surround").setup(opt)

    local wk = require("which-key")


    -- Normal Mode - Sandwich Mode
    --
    --     Provides key mapping to add surrounding characters.( visually select then press s<char> or press sa{motion}{char})
    --     Provides key mapping to replace surrounding characters.( sr<from><to> )
    --     Provides key mapping to delete surrounding characters.( sd<char> )
    --     ss repeats last surround command. (Doesn't work with add)
    --
    -- Normal Mode - Surround Mode
    --
    --     Provides key mapping to add surrounding characters.( visually select then press s<char> or press ys{motion}{char})
    --     Provides key mapping to replace surrounding characters.( cs<from><to> )
    --     Provides key mapping to delete surrounding characters.( ds<char> )

    local mappings = {
        ["sandwich"] =  {
            s = {
                name = "Sandwich",
                a = { "Add" },
                r = { "Replace" },
                d = { "Delete" },
            },
        },
        ["surround"] = {
            ["ys"] = { "Surround" },
            ["cs"] = { "Surround" },
            ["ds"] = { "Surround" },
        },
    }

    wk.register(mappings[opt.mappings_style], { prefix = "" })

end

return M
