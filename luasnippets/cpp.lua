local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions.expand")

local return_type = function(args)
    if args[1][1] == "void" then
        return ""
    else
        return " -> " .. args[1][1] .. " "
    end

    return sn(nil, i(1, os.date(fmt)))
end

local params = function(args, snip, old_state, ...)
    local nodes = {}

    if args[1][1] == "" or args[1][1] == "void" then
        table.insert(nodes, t(""))
    else
        -- TODO: do this with TS
        local index = 1

        for type in (args[1][1] .. ","):gmatch("(.-)%s*,%s*") do
            P(type)
            table.insert(nodes, t(type .. " "))
            -- table.insert(nodes, i(index, type .. "_param"))
            table.insert(nodes, i(index, "param" .. index))
            table.insert(nodes, t(", "))
            index = index + 1
        end

        -- Remove trailing comma
        table.remove(nodes, #nodes)
    end

    return sn(nil, nodes)
end

local snippets = {
    s(
        "func",
        fmt(
            [[
            std::function<{}({})> {} = [{}]({}){}{{
                {}
            }};
            ]],
            {
                -- return type
                i(1, "void"),
                -- param types
                i(2, "int"),
                -- name
                i(3, "func"),
                -- captures
                c(4, {
                    t(""),
                    t("&"),
                    t("="),
                }),
                -- params
                d(5, params, { 2 }),
                -- return type
                f(return_type, { 1 }),
                -- body
                i(0),
            }
        )
    ),

    -- faster HackerRank IO
    s(
        "magic",
        fmt(
            [[
            std::ios::sync_with_stdio(false);
            std::cin.tie(nullptr);
            ]],
            {}
        )
    ),

    s(
        "main",
        fmt(
            [[
            int main() {{
                {}

                return 0;
            }}
            ]],
            { i(0) }
        )
    ),
}

return snippets
