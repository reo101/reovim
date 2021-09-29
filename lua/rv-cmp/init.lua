local M = {}

M.config = function()

    local esc = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
    end

    local opt = {
        mapping = {
            ["<Tab>"] = require("cmp").mapping(function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(esc([[<C-n>]]), "n")
                elseif require("luasnip").expand_or_jumpable() then
                    vim.fn.feedkeys(esc([[<Cmd>lua require("luasnip").expand_or_jump()<CR>]]), "")
                elseif check_back_space() then
                    vim.fn.feedkeys(esc([[<Tab>]]), "n")
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = require("cmp").mapping(function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(esc([[<C-p>]]), "n")
                elseif require("luasnip").jumpable(-1) then
                    vim.fn.feedkeys(esc([[<Cmd>lua require("luasnip").jump(-1)<CR>]]), "")
                else
                    fallback()
                end
            end, { "i", "s" }),
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
        event = {
            on_confirm_done = function(entry)
                local line = require('nvim-autopairs.utils').text_get_current_line(0)
                local _, col = require('nvim-autopairs.utils').get_cursor()
                local prev_char, next_char = require('nvim-autopairs.utils').text_cusor_line(line, col, 1, 1, false)
                local item = entry:get_completion_item()
                if prev_char ~= '(' and next_char ~= '(' then
                    if item.kind == require("cmp").lsp.CompletionItemKind.Method or item.kind == require("cmp").lsp.CompletionItemKind.Function then
                        -- check insert text have ( from snippet
                        if
                            (
                            item.textEdit
                            and item.textEdit.newText
                            and item.textEdit.newText:match('[%(%[]')
                            )
                            or (item.insertText and item.insertText:match('[%(%[]'))
                        then
                            return
                        end
                        vim.api.nvim_feedkeys('(', '', true)
                    end
                end
            end,
        },
        completion = {
            completeopt = "menuone,preview,noinsert",
        },
        documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        formatting = {
            format = function(entry, vim_item)
                -- fancy icons and a name of kind
                vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

                -- set a name for each source
                vim_item.menu = ({
                    path = "[Path]",
                    calc = "[Calc]",
                    spell = "[Spell]",
                    buffer = "[Buffer]",
                    nvim_lua = "[Lua]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    tmux = "[Tmux]",
                    latex_symbols = "[Latex]",
                })[entry.source.name]
                vim_item.dup = ({
                    buffer = 1,
                    path = 1,
                    nvim_lsp = 0,
                })[entry.source.name] or 0
                return vim_item
            end,
        },
        sources = {
            {
                name = "buffer",
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end,
            },
            { name = "path" },
            { name = "calc" },
            { name = "spell" },
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "luasnip" },
            {
                name = "tmux",
                opts = {
                    all_panes = false,
                },
            },
            { name = "latex_symbols" }
        },
    }

    vim.api.nvim_set_keymap(
        "i",
        "<CR>",
        "v:lua.MPairs.autopairs_cr()",
        { expr = true, noremap = true }
    )

    require("luasnip/loaders/from_vscode").lazy_load()
    require("cmp").setup(opt)

end

return M
