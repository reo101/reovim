[;; Library plugins - auto-load on require
 {:src "https://github.com/vhyrro/luarocks.nvim"
  :data {:event :DeferredUIEnter}}
 {:src "https://github.com/nvim-lua/plenary.nvim"
  :data {:event :DeferredUIEnter
         :on_require [:plenary]}}
 {:src "https://github.com/nvim-lua/popup.nvim"
  :data {:event :DeferredUIEnter
         :on_require [:popup]}}
 {:src "https://github.com/MunifTanjim/nui.nvim"
  :data {:event :DeferredUIEnter
         :on_require [:nui]}}
 {:src "https://github.com/nvim-mini/mini.icons"
  :data {:event :DeferredUIEnter
         :on_require [:mini.icons]}}
 {:src "https://github.com/anuvyklack/nvim-keymap-amend"
  :data {:event :DeferredUIEnter
         :on_require [:keymap_amend]}}
 {:src "https://github.com/nvimtools/hydra.nvim"
  :data {:event :DeferredUIEnter
         :version :v1.0.3
         :on_require [:hydra]}}
 ;; Filetype plugins
 {:src "https://github.com/mlochbaum/BQN"
  :data {:ft  ["bqn"]
         :config #(vim.opt.rtp:append (.. $.dir :/editors/vim))}}
 {:src "https://github.com/shirk/vim-gas"
  :data {:ft ["gas"]}}
 {:src "https://github.com/aklt/plantuml-syntax"
  :data {:ft ["plantuml"]}}
 {:src "https://github.com/calincru/flex-bison-syntax"
  :data {:ft ["lex"]}}
 {:src "https://github.com/McSinyx/vim-octave"
  :data {:ft ["octave"]}}
 {:src "https://github.com/kmonad/kmonad-vim"
  :data {:ft ["kmonad"]}}
 {:src "https://github.com/vim-scripts/bnf.vim"
  :data {:ft ["bnf"]}}
 {:src "https://github.com/vim-scripts/applescript.vim"
  :data {:ft ["applescript"]}}
 ;; {:src :LhKipp/nvim-nu
 ;;  :data {:build ":TSInstall nu"
 ;;         :config #((. (require "nu")
 ;;                      :setup)
 ;;                   {:use_lsp_features false})}
 {:src "https://github.com/reo101/tree-sitter-jj_template"
  :data {:event :DeferredUIEnter}}
 {:src "https://github.com/reo101/tree-sitter-uci"
  :data {:event :DeferredUIEnter}}
 {:src "https://github.com/nushell/tree-sitter-nu"
  :data {:event :DeferredUIEnter}}
 {:src "https://github.com/kwshi/tree-sitter-hy"
  :data {:event :DeferredUIEnter}}
         ;; :ft [:nu]}}
 {:src "https://github.com/avm99963/vim-jjdescription"}
 ;; Lua docs
 {:src "https://github.com/nanotee/luv-vimdocs"}
 {:src "https://github.com/milisims/nvim-luaref"}
 ;; Vimscript
 {:src "https://github.com/jeffkreeftmeijer/vim-numbertoggle"}]
