(import-macros
  {: rv
   : ||>
   : forieach
   : imap}
  :init-macros)

(local {: lsp_progress}
       (. (require :globals) :custom))

;; Treesitter
(local treesitter-plugins
         [{1       :nvim-treesitter/nvim-treesitter
           :config (rv :treesitter)
           :build    ":TSUpdate"}
          {1             :HiPhish/rainbow-delimiters.nvim
           ;; :dependencies [:nvim-treesitter/nvim-treesitter]
           :config       (rv :treesitter.rainbow)}
          (unpack
            (let [treesitter-plugins
                   [:nvim-treesitter/nvim-treesitter-textobjects
                    :mfussenegger/nvim-ts-hint-textobject
                    :nvim-treesitter/playground
                    :romgrk/nvim-treesitter-context
                    :JoosepAlviste/nvim-ts-context-commentstring
                    :windwp/nvim-ts-autotag
                    :RRethy/nvim-treesitter-textsubjects]
                  convert-to-treesitter-opt
                   (fn [treesitter-plugin]
                     {1             treesitter-plugin
                      :dependencies [:nvim-treesitter/nvim-treesitter]})]
              (imap treesitter-plugins
                    convert-to-treesitter-opt)))])


;; Telescope
(local telescope-plugins
       [{1             :nvim-telescope/telescope.nvim
         :dependencies [:nvim-lua/popup.nvim
                        :nvim-lua/plenary.nvim]
         :config       (rv :telescope)}
        (unpack
          (let [telescope-plugins
                  [:nvim-telescope/telescope-packer.nvim
                   :nvim-telescope/telescope-fzf-native.nvim
                   :nvim-telescope/telescope-github.nvim
                   :nvim-telescope/telescope-media-files.nvim
                   :nvim-telescope/telescope-symbols.nvim
                   :nvim-telescope/telescope-file-browser.nvim]
                 convert-to-telescope-opt
                  (fn [telescope-plugin]
                    (let [opt {1 telescope-plugin
                               :dependencies [:nvim-telescope/telescope.nvim]}]
                      opt))
                 modify-fzf-native
                  (fn [opt]
                    (if (= (. opt 1) :nvim-telescope/telescope-fzf-native)
                        (vim.tbl_deep_extend :force
                                             {:build :make}
                                             opt)
                        ;; else
                        opt))]
            (imap telescope-plugins
                  (||>
                    convert-to-telescope-opt
                    modify-fzf-native))))])

;; Cmp
(local cmp-plugins
  (let [cmp-sources
         [:hrsh7th/cmp-nvim-lsp
          :saadparwaiz1/cmp_luasnip
          :hrsh7th/cmp-buffer
          :hrsh7th/cmp-nvim-lua
          :hrsh7th/cmp-path
          :hrsh7th/cmp-calc
          :f3fora/cmp-spell
          :andersevenrud/cmp-tmux
          :hrsh7th/cmp-cmdline
          :hrsh7th/cmp-omni
          :kdheepak/cmp-latex-symbols]
        convert-to-cmp-opt
         (fn [cmp-source]
             (let [opt {1             cmp-source
                        :dependencies [:hrsh7th/nvim-cmp]}]
               opt))]
    [{1             :hrsh7th/nvim-cmp
      :dependencies [:nvim-treesitter/nvim-treesitter
                     :windwp/nvim-autopairs
                     (unpack cmp-sources)]
      :config       (rv :cmp)}
     (unpack
       (imap cmp-sources
             convert-to-cmp-opt))]))

(var normal-plugins
    [;; Fennel loader
     {1       :udayvir-singh/tangerine.nvim
      :tag "v2.7"
      :priority 1000
      :lazy false}
      ;; :config (rv :tangerine}

     ;; Theme
     {1        :folke/tokyonight.nvim
      :priority 1000
      :lazy false
      :config  (rv :tokyonight)}

     {1             :vhyrro/neorg
      :dependencies [:hrsh7th/nvim-cmp
                     :nvim-lua/plenary.nvim
                     :nvim-neorg/neorg-telescope
                     :nvim-telescope/telescope.nvim
                     :nvim-treesitter/nvim-treesitter]
      :version      :v5.0.0
      :config       (rv :neorg)
      :cmd          ["Neorg"]}
     {1             :nvim-neorg/neorg-telescope
      :dependencies [:nvim-telescope/telescope.nvim]}
     {1             :jghauser/follow-md-links.nvim
      :dependencies [:nvim-treesitter/nvim-treesitter]
      :ft           ["markdown"]
      :config       (rv :mdlinks)}
     ;;  {1 :nvim-orgmode/orgmode
     ;;       :dependencies [:nvim-treesitter/nvim-treesitter]
     ;;       :config (rv :orgmode)})
     ;;  {1 :lukas-reineke/headlines.nvim
     ;;       :dependencies [:nvim-orgmode/orgmode]
     ;;                      :nvim-treesitter/nvim-treesitter]
     ;;       :config (rv :headlines)})
     {1             :phaazon/mind.nvim
      :dependencies [:nvim-lua/plenary.nvim]
      :branch       :v2.2
      :config       (rv :mind)}
     {1       :folke/which-key.nvim
      :config (fn []
                (rv :whichkey)
                (rv :whichkey.presets))}
     {1 :anuvyklack/hydra.nvim}
     {1             :rebelot/heirline.nvim
      :config       (rv :heirline)
      :dependencies [:SmiteshP/nvim-navic
                     :kyazdani42/nvim-web-devicons
                     :lewis6991/gitsigns.nvim]}
     {1             :SmiteshP/nvim-navic
      :config       (rv :navic)
      :dependencies [:nvim-treesitter/nvim-treesitter]}
     {1       :kyazdani42/nvim-web-devicons
      :config (rv :devicons)}
     {1       :NvChad/nvim-colorizer.lua
      :config (rv :colourizer)}
     {1       :rcarriga/nvim-notify
      :config (rv :notify)}
     {1       :neovim/nvim-lspconfig
      :config (rv :lsp)}
     {1             :folke/trouble.nvim
      :dependencies [:kyazdani42/nvim-web-devicons]
      :config       (rv :lsp.trouble)}
     {1       "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
      :config (rv :lsp.lines)}
     {1             :saecki/crates.nvim
      :dependencies [:nvim-lua/plenary.nvim]
      :config       (rv :crates)
      :event        ["BufRead Cargo.toml"]}
     {1             :NTBBloodbath/rest.nvim
      :dependencies [:nvim-lua/plenary.nvim]
      :config       (rv :rest)
      :ft           [:http]}
     {1       :simrat39/rust-tools.nvim
      :config (rv :lsp.langs.rust-tools)
      :ft     ["rust"]}
     {1       :Julian/lean.nvim
      :config (rv :lsp.langs.lean)
      :ft     ["lean"]}
     {1    :mlochbaum/BQN
      :rtp :editors/vim
      :ft  ["bqn"]}
     {1   :shirk/vim-gas
      :ft ["gas"]}
     {1   :aklt/plantuml-syntax
      :ft ["plantuml"]}
     {1   :McSinyx/vim-octave
      :ft ["octave"]}
     {1   :kmonad/kmonad-vim
      :ft ["kmonad"]}
     {1             :scalameta/nvim-metals
      :dependencies [:nvim-lua/plenary.nvim]
      :config       (rv :lsp.langs.metals)}
     {1       :eraserhd/parinfer-rust
      :config (rv :parinfer)
      :build    "cargo build --release"
      :cond   (= (vim.fn.executable :cargo) 1)}
     {1       :stevearc/dressing.nvim
      :config (rv :dressing)}
     {1       :mfussenegger/nvim-jdtls
      :config (rv :lsp.langs.jdtls)
      :ft     ["java"]}
     {1       :jakewvincent/texmagic.nvim
      :config (rv :lsp.langs.texmagic)
      :ft     ["tex"
               "latex"]}
     {1       :jbyuki/nabla.nvim
      :config (rv :nabla)
      :ft     ["tex"
               "latex"]}
     {1 :b0o/schemastore.nvim}
     {1       :j-hui/fidget.nvim
      :tag    :legacy
      :config (rv :fidget)
      :cond   (= lsp_progress :fidget)}
     ;; {1        :edluffy/hologram.nvim
     ;;  :config  (rv :hologram)
     ;;  :enabled false}
     {1 :nanotee/luv-vimdocs}
     {1 :milisims/nvim-luaref}
     {1       :mfussenegger/nvim-dap
      :config (rv :dap)}
     {1             :theHamsta/nvim-dap-virtual-text
      :dependencies [:mfussenegger/nvim-dap]
      :config       (rv :dap.virttext)}
     {1             :rcarriga/nvim-dap-ui
      :dependencies [:mfussenegger/nvim-dap]
      :config       (rv :dap.dapui)}
     {1       :L3MON4D3/LuaSnip
      :config (rv :luasnip)}
     {1 :rafamadriz/friendly-snippets}
     ;; {1             :folke/noice.nvim
     ;;  :dependencies [:MunifTanjim/nui.nvim
     ;;                 :rcarriga/nvim-notify]
     ;;  :config       (rv :noice)
     ;;  :disable      true}
     ;; {1        :sunjon/shade.nvim
     ;;  :enabled false
     ;;  :config  (rv :shade)}
     ;; {1       :folke/twilight.nvim
     ;;  :config (rv :twilight)}
     {1       :windwp/nvim-autopairs
      :dependencies [:nvim-treesitter/nvim-treesitter]
      :config (rv :autopairs)}
     {1             :m-demare/hlargs.nvim
      :config       (rv :hlargs)
      :dependencies [:nvim-treesitter/nvim-treesitter]}
     ;; {1        :phaazon/hop.nvim
     ;;  :config  (rv :hop)
     ;;  :enabled false}
     ;; {1       :ggandor/leap.nvim
     ;;  :config (rv :leap)}
     ;; {1             :ggandor/leap-ast.nvim
     ;;  :config       (rv :leap.ast)
     ;;  :dependencies [:ggandor/leap.nvim]}
     ;; {1        :kevinhwang91/nvim-hlslens
     ;;  :enabled false
     ;;  :config  (rv :hlslens)}
     {1       :kylechui/nvim-surround
      :config (rv :surround)}
     {1             :abecodes/tabout.nvim
      :dependencies [:nvim-treesitter/nvim-treesitter
                     :hrsh7th/nvim-cmp]
      :config       (rv :tabout)}
     {1             :Wansmer/treesj
      :config       (rv :treesj)
      :dependencies [:nvim-treesitter/nvim-treesitter]}
     {1        :ethanholz/nvim-lastplace
      :config  (rv :lastplace)}
     {1       :sQVe/sort.nvim
      :cmd    ["Sort"]
      :config (rv :sort)}
     ;; {1       :numToStr/Navigator.nvim
     ;;  :config (rv :navigator)}
     {1       :akinsho/toggleterm.nvim
      :config (rv :toggleterm)}
     {1             :nvim-neo-tree/neo-tree.nvim
      :dependencies [:nvim-lua/plenary.nvim
                     :kyazdani42/nvim-web-devicons
                     :MunifTanjim/nui.nvim]
      :branch       :v2.x
      :config       (rv :tree)}
     {1 :stevearc/oil.nvim
      :dependencies [:kyazdani42/nvim-web-devicons]
      :config (rv :oil)}
     ;; {1        :elihunter173/dirbuf.nvim
     ;;  :config  (rv :dirbuf)
     ;;  :enabled false}
     {1       :monaqa/dial.nvim
      :config (rv :dial)}
     {1       :junegunn/vim-easy-align
      :config (rv :easyalign)}
     {1             :TimUntersberger/neogit
      :keys         [:<leader>gs]
      :dependencies [:nvim-lua/plenary.nvim]
      :config       (rv :neogit)}
     ;; {1       :sindrets/diffview.nvim
     ;;  :after  [:neogit]
     ;;  :config (rv :diffview)}
     {1             :lewis6991/gitsigns.nvim
      :dependencies [:nvim-lua/plenary.nvim]
      :config       (rv :gitsigns)}
     ;; {1             :ThePrimeagen/git-worktree.nvim
     ;;  :dependencies [:nvim-treesitter/nvim-treesitter]
     ;;  :config       (rv :gitworktrees)}
     ;; {1             :pwntester/octo.nvim
     ;;  :dependencies [{1 :kyazdani42/nvim-web-devicons}]
     ;;  :config       (rv :octo)}
     {1             :ruifm/gitlinker.nvim
      :dependencies [:nvim-lua/plenary.nvim]
      :config       (rv :gitlinker)
      :keys         [:<leader>gb]}
     {1        :akinsho/git-conflict.nvim
      :config  (rv :conflict)}
     {1       :numToStr/Comment.nvim
      :config (rv :comments)}
     {1             :folke/todo-comments.nvim
      :dependencies [:nvim-lua/plenary.nvim
                     :anuvyklack/nvim-keymap-amend]
      :config       (rv :todocomments)}
     {1             :kevinhwang91/nvim-ufo
      :config       (rv :ufo)
      :dependencies [:kevinhwang91/promise-async]}
     {1 :jeffkreeftmeijer/vim-numbertoggle}
     {1       :jghauser/mkdir.nvim
      :config (rv :mkdir)}
     {1       :famiu/bufdelete.nvim
      :config (rv :bufdelete)}
     {1       :gbprod/stay-in-place.nvim
      :config (rv :stay)}
     {1       :sindrets/winshift.nvim
      :config (rv :winshift)}
     {1       :kevinhwang91/nvim-bqf
      :config (rv :betterquickfix)
      :ft :qf}
     {1       :yorickpeterse/nvim-pqf
      :config (rv :prettyquickfix)}
     {1       :lukas-reineke/indent-blankline.nvim
      :config (rv :indentline)}
     {1       :edluffy/specs.nvim
      :config (rv :beacon)}])

(local plugins
       (let [final-plugins {}]
         (forieach [normal-plugins treesitter-plugins telescope-plugins cmp-plugins]
               #(table.foreach $1 (fn [k v] (table.insert final-plugins v))))
         final-plugins))

(local opts
       {:concurrency 30
        :performance {:reset_packpath false}})

((. (require "lazy") :setup) plugins opts)

{: plugins}
