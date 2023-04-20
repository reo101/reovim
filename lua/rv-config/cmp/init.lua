local M = {}

M.config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    local esc = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
    end

    local opt = {
        mapping = {
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.jumpable() then
                    luasnip.jump(1)
                -- elseif luasnip.expand_or_locally_jumpable() then
                --     luasnip.expand_or_jump()
                elseif check_back_space() then
                    vim.fn.feedkeys(esc([[<Tab>]]), "n")
                else
                    fallback()
                end
            end, { "i", "s", "c" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s", "c" }),
            ["<CR>"] = cmp.mapping({
                i = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),
                c = cmp.mapping.confirm({
                    select = false,
                }),
            }) ,
            ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
            ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<C-e>"] = cmp.mapping({
                i = function(fallback)
                    if cmp.visible() then
                        cmp.abort()
                    elseif luasnip.choice_active() then
                        luasnip.change_choice(1)
                    else
                        fallback()
                    end
                end,
                s = function(fallback)
                    if cmp.visible() then
                        cmp.abort()
                    elseif luasnip.choice_active() then
                        luasnip.change_choice(1)
                    else
                        fallback()
                    end
                end,
                c = cmp.mapping.close(),
            }),
            ["<C-y>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            }),
            ["<C-Space>"] = cmp.mapping.complete(),
        },
        -- enabled = function()
        --     -- -- disable completion in comments
        --     local context = cmp.config.context
        --     return not context.in_treesitter_capture("comment")
        --         and not context.in_syntax_group("Comment")
        -- end,
        event = {
            on_confirm_done = require("nvim-autopairs.completion.cmp").on_confirm_done({
                filetypes = {
                    tex = false,
                },
            }),
        },
        completion = {
            completeopt = "menuone,preview,noinsert,noselect",
        },
        experimental = {
            native_menu = false,
            ghost_text = true,
        },
        window = {
            documentation = {
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            },
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        formatting = {
            format = function(entry, vim_item)
                -- fancy icons and a name of kind
                vim_item.kind = ({
                    Class = " ",
                    Color = " ",
                    Constant = "ﲀ ",
                    Constructor = " ",
                    Enum = "練",
                    EnumMember = " ",
                    Event = " ",
                    Field = " ",
                    File = "",
                    Folder = " ",
                    Function = " ",
                    Interface = "ﰮ ",
                    Keyword = " ",
                    Method = " ",
                    Module = " ",
                    Operator = "",
                    Property = " ",
                    Reference = " ",
                    Snippet = " ",
                    Struct = " ",
                    Text = " ",
                    TypeParameter = " ",
                    Unit = "塞",
                    Value = " ",
                    Variable = " ",
                })[vim_item.kind] .. " " .. vim_item.kind

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
                    --    latex_symbols = "[LaTeX]",
                    crates = "[Crates]",
                    neorg = "[Neorg]",
                })[entry.source.name]

                -- allow duplicates for certain sources
                vim_item.dup = ({
                    buffer = 1,
                    path = 1,
                    nvim_lsp = 0,
                    luasnip = 1,
                })[entry.source.name] or 0

                return vim_item
            end,
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            {
                name = "buffer",
                option = {
                    get_bufnrs = function()
                        -- Visible Buffers
                        local bufs = {}
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            bufs[vim.api.nvim_win_get_buf(win)] = true
                        end
                        return vim.tbl_keys(bufs)

                        -- All Buffers
                        -- return vim.api.nvim_list_bufs()
                    end,
                },
            },
            { name = "nvim_lua" },
            { name = "path" },
            { name = "calc" },
            { name = "spell" },
            {
                name = "tmux",
                option = {
                    all_panes = false,
                },
            },
            -- { name = "latex_symbols" },
            { name = "crates" },
            { name = "neorg" },
            { name = "omni" },
        },
        sorting = {
            -- comparators = {
            --     function(...) return cmp_buffer:compare_locality(...) end,
            -- },
        },
    }

    -- TODO:
    vim.o.omnifunc="syntaxcomplete#Complete"

    -- Use buffer source for `/`.
    cmp.setup.cmdline('/', {
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use buffer source for `?`.
    cmp.setup.cmdline('?', {
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use cmdline & path source for ':'.
    cmp.setup.cmdline(':', {
        sources = cmp.config.sources(
            {
                { name = "cmdline" }
            }
        )
    })

    -- Use appropriate sources for `gitcommit`
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "cmp_git" },
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "nvim_lsp_document_symbol" },
            { name = "buffer" },
            { name = "dictionary" },
            { name = "spell" },
            { name = "path" },
        }),
    })

    cmp.setup(opt)

end

return M
