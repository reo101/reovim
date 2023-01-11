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
                if require("cmp").visible() then
                    require("cmp").select_next_item()
                elseif require("luasnip").jumpable() then
                    require("luasnip").jump(1)
                -- elseif require("luasnip").expand_or_locally_jumpable() then
                --     require("luasnip").expand_or_jump()
                elseif check_back_space() then
                    vim.fn.feedkeys(esc([[<Tab>]]), "n")
                else
                    fallback()
                end
            end, { "i", "s", "c" }),
            ["<S-Tab>"] = require("cmp").mapping(function(fallback)
                if require("cmp").visible() then
                    require("cmp").select_prev_item()
                elseif require("luasnip").jumpable(-1) then
                    require("luasnip").jump(-1)
                else
                    fallback()
                end
            end, { "i", "s", "c" }),
            ["<CR>"] = require("cmp").mapping({
                i = require("cmp").mapping.confirm({
                    behavior = require("cmp").ConfirmBehavior.Replace,
                    select = true,
                }),
                c = require("cmp").mapping.confirm({
                    select = false,
                }),
            }) ,
            ["<C-n>"] = require("cmp").mapping(require("cmp").mapping.select_next_item(), { "i", "c" }),
            ["<C-p>"] = require("cmp").mapping(require("cmp").mapping.select_prev_item(), { "i", "c" }),
            ["<C-d>"] = require("cmp").mapping(require("cmp").mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-f>"] = require("cmp").mapping(require("cmp").mapping.scroll_docs(4), { "i", "c" }),
            ["<C-e>"] = require("cmp").mapping({
                i = function(fallback)
                    if require("cmp").visible() then
                        require("cmp").abort()
                    elseif require("luasnip").choice_active() then
                        require("luasnip").change_choice(1)
                    else
                        fallback()
                    end
                end,
                s = function(fallback)
                    if require("cmp").visible() then
                        require("cmp").abort()
                    elseif require("luasnip").choice_active() then
                        require("luasnip").change_choice(1)
                    else
                        fallback()
                    end
                end,
                c = require("cmp").mapping.close(),
            }),
            ["<C-y>"] = require("cmp").mapping.confirm({
                behavior = require("cmp").ConfirmBehavior.Insert,
                select = true,
            }),
            ["<C-Space>"] = require("cmp").mapping.complete(),
        },
        -- enabled = function()
        --     -- -- disable completion in comments
        --     local context = require("cmp.config.context")
        --     return not context.in_treesitter_capture("comment")
        --         and not context.in_syntax_group("Comment")
        -- end,
        event = {
            on_confirm_done = require("nvim-autopairs.completion.cmp").on_confirm_done({  map_char = { tex = '' } }),
        },
        completion = {
            completeopt = "menuone,preview,noinsert",
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
                require("luasnip").lsp_expand(args.body)
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
            --     function(...) return require("cmp_buffer"):compare_locality(...) end,
            -- },
        },
    }

    -- TODO:
    vim.o.omnifunc="syntaxcomplete#Complete"

    -- Use buffer source for `/`.
    require("cmp").setup.cmdline('/', {
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use buffer source for `?`.
    require("cmp").setup.cmdline('?', {
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use cmdline & path source for ':'.
    require("cmp").setup.cmdline(':', {
        sources = require("cmp").config.sources(
            {
                { name = "path" }
            }, {
                { name = "cmdline" }
            }
        )
    })

    require("cmp").setup(opt)

end

return M
