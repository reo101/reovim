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
local conds = require("luasnip.extras.expand_conditions")

local function params(args, snip, old_state, initial_text)
    local nodes = {}
	if not old_state then
        old_state = {}
    end

	-- -- count is nil for invalid input.
	-- local count = tonumber(args[1][1])
	-- -- Make sure there's a number in args[1].
	-- if count then
	-- 	for j=1, count do
	-- 		local iNode
	-- 		if old_state and old_state[j] then
	-- 			-- old_text is used internally to determine whether
	-- 			-- dependents should be updated. It is updated whenever the
	-- 			-- node is left, but remains valid when the node is no
	-- 			-- longer 'rendered', whereas node:get_text() grabs the text
	-- 			-- directly from the node.
	-- 			iNode = i(j, old_state[j].old_text)
	-- 		else
	-- 		  iNode = i(j, initial_text)
	-- 		end
	-- 		nodes[2*j-1] = iNode
	--
	-- 		-- linebreak
	-- 		nodes[2*j] = t({"",""})
	-- 		-- Store insertNode in old_state, potentially overwriting older
	-- 		-- nodes.
	-- 		old_state[j] = iNode
	-- 	end
	-- else
	-- 	nodes[1] = t("Enter a number!")
	-- end

    print(vim.inspect(args))

    if args[1][1] == "void" then
        nodes[1] = t(" ")
        nodes[2] = i(1, "param_name")
    else
        nodes[1] = t("")
    end

	local new_snip = sn(nil, nodes)
	new_snip.old_state = old_state
	return new_snip
end

local snippets = {
    -- faster HackerRank IO
    s("magic", {
        t({ "std::ios::sync_with_stdio(false);",
            "std::cin.tie(nullptr);" }),
    }),

    s("main", {
        t({ "int main() {", "    " }),
        i(0),
        t({ "", "", "    return 0;", "}" }),
    }),

    s("stdfunction", {
        t("std::function<"),
        i(1, "void"),
        t("("),
        i(2, "int"),
        t(")> "),
        i(3, "func"),
        t(" = ["),
        c(4, {
            t(""),
            t("&"),
            t("="),
        }),
        t("]("),
        rep(2),
        d(5, params, { 2 }),
        -- c(5, {
        --     t(nil),
        --     sn(nil, {
        --         t(" "),
        --         i(1, ""),
        --     }),
        -- }),
        t(") -> "),
        rep(1),
        t({ " {", "\t"}),
        i(0),
        t({ "", "};" }),
    }),
}

return snippets
