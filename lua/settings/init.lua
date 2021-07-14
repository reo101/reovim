---  HELPERS  ---

local fn = vim.fn
local cmd = vim.cmd
local opt = vim.opt

--- GLOBALS ---

CONFIG_PATH = fn.stdpath "config"
DATA_PATH = fn.stdpath "data"
CACHE_PATH = fn.stdpath "cache"
TERMINAL = fn.expand "$TERMINAL"

---  VIM ONLY COMMANDS  ---

cmd "filetype plugin on"
cmd('let &titleold="' .. TERMINAL .. '"')
cmd "set inccommand=split"
cmd "set iskeyword+=-"
cmd "set whichwrap+=<,>,[,],h,l"
-- cmd "au ColorScheme * hi Normal ctermbg=none guibg=none"
-- cmd "au ColorScheme * hi SignColumn ctermbg=none guibg=none"

---  SETTINGS  ---

vim.g.mapleader = " "           -- maps the leader to space
opt.backup = false              -- creates a backup file
opt.clipboard = "unnamedplus"   -- allows neovim to access the system clipboard
opt.cmdheight = 1               -- more space in the neovim command line for displaying messages
-- opt.colorcolumn = "80"       -- visual reminder for 80 char line limit
opt.completeopt = { "menuone", "noselect" }
opt.concealcursor = "nc"        -- only conceal when in normal or command mode
opt.conceallevel = 2            -- completely hidden conceals
opt.fileencoding = "utf-8"      -- the encoding written to a file
opt.guifont = "monospace:h17"   -- the font used in graphical neovim applications
opt.hidden = true               -- required to keep multiple buffers and open multiple buffers
opt.hlsearch = true             -- highlight all matches on previous search pattern
opt.ignorecase = true           -- ignore case in search patterns
opt.mouse = "a"                 -- allow the mouse to be used in neovim
opt.pumheight = 10              -- pop up menu height
opt.scrolloff = 3               -- always keep the cursor 3 lines away from the edge
opt.showmode = false            -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 2             -- always show tabs
opt.smartcase = true            -- smart case
opt.smartindent = true          -- make indenting smarter again
opt.splitbelow = true           -- force all horizontal splits to go below current window
opt.splitright = true           -- force all vertical splits to go to the right of current window
opt.swapfile = false            -- creates a swapfile
opt.termguicolors = true        -- set term gui colors (most terminals support this)
opt.timeoutlen = 300            -- time to wait for a mapped sequence to complete (in milliseconds)
opt.title = true                -- set the title of window to the value of the titlestring
opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
opt.undodir = CACHE_PATH .. "/undo" -- set an undo directory
opt.undofile = true             -- enable persisten undo
opt.updatetime = 300            -- faster completion
opt.writebackup = false         -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
opt.expandtab = true            -- convert tabs to spaces
opt.tabstop = 4                 -- insert 4 spaces for a tab
opt.softtabstop = 4             -- more tab is 4 spaces config
opt.shiftwidth = 4              -- the number of spaces inserted for each indentation
opt.shortmess:append "c"        -- Hide "Pattern not found" when no completion is available
-- opt.cursorline = true           -- highlight the current line
-- opt.cursorcolumn = true         -- highlight the current column
opt.number = true               -- set numbered lines
opt.relativenumber = true       -- set relatively numbered lines
opt.signcolumn = "auto:1-5"     -- always show the sign column, otherwise it would shift the text each time
opt.wrap = true                 -- display lines as one long line
