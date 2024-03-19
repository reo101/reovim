[;; Filetype plugins
 {1    :mlochbaum/BQN
  :ft  ["bqn"]
  :config #(vim.opt.rtp:append (.. $.dir :/editors/vim))}
 {1   :shirk/vim-gas
  :ft ["gas"]}
 {1   :aklt/plantuml-syntax
  :ft ["plantuml"]}
 {1   :calincru/flex-bison-syntax
  :ft ["lex"]}
 {1   :McSinyx/vim-octave
  :ft ["octave"]}
 {1   :kmonad/kmonad-vim
  :ft ["kmonad"]}
 {1   :vim-scripts/bnf.vim
  :ft ["bnf"]}
 {1 :vim-scripts/applescript.vim
  :ft ["applescript"]}
 ;; {1 :LhKipp/nvim-nu
 ;;  :build ":TSInstall nu"
 ;;  :config #((. (require "nu")
 ;;               :setup)
 ;;            {:use_lsp_features false})}
 {1 :nushell/tree-sitter-nu
  :ft [:nu]}
 ;; Keymaps
 {1 :nvimtools/hydra.nvim}
 ;; Lua docs
 {1 :nanotee/luv-vimdocs}
 {1 :milisims/nvim-luaref}
 ;; Vimscript
 {1 :jeffkreeftmeijer/vim-numbertoggle}]
