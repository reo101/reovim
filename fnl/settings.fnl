;;; GLOBALS ;;;;

(tset _G :HOME_PATH   (vim.fn.expand  "$HOME"))
(tset _G :CONFIG_PATH (vim.fn.stdpath "config"))
(tset _G :DATA_PATH   (vim.fn.stdpath "data"))
(tset _G :CACHE_PATH  (vim.fn.stdpath "cache"))
(tset _G :TERMINAL    (vim.fn.expand  "$TERMINAL"))

;;; SETTINGS ;;

;;; Set leaders
(tset vim.g :mapleader      " ")

(tset vim.g :maplocalleader " ")

;;; Set terminal title to TERMINAL after exit
(tset vim.opt :titleold    _G.TERMINAL)

;;; Don't show incremental :s results in a split
(tset vim.opt :inccommand :nosplit)

;;; Lispy keywords
(doto vim.opt.iskeyword
  (: :append "-")
  (: :remove ":"))

;;; Keys, with which you can wrap around lines
(doto vim.opt.whichwrap
  (: :append "<")
  (: :append ">")
  (: :append "[")
  (: :append "]")
  (: :append "h")
  (: :append "l"))

;;; Whitespace visualization
(tset vim.opt :list true)
(tset vim.opt :listchars
      {;; :space  "␣"
       :nbsp  "␣"
       :trail  ""
       ;; :eol  "↴"
       :tab  "󰁍󰁔"})

;;; Old whitespace visualization
;; (vim.cmd "highlight ExtraWhitespace ctermbg=red guibg=red")
;; (vim.cmd "match ExtraWhitespace /\\s\\+$/")
;; (vim.cmd "autocmd Syntax * syn match ExtraWhitespace /\\s\\+$\\| \+\\ze\\t/")

;;; Don't create backup files
(tset vim.opt :backup false)

;;; Don't break in the middle of words
(tset vim.opt :breakat " \t;:,])}")

;;; Indent wrapped lines
(tset vim.opt :breakindent true)

;;; Options for breakindent
(tset vim.opt :breakindentopt ["shift:0"
                               "list:0"
                               "min:40"
                               "sbr"])

;;; String to show when wrapping a line
(tset vim.opt :showbreak "☇") ;; "↪" ">>"

;;; Allows neovim to access the system clipboard
(tset vim.opt :clipboard "unnamedplus")

;;; More space in the neovim command line for displaying messages
(tset vim.opt :cmdheight 1)

;;; Visual reminder for 80 char line limit
;; (tset vim.opt :colorcolumn "80")

;;; Conceal the current line only when in command mode
(tset vim.opt :concealcursor "c")

;;; Completely hidden conceals
(tset vim.opt :conceallevel 2)

;;; Highlight the current column
;; (tset vim.opt :cursorcolumn true)

;;; Highlight the current line
(tset vim.opt :cursorline true)

;;; Highlight currect line number
(tset vim.opt :cursorlineopt "number")

;;; Convert tabs to spaces
(tset vim.opt :expandtab true)

;;; The encoding written to a file
(tset vim.opt :fileencoding "utf-8")

;;; The font used in graphical neovim applications
(tset vim.opt :guifont "FiraCode Nerd Font:h17")

;;; Required to keep multiple buffers and open multiple buffers
(tset vim.opt :hidden true)

;;; Highlight all matches on previous search pattern
(tset vim.opt :hlsearch true)

;;; Ignore case in search patterns
(tset vim.opt :ignorecase true)

;;; Global statusline
(tset vim.opt :laststatus 3)

;;; Allow the mouse to be used in neovim
(tset vim.opt :mouse "a")

;;; Set numbered lines
(tset vim.opt :number true)

;;; Winblend for the autocompletion window
(tset vim.opt :pumblend 20)

;;; Pop up menu height
(tset vim.opt :pumheight 10)

;;; Set relatively numbered lines
(tset vim.opt :relativenumber true)

;;; Always keep the cursor 3 lines away from the edge
(tset vim.opt :scrolloff 3)

;;; The number of spaces inserted for each indentation
(tset vim.opt :shiftwidth 4)

;;; Configure shorter statusline indicators
(doto vim.opt.shortmess
  ;;; Hide "Pattern not found" when no completion is available
  (: :append "c")
  ;;; Ensure autocmd works for Filetype
  (: :remove "F"))

;;; we don't need to see things like -- INSERT -- anymore
(tset vim.opt :showmode false)

;;; Always show tabline
(tset vim.opt :showtabline 2)

;;; Always show the sign column, otherwise it would shift the text each time
(tset vim.opt :signcolumn "auto:3")

;;; Smart case
(tset vim.opt :smartcase true)

;;; Make indenting smarter again
;;; NOTE: messes with treesitter
(tset vim.opt :smartindent false)

;;; More tab is 4 spaces config
(tset vim.opt :softtabstop 4)

;;; Force all horizontal splits to go below current window
(tset vim.opt :splitbelow true)

;;; Keep the same screen lines in all windows after splitting
(tset vim.opt :splitkeep "screen")

;;; Force all vertical splits to go to the right of current window
(tset vim.opt :splitright true)

;;; Creates a swapfile
(tset vim.opt :swapfile false)

;;; Insert 4 spaces for a tab
(tset vim.opt :tabstop 4)

;;; Set term gui colors (most terminals support this)
(tset vim.opt :termguicolors true)

;;; Time to wait for a mapped sequence to complete (in milliseconds)
(tset vim.opt :timeoutlen 300)

;;; Set the title of window to the value of the titlestring
(tset vim.opt :title true)

;;; What the title of the window will be set to)
(tset vim.opt :titlestring "%<%F%=%l/%L) ; nvim")

;;; Set an undo directory
(tset vim.opt :undodir (.. _G.CACHE_PATH  "/undo"))

;;; Enable persistent undo
(tset vim.opt :undofile true)

;;; Faster completion
(tset vim.opt :updatetime 300)

;;; Winblend for floating windows
(tset vim.opt :winblend 20)

;;; Display lines as one long line
(tset vim.opt :wrap true)

;;; Display lines as one long line
(tset vim.opt :wrap true)

;;; If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
(tset vim.opt :writebackup false)

;; (tset vim.wo :fillchars "fold: ")
;; (tset vim.wo :foldexpr "nvim_treesitter#foldexpr()")
;; (tset vim.wo :foldmethod "expr")
;; (tset vim.wo :foldminlines 1)
;; (tset vim.wo :foldnestmax 3)
;; (tset vim.wo :foldtext [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]])

;;; Disable builtin plugins
(let [disabled_plugins
       ["2html_plugin"
        "getscript"
        "getscriptPlugin"
        "gzip"
        "logipat"
        "netrw"
        "netrwPlugin"
        "netrwSettings"
        "netrwFileHandlers"
        "matchit"
        "matchparen"
        "spec"
        "tar"
        "tarPlugin"
        "rrhelper"
        "spellfile_plugin"
        "vimball"
        "vimballPlugin"
        "zip"
        "zipPlugin"]]
  (each [_ plugin (ipairs disabled_plugins)]
    (tset vim.g (.. "loaded_" plugin) 1)))
