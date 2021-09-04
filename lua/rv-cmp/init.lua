local M = {}

M.config = function()

    local function prequire(...)
        local status, lib = pcall(require, ...)
        if (status) then return lib end
        return nil
    end

    local luasnip = prequire("luasnip")

    local esc = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col(".") - 1
        if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
            return true
        else
            return false
        end
    end

    local opt = {
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        mapping = {
            ["<Tab>"] = require("cmp").mapping(function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(esc([[<C-n>]]), "n")
                elseif luasnip and luasnip.expand_or_jumpable() then
                    vim.fn.feedkeys(esc([[<Cmd>lua require("luasnip").jump(1)<CR>]]), "")
                elseif check_back_space() then
                    vim.fn.feedkeys(esc([[<Tab>]]), "n")
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = require("cmp").mapping(function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(esc([[<C-p>]]), "n")
                elseif luasnip and luasnip.jumpable(-1) then
                    vim.fn.feedkeys(esc([[<Cmd>lua require("luasnip").jump(-1)<CR>]]), "")
                else
                    fallback()
                end
            end, { "i", "s" }),
            -- ["<CR>"] = function(fallback)
            --     if vim.fn.pumvisible() == 1 then
            --         require("cmp").mapping.confirm({
            --             behavior = require("cmp").ConfirmBehavior.Insert,
            --             select = true,
            --         })
            --     else
            --         fallback()
            --         -- vim.fn.feedkeys(
            --         --     require("nvim-autopairs").autopairs_cr()
            --         -- )
            --     end
            -- end,
            ["<CR>"] = require("cmp").mapping.confirm({
                behavior = require("cmp").ConfirmBehavior.Replace,
                select = true,
            }),
            ["<C-n>"] = require("cmp").mapping.select_next_item(),
            ["<C-p>"] = require("cmp").mapping.select_prev_item(),
            ["<C-d>"] = require("cmp").mapping.scroll_docs(-4),
            ["<C-f>"] = require("cmp").mapping.scroll_docs(4),
            ["<C-e>"] = require("cmp").mapping.close(),
            ["<C-y>"] = require("cmp").mapping.confirm({
                behavior = require("cmp").ConfirmBehavior.Insert,
                select = true,
            }),
            ["<C-Space>"] = require("cmp").mapping.complete(),
        },
        completion = {
            completeopt = "menu,menuone,preview,noinsert",
            -- autocomplete = true,
        },
        -- documentation = { },
        -- sorting = {
        --     priority_weight = 2.,
        --     comparators = {  },
        -- },
        formatting = {
            format = function(entry, vim_item)
                -- fancy icons and a name of kind
                vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

                -- set a name for each source
                vim_item.menu = ({
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[Latex]",
                })[entry.source.name]
                return vim_item
            end,
        },
        sources = {
            { name = "buffer" },
            { name = "path" },
            { name = "calc" },
            { name = "spell" },
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "luansip" },
            {
                name = "tmux",
                opts = {
                    all_panes = false,
                    label = "[tmux]",
                },
            },
            { name = "latex_symbols" }
        },
    }

    vim.opt.completeopt = "menuone,preview,noinsert,noselect"
    require("cmp").setup(opt)

end

return M
