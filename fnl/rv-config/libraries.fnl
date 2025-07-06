;; Widely-shared library plugins — no setup, loaded eagerly
[{:src "https://github.com/vhyrro/luarocks.nvim"
  :priority 1000}
 {:src "https://github.com/nvim-lua/plenary.nvim"
  :data {:dep_of [:harpoon :telescope.nvim :rest.nvim]}}
 {:src "https://github.com/nvim-lua/popup.nvim"}
 {:src "https://github.com/MunifTanjim/nui.nvim"}
 {:src "https://github.com/nvim-mini/mini.icons"}
 {:src "https://github.com/anuvyklack/nvim-keymap-amend"}
 ;; Hydra - needed early for autocommands that set up traversing hydras
 {:src "https://github.com/nvimtools/hydra.nvim"
  :data {:version :v1.0.3}}]
