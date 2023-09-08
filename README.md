<div align="center">
    <p>
        <a href="https://github.com/neovim/neovim">
            <img src="https://img.shields.io/badge/requires-neovim%200.9%2B-green?style=flat-square&logo=neovim" alt="Neovim Requirement"/>
        </a>
        <a href="https://github.com/reo101/reovim/pulse">
            <img alt="Last Commit" src="https://img.shields.io/github/last-commit/reo101/reovim"/>
        </a>
        <a href="https://github.com/reo101/reovim/blob/main/LICENSE">
            <img src="https://img.shields.io/github/license/reo101/reovim?style=flat-square&logo=GNU&label=License" alt="License"/>
        </a>
    </p>
    <p>
        <a href="https://fennel-lang.org/">
            <img src="https://img.shields.io/badge/Made%20with%20Fennel-darkgreen.svg?style=for-the-badge&logo=fennel" alt="Lua"/>
        </a>
        <a href="https://www.lua.org/">
            <img src="https://img.shields.io/badge/Made%20with%20Lua-blue.svg?style=for-the-badge&logo=lua" alt="Lua"/>
        </a>
    </p>
</div>

```
     ___           ___           ___                                    ___
    /  /\         /  /\         /  /\          ___        ___          /__/\
   /  /::\       /  /:/_       /  /::\        /__/\      /  /\        |  |::\
  /  /:/\:\     /  /:/ /\     /  /:/\:\       \  \:\    /  /:/        |  |:|:\
 /  /:/~/:/    /  /:/ /:/_   /  /:/  \:\       \  \:\  /__/::\      __|__|:|\:\
/__/:/ /:/___ /__/:/ /:/ /\ /__/:/ \__\:\  ___  \__\:\ \__\/\:\__  /__/::::| \:\
\  \:\/:::::/ \  \:\/:/ /:/ \  \:\ /  /:/ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/
 \  \::/~~~~   \  \::/ /:/   \  \:\  /:/  \  \:\|  |:|     \__\::/  \  \:\
  \  \:\        \  \:\/:/     \  \:\/:/    \  \:\__|:|     /__/:/    \  \:\
   \  \:\        \  \::/       \  \::/      \__\::::/      \__\/      \  \:\
    \__\/         \__\/         \__\/           ~~~~                   \__\/
```

---

# Showcase

![Start Screen](./media/nightfox_start_screen.png)

# Dependencies

- `git`
- A `C/C++` compiler for the treesitter parsers (`gcc/g++`, `clang/clang++`, `zig`)
- (Optional) `cargo` for `parinfer-rust`
- (Optional) `fzf` and `rg` for `Telescope`
- (Optional) any of the required Language Servers for the languages mentioned [here](#languages)

# Installation

- Firstly get a `nvim` binary:

  - [Installing NeoVim](https://github.com/neovim/neovim/wiki/Installing-Neovim) (Official Wiki)

- Back up any old configs
  - Assuming `$XDG_CONFIG_HOME` is `$HOME/.config` and `$XDG_DATA_HOME` is `$HOME/.local/share`

```bash
mv "~/.config/nvim" "~/.config/nvim_backup"
mv "~/.local/share/nvim" "~/.local/share/nvim_backup"
git clone https://www.github.com/reo101/reovim "~/.config/nvim"
```

- Run `nvim`. On the first run, NeoVim will bootstrap the `HotPot` Fennel Loader and `Packer` package manager

- From inside NeoVim run `:PackerInstall` once to install all the packages

> NOTE: (hopefully) soon with Nix

# Screenshots

## Start Screen
![Start Screen](./media/nightfox_start_screen.png)

## Telescope Files
![Telescope Files](./media/nightfox_telescope_files.png)

## Rust Project
![Rust Loading](./media/nightfox_rust_loading.png)
![Rust Project](./media/nightfox_rust_working.png)

# Directory overview

- [`init.lua`](./init.lua) - Entry point for Neovim
- [`lua/`](./lua/) - Lua config files
    - [`bootstrap-hotpot.lua`](./lua/bootstrap-hotpot.lua) - HotPot bootstrapper
    - [`globals.lua`](./lua/globals.lua) - Global Lua helper functions and values
    - [`utils.lua`](./lua/utils.lua) - Utility functions (not used)
    - `rv-*package*/init.lua` - Package configurations
- [`fnl/`](./fnl/) - Fennel config files
    - [`init.fnl`](./fnl/initialize.fnl) - Entry point for Fennel config
    - [`macros.fnl`](./fnl/init-macros.fnl) - Fennel macros used throughout the Fennel config
    - [`packages.fnl`](./fnl/packages.fnl) - Packages' definition location
    - `rv-*package*/init.fnl` - Package configurations
- [`luasnippets/`](./luasnippets/) - LuaSnip snippets
- [`queries/`](./after/queries/) - Custom Treesitter queries

---

## Notable packages

### Package Manager

- [Packer](https://github.com/wbthomason/packer.nvim)

### Fennel Loader

- [HotPot](https://github.com/rktjmp/hotpot.nvim)

### Telescope

- **[Telescope](https://www.github.com/nvim-telescope/telescope.nvim)**
- [Packer extension](https://www.github.com/nvim-telescope/telescope-packer.nvim)
- [FZF picker](https://www.github.com/nvim-telescope/telescope-fzf-native.nvim)
- [Github extension](https://www.github.com/nvim-telescope/telescope-github.nvim)
- [Media Files extension](https://www.github.com/nvim-telescope/telescope-media-files.nvim)
- [Symbols extension](https://www.github.com/nvim-telescope/telescope-symbols.nvim)
- [File Browser extension](https://www.github.com/nvim-telescope/telescope-file-browser.nvim)

### Neorg

- **[Neorg](https://www.github.com/vhyrro/neorg)**
- [Neorg Telescope extension](https://www.github.com/vhyrro/neorg-telescope)

### Markdown utils

- [Markdown Previewer](https://www.github.com/iamcco/markdown-preview.nvim)
- [Markdown link follower](https://www.github.com/jghauser/follow-md-links.nvim)

### Which-key

- [Which-key](https://www.github.com/folke/which-key.nvim)

### Alpha

- [Alpha](https://github.com/goolord/alpha-nvim)

### Statusline

- [Lualine](https://www.github.com/hoob3rt/lualine.nvim)

### Tabline

- [Bufferline](https://github.com/akinsho/bufferline.nvim)

### Discord RPC

- [Presence](https://www.github.com/andweeb/presence.nvim)

### Notifications

- [Notify](https://www.github.com/rcarriga/nvim-notify)

### LSP

- **[LSP Config](https://www.github.com/neovim/nvim-lspconfig)**
- [Trouble](https://www.github.com/folke/trouble.nvim)
- [LSP Signature](https://www.github.com/ray-x/lsp_signature.nvim)
- [LSP Kind](https://www.github.com/onsails/lspkind-nvim)
- [Aerial](https://www.github.com/stevearc/aerial.nvim)
- [Dressing](https://www.github.com/stevearc/dressing.nvim)

#### Languages
- [Ansible](./fnl/rv-config/lsp/langs/ansible.fnl)
- [Bash](./fnl/rv-config/lsp/langs/bash.fnl)
- [C, CPP](./fnl/rv-config/lsp/langs/clangd.fnl)
- [CMake](./fnl/rv-config/lsp/langs/cmake.fnl)
- [Dockerfile](./fnl/rv-config/lsp/langs/docker.fnl)
- [Erlang](./fnl/rv-config/lsp/langs/erlang.fnl)
- [Go](./fnl/rv-config/lsp/langs/go.fnl)
- [Haskell](./fnl/rv-config/lsp/langs/haskell.fnl)
- [JSON](./fnl/rv-config/lsp/langs/json.fnl)
- [Javascript, Typescript](./fnl/rv-config/lsp/langs/tsserver.fnl)
- [LaTeX](./fnl/rv-config/lsp/langs/latex.fnl)
- [Lua](./fnl/rv-config/lsp/langs/lua.fnl)
- [Nim](./fnl/rv-config/lsp/langs/nim.fnl)
- [Python](./fnl/rv-config/lsp/langs/python.fnl)
- [SQL](./fnl/rv-config/lsp/langs/sqls.fnl)
- [Scheme, Racket](./fnl/rv-config/lsp/langs/racket.fnl)
- [Zig](./fnl/rv-config/lsp/langs/zig.fnl)

#### Additional Language Server plugins

- [Null LS](https://www.github.com/jose-elias-alvarez/null-ls.nvim)
- [Pair LS](https://www.github.com/stevearc/pair-ls.nvim)
- [Rust Tools](https://www.github.com/simrat39/rust-tools.nvim)
  - [Crates](https://www.github.com/saecki/crates.nvim)
- [Metals](https://www.github.com/scalameta/nvim-metals)
- [JDTLS](./fnl/rv-config/lsp/langs/jdtls.fnl)

### Fennel

- [Conjure](https://github.com/Olical/conjure)

### DAP

- **[DAP](https://www.github.com/mfussenegger/nvim-dap)**
- [DAP Virtual Text](https://www.github.com/theHamsta/nvim-dap-virtual-text)
- [DAP UI](https://www.github.com/rcarriga/nvim-dap-ui)

### Completion

- **[CMP](https://www.github.com/hrsh7th/nvim-cmp)**
- [CMP LSP](https://www.github.com/hrsh7th/cmp-nvim-lsp)
- [CMP LuaSnip](https://www.github.com/saadparwaiz1/cmp_luasnip)
- [CMP Buffer](https://www.github.com/hrsh7th/cmp-buffer)
- [CMP NVim Lua](https://www.github.com/hrsh7th/cmp-nvim-lua)
- [CMP Path](https://www.github.com/hrsh7th/cmp-path)
- [CMP Calc](https://www.github.com/hrsh7th/cmp-calc)
- [CMP Spell](https://www.github.com/f3fora/cmp-spell)
- [CMP Tmux](https://www.github.com/andersevenrud/compe-tmux)
- [CMP Cmdline](https://www.github.com/hrsh7th/cmp-cmdline)
- [Autopairs](https://www.github.com/windwp/nvim-autopairs)

#### Snippets

- **[LuaSnip](https://www.github.com/L3MON4D3/LuaSnip)**
- [Friendly Snippets](https://www.github.com/rafamadriz/friendly-snippets)

### Focus

- [Zen Mode]()
- [Twilight](https://www.github.com/folke/twilight.nvim)
- [Shade](https://www.github.com/sunjon/shade.nvim)

### Treesitter

- **[Treesitter](https://www.github.com/nvim-treesitter/nvim-treesitter)**
- [Treesitter Textobjects](https://www.github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [Treesitter Playground](https://www.github.com/nvim-treesitter/playground)
- [Treesitter Rainbow](https://www.github.com/p00f/nvim-ts-rainbow)
- [Treesitter Context](https://www.github.com/romgrk/nvim-treesitter-context)
- [Treesitter Commentstring](https://www.github.com/JoosepAlviste/nvim-ts-context-commentstring)

### General Utility

- [Hop](https://www.github.com/phaazon/hop.nvim)
- [Hlslens](https://www.github.com/kevinhwang91/nvim-hlslens)
- [Tabout](https://www.github.com/abecodes/tabout.nvim)
- [Lastplace](https://www.github.com/ethanholz/nvim-lastplace)
- [Sort](https://www.github.com/sQVe/sort.nvim)
- [Navigator](https://www.github.com/numToStr/Navigator.nvim)
- [Dirbuf](https://www.github.com/elihunter173/dirbuf.nvim)
- [Dial](https://www.github.com/monaqa/dial.nvim)
- [EasyAlign](https://www.github.com/junegunn/vim-easy-align)
- [PrettyFold](https://www.github.com/anuvyklack/pretty-fold.nvim)
- [RegexPlainer](https://www.github.com/bennypowers/nvim-regexplainer)
- [NumberToggle](https://www.github.com/jeffkreeftmeijer/vim-numbertoggle)
- [Mkdir](https://www.github.com/jghauser/mkdir.nvim)
- [BufDelete](https://www.github.com/famiu/bufdelete.nvim)
- [BufResize](https://www.github.com/kwkarlwang/bufresize.nvim)
- [Stabilize](https://www.github.com/luukvbaal/stabilize.nvim)
- [WinShift](https://www.github.com/sindrets/winshift.nvim)
- [BetterQFList](https://www.github.com/kevinhwang91/nvim-bqf)
- [PrettyQFList](https://gitlab.com/yorickpeterse/nvim-pqf.git)
- [IndentLine](https://www.github.com/lukas-reineke/indent-blankline.nvim)

### Terminal Manager

- [ToggleTerm](https://www.github.com/akinsho/toggleterm.nvim)

### File Explorer

- [Neotree](https://www.github.com/nvim-neo-tree/neo-tree.nvim)

### Git

- **[NeoGit](https://www.github.com/TimUntersberger/neogit)**
- [DiffView](https://www.github.com/sindrets/diffview.nvim)
- [GitSigns](https://www.github.com/lewis6991/gitsigns.nvim)
- [GitWorktree](https://www.github.com/ThePrimeagen/git-worktree.nvim)
- [Octo](https://www.github.com/pwntester/octo.nvim)
- [GitLinker](https://www.github.com/ruifm/gitlinker.nvim)

### Commenting

- [Comment](https://www.github.com/numToStr/Comment.nvim)
- [TODO Comments](https://www.github.com/folke/todo-comments.nvim)
