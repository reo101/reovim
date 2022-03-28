local packer = require("packer")

require("packer.luarocks").install_commands()

packer.startup({
    function(use, use_rocks)
        -- Packer
        use({ "wbthomason/packer.nvim" })

        -- Functional library
        use_rocks({
            "fun",
        })
        local fun = require("luafun.fun")

        -- Impatient
        use({ "lewis6991/impatient.nvim" })

        local function load_config(path)
            return function()
                require(path).config()
            end
        end

        -- Colourschemes
        local colourschemes = {
            -- name, repo[, active]
            { "monokai", "tanvirtin/monokai.nvim" },
            { "sonokai", "sainnhe/sonokai" },
            { "nightfox", "EdenEast/nightfox.nvim" },
            { "tokyonight", "folke/tokyonight.nvim", true },
            { "nebulous", "Yagua/nebulous.nvim" },
        }

        use({
            "folke/tokyonight.nvim",
            config = function()
                -- require("rv-tokyonight").config()
            end,
        })

        use({
            "EdenEast/nightfox.nvim",
            config = function()
                require("rv-nightfox").config()
            end,
        })

        -- TODO:
        -- fun.iter(colourschemes)
        --     :map(function(colourscheme)
        --         local opt = {
        --             colourscheme[2],
        --             config = load_config("rv-" .. colourscheme[1]),
        --         }
        --
        --         return opt
        --     end)
        --     :each(use)

        -- Telescope
        use({
            "nvim-telescope/telescope.nvim",
            requires = {
                { "nvim-lua/popup.nvim" },
                { "nvim-lua/plenary.nvim" },
            },
            config = function()
                require("rv-telescope").config()
            end,
        })

        local telescope_plugins = {
            "nvim-telescope/telescope-packer.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-github.nvim",
            "nvim-telescope/telescope-media-files.nvim",
            "nvim-telescope/telescope-symbols.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
        }

        local function convert_to_telescope_opt(telescope_plugin)
            local opt = {
                telescope_plugin,
                requires = {
                    { "nvim-telescope/telescope.nvim" },
                },
            }

            return opt
        end
        local function modify_fzf_native(opt)
            if opt[1] == "nvim-telescope/telescope-fzf-native" then
                opt = vim.tbl_deep_extend("force", {
                    run = "make",
                }, opt)
            end

            return opt
        end

        fun.iter(telescope_plugins)
            :map(convert_to_telescope_opt)
            :map(modify_fzf_native)
            :each(use)

        -- Neorg
        use({
            "vhyrro/neorg",
            requires = {
                { "hrsh7th/nvim-cmp" },
                { "nvim-lua/plenary.nvim" },
                { "vhyrro/neorg-telescope" },
            },
            after = {
                "telescope.nvim",
                "nvim-cmp",
            },
            config = function()
                require("rv-neorg").config()
            end,
        })
        use({
            "vhyrro/neorg-telescope",
            requires = {
                { "nvim-telescope/telescope.nvim" },
            },
        })

        -- Markdown Preview
        use({
            "iamcco/markdown-preview.nvim",
            run = vim.fn["mkdp#util#install"],
            config = function()
                require("rv-mdpreview").config()
            end,
        })
        use({
            "jghauser/follow-md-links.nvim",
            requires = { "nvim-treesitter/nvim-treesitter" },
            config = function()
                require("rv-mdlinks").config()
            end,
        })

        -- Silicon
        use({
            "segeljakt/vim-silicon",
            config = function()
                require("rv-silicon").config()
            end,
        })

        -- Which-key
        use({
            "folke/which-key.nvim",
            config = function()
                require("rv-whichkey").config()
                require("rv-whichkey.presets").config()
            end,
        })

        --Alpha
        use({
            "goolord/alpha-nvim",
            as = "alpha",
            config = function()
                require("rv-alpha").config()
            end,
        })

        -- Lualine
        use({
            "hoob3rt/lualine.nvim",
            as = "lualine",
            requires = { "kyazdani42/nvim-web-devicons", opt = true },
            after = { "gps" },
            config = function()
                require("rv-lualine").config()
            end,
        })
        use({
            "SmiteshP/nvim-gps",
            as = "gps",
            requires = { "nvim-treesitter/nvim-treesitter" },
            config = function()
                require("rv-gps").config()
            end,
        })

        -- Barbar
        use({
            "romgrk/barbar.nvim",
            as = "barbar",
            config = function()
                require("rv-barbar").config()
            end,
            opt = true,
        })

        -- BufferLine
        use({
            "akinsho/bufferline.nvim",
            as = "bufferline",
            requires = { "kyazdani42/nvim-web-devicons" },
            config = function()
                require("rv-bufferline").config()
            end,
        })

        -- DevIcons
        use({
            "kyazdani42/nvim-web-devicons",
            config = function()
                require("rv-devicons").config()
            end,
        })
        use({
            "yamatsum/nvim-nonicons",
            requires = { "kyazdani42/nvim-web-devicons" },
            after = { "nvim-web-devicons" },
            disable = true,
        })

        -- Colourizer
        use({
            "br1anchen/nvim-colorizer.lua",
            as = "colourizer",
            config = function()
                require("rv-colourizer").config()
            end,
        })

        -- Discord Rich Presence
        use({
            "andweeb/presence.nvim",
            as = "presence",
            config = function()
                require("rv-presence").config()
            end,
        })

        -- Cheat.sh
        use({
            "RishabhRD/nvim-cheat.sh",
            requires = { "RishabhRD/popfix" },
            config = function()
                require("rv-cheatsh").config()
            end,
        })

        -- Notify
        use({
            "rcarriga/nvim-notify",
            as = "notify",
            config = function()
                require("rv-notify").config()
            end,
        })

        -- LSP
        use({
            "neovim/nvim-lspconfig",
            config = function()
                require("rv-lsp").config()
            end,
        })
        use({
            "folke/trouble.nvim",
            requires = { "kyazdani42/nvim-web-devicons" },
            conqig = function()
                require("rv-lsp.trouble").config()
            end,
        })
        use({
            "ray-x/lsp_signature.nvim",
        })
        use({
            "kosayoda/nvim-lightbulb",
            config = function()
                require("rv-lsp.lightbulb").config()
            end,
            disable = true, -- TODO
        })
        use({
            "jose-elias-alvarez/null-ls.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
                "neovim/nvim-lspconfig",
            },
        })
        use({
            "nanotee/sqls.nvim",
            requires = {
                "vim-scripts/dbext.vim",
            },
        })
        use({
            "stevearc/aerial.nvim",
            config = function()
                require("rv-aerial").config()
            end,
        })
        use({
            "saecki/crates.nvim",
            event = { "BufRead Cargo.toml" },
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("rv-crates").config()
            end,
        })
        use({
            "weilbith/nvim-code-action-menu",
            as = "code-action-menu",
            cmd = "CodeActionMenu",
        })
        use({
            "NTBBloodbath/rest.nvim",
            ft = { "http" },
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("rv-rest").config()
            end,
        })
        use({
            "simrat39/rust-tools.nvim",
            config = function()
                require("rv-lsp.langs.rust-tools").config()
            end,
        })
        use({
            "mlochbaum/BQN",
            rtp = "editors/vim",
        })
        use({
            "shirk/vim-gas",
        })
        use({
            "aklt/plantuml-syntax",
        })
        use({
            "McSinyx/vim-octave",
        })
        use({
            "ThePrimeagen/refactoring.nvim",
            requires = {
                { "nvim-lua/plenary.nvim" },
                { "nvim-treesitter/nvim-treesitter" },
            },
            config = function()
                require("rv-refactoring").config()
            end,
        })
        use({
            "scalameta/nvim-metals",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("rv-lsp.langs.metals").config()
            end,
        })
        use({
            "Olical/aniseed",
            config = function()
                require("rv-aniseed").config()
            end,
        })
        use({
            "Olical/conjure",
            config = function()
                require("rv-conjure").config()
            end,
        })
        -- use({
        --     "eraserhd/parinfer-rust",
        --     run = "cargo build --release",
        --     config = function()
        --         require("rv-parinfer").config()
        --     end,
        -- })
        use({
            "stevearc/dressing.nvim",
            config = function()
                require("rv-dressing").config()
            end,
        })
        use({
            "mfussenegger/nvim-jdtls",
            config = function()
                require("rv-lsp.langs.jdtls").config()
            end,
        })
        use({
            "jakewvincent/texmagic.nvim",
            config = function()
                require("rv-lsp.langs.texmagic").config()
            end,
        })
        use({
            "jbyuki/nabla.nvim",
            config = function()
                require("rv-nabla").config()
            end,
        })
        use({
            "b0o/schemastore.nvim",
        })
        use({
            "j-hui/fidget.nvim",
            as = "fidget",
            config = function()
                require("rv-fidget").config()
            end,
            cond = require("globals").custom.lsp_progress == "fidget",
        })
        use({
            "nanotee/luv-vimdocs",
        })
        use({
            "milisims/nvim-luaref",
        })

        -- DAP
        use({
            "mfussenegger/nvim-dap",
            config = function()
                require("rv-dap").config()
            end,
        })
        use({
            "theHamsta/nvim-dap-virtual-text",
            requires = { "mfussenegger/nvim-dap" },
            config = function()
                require("rv-dap.virttext").config()
            end,
        })
        use({
            "rcarriga/nvim-dap-ui",
            requires = { "mfussenegger/nvim-dap" },
            config = function()
                require("rv-dap.dapui").config()
            end,
        })

        -- LuaSnip
        use({
            "L3MON4D3/LuaSnip",
            as = "luasnip",
            config = function()
                require("rv-luasnip").config()
            end,
        })
        use({
            "rafamadriz/friendly-snippets",
        })

        -- Shade
        use({
            "sunjon/shade.nvim",
            config = function()
                require("rv-shade").config()
            end,
            disable = true,
        })

        -- Twilight
        use({
            "folke/twilight.nvim",
            config = function()
                require("rv-twilight").config()
            end,
        })

        -- Transparency
        use({
            "xiyaowong/nvim-transparent",
            as = "nvim-transparency",
            config = function()
                require("rv-transparency").config()
            end,
        })

        -- CursorHold
        use({
            "antoinemadec/FixCursorHold.nvim",
            as = "cursorhold",
            config = function()
                require("rv-cursorhold").config()
            end,
        })

        -- Treesitter
        use({
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = function()
                require("rv-treesitter").config()
            end,
        })

        local treesitter_plugins = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                { as = "treesitter-textobjects" },
            },
            {
                "mfussenegger/nvim-ts-hint-textobject",
                { as = "treesitter-hint-textobject" },
            },
            {
                "nvim-treesitter/playground",
                { as = "treesitter-playground" },
            },
            { "p00f/nvim-ts-rainbow", { as = "treesitter-rainbow" } },
            {
                "romgrk/nvim-treesitter-context",
                {
                    as = "treesitter-context",
                    config = function()
                        require("rv-treesitter.context").config()
                    end,
                },
            },
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                { as = "treesitter-context-commentstring" },
            },
            { "windwp/nvim-ts-autotag", { as = "treesitter-autotag" } },
        }

        local function convert_to_treesitter_opt(treesitter_plugin)
            local opt = {
                treesitter_plugin[1],
                requires = {
                    { "nvim-treesitter/nvim-treesitter" },
                },
            }
            opt = vim.tbl_deep_extend("force", treesitter_plugin[2], opt)

            return opt
        end

        fun.iter(treesitter_plugins)
            :map(convert_to_treesitter_opt)
            :each(use)

        -- Cmp
        local cmp_sources = {
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-calc",
            "f3fora/cmp-spell",
            "andersevenrud/cmp-tmux",
            -- "kdheepak/cmp-latex-symbols",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-omni",
        }

        use({
            "hrsh7th/nvim-cmp",
            -- event = "InsertEnter",
            requires = cmp_sources,
            config = function()
                require("rv-cmp").config()
            end,
        })

        local function convert_to_cmp_opt(cmp_source)
            local opt = {
                cmp_source,
                after = { "nvim-cmp" },
                requires = {
                    { "hrsh7th/nvim-cmp" },
                },
            }

            return opt
        end

        fun.iter(cmp_sources)
            :map(convert_to_cmp_opt)
            :each(use)

        use({
            "windwp/nvim-autopairs",
            after = { "nvim-cmp" },
            config = function()
                require("rv-autopairs").config()
            end,
        })

        -- HLArgs
        use({
            "m-demare/hlargs.nvim",
            as = "hlargs",
            requires = { "nvim-treesitter/nvim-treesitter" },
            config = function()
                require("rv-hlargs").config()
            end,
        })

        -- Hop
        use({
            "phaazon/hop.nvim",
            as = "hop",
            config = function()
                require("rv-hop").config()
            end,
        })

        -- HLSlens
        use({
            "kevinhwang91/nvim-hlslens",
            config = function()
                require("rv-hlslens").config()
            end,
        })

        -- Surround
        use({
            "ur4ltz/surround.nvim",
            config = function()
                require("rv-surround").config()
            end,
        })

        -- Tabout
        use({
            "abecodes/tabout.nvim",
            requires = { "nvim-treesitter/nvim-treesitter" },
            after = { "nvim-cmp" },
            as = "tabout",
            config = function()
                require("rv-tabout").config()
            end,
        })

        -- Lastplace
        use({
            "ethanholz/nvim-lastplace",
            config = function()
                require("rv-lastplace").config()
            end,
        })

        -- Sort
        use({
            "sQVe/sort.nvim",
            config = function()
                require("rv-sort").config()
            end,
        })

        -- Navigator
        use({
            "numToStr/Navigator.nvim",
            as = "navigator",
            config = function()
                require("rv-navigator").config()
            end,
        })

        -- ToggleTerm
        use({
            "akinsho/toggleterm.nvim",
            as = "toggleterm",
            config = function()
                require("rv-toggleterm").config()
            end,
        })

        -- File Tree
        use({
            "nvim-neo-tree/neo-tree.nvim",
            as = "tree",
            branch = "v1.x",
            requires = {
                "nvim-lua/plenary.nvim",
                "kyazdani42/nvim-web-devicons",
                "MunifTanjim/nui.nvim",
            },
            config = function()
                require("rv-tree").config()
            end,
        })
        use({
            "elihunter173/dirbuf.nvim",
            config = function()
                require("rv-dirbuf").config()
            end,
        })

        -- Better increment/decrement
        use({
            "monaqa/dial.nvim",
            config = function()
                require("rv-dial").config()
            end,
        })

        -- EasyAlign
        use({
            "junegunn/vim-easy-align",
            config = function()
                require("rv-easyalign").config()
            end,
        })

        -- Neogit
        use({
            "TimUntersberger/neogit",
            requires = "nvim-lua/plenary.nvim",
            keys = { "<leader>gs" },
            config = function()
                require("rv-neogit").config()
            end,
        })
        use({
            "sindrets/diffview.nvim",
            after = { "neogit" },
            config = function()
                require("rv-diffview").config()
            end,
        })
        use({
            "lewis6991/gitsigns.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
            },
            config = function()
                require("rv-gitsigns").config()
            end,
        })
        use({
            "ThePrimeagen/git-worktree.nvim",
            requires = {
                "nvim-treesitter/nvim-treesitter",
            },
            config = function()
                require("rv-gitworktrees").config()
            end,
        })
        use({
            "pwntester/octo.nvim",
            requires = {
                { "kyazdani42/nvim-web-devicons", opt = true },
            },
            config = function()
                require("rv-octo").config()
            end,
            opt = true,
        })
        use({
            "ruifm/gitlinker.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("rv-gitlinker").config()
            end,
        })

        -- Comments
        use({
            "numToStr/Comment.nvim",
            as = "comments",
            config = function()
                require("rv-comments").config()
            end,
        })
        use({
            "folke/todo-comments.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("rv-todocomments").config()
            end,
        })

        -- Pretty folds
        use({
            "anuvyklack/pretty-fold.nvim",
            config = function()
                require("rv-prettyfold").config()
            end,
        })

        -- Regexplainer
        use({
            "bennypowers/nvim-regexplainer",
            as = "regexplainer",
            config = function()
                require("rv-regexplainer").config()
            end,
        })

        -- Numbertoggle
        use({ "jeffkreeftmeijer/vim-numbertoggle" })

        -- Auto mkdir -p
        use({
            "jghauser/mkdir.nvim",
            config = function()
                require("mkdir")
            end,
        })

        -- BufDelete
        use({
            "famiu/bufdelete.nvim",
            config = function()
                require("rv-bufdelete").config()
            end,
        })

        -- BufResize
        use({
            "kwkarlwang/bufresize.nvim",
            config = function()
                require("rv-bufresize").config()
            end,
        })

        -- Stabilize
        use({
            "luukvbaal/stabilize.nvim",
            config = function()
                require("rv-stabilize").config()
            end,
        })

        -- WinShift
        use({
            "sindrets/winshift.nvim",
            config = function()
                require("rv-winshift").config()
            end,
        })

        -- Spellcheck
        use({
            "lewis6991/spellsitter.nvim",
            config = function()
                require("rv-spellsitter").config()
            end,
        })

        -- Reload
        use({
            "famiu/nvim-reload",
            config = function()
                require("rv-reload").config()
            end,
        })

        -- Quickfix List
        use({
            "kevinhwang91/nvim-bqf",
            config = function()
                require("rv-betterquickfix").config()
            end,
        })
        use({
            "https://gitlab.com/yorickpeterse/nvim-pqf.git",
            config = function()
                require("rv-prettyquickfix").config()
            end,
        })

        -- Indentline
        use({
            "lukas-reineke/indent-blankline.nvim",
            as = "indentline",
            config = function()
                require("rv-indentline").config()
            end,
        })

        -- Beacon
        use({
            "edluffy/specs.nvim",
            as = "beacon",
            config = function()
                require("rv-beacon").config()
            end,
        })
    end,
    config = {
        profile = {
            enable = true,
            threshold = 1,
        },
        display = {
            open_fn = function()
                return require("packer.util").float({ border = "single" })
            end,
        },
        compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
    },
})
