(fn after []
  (let [dk (require :def-keymaps)
        hunk (require :hunk)
        opt {}]
    (hunk.setup opt)))

{:src "https://github.com/julienvincent/hunk.nvim"
 :data {:dependencies [:nvim-tree/nvim-web-devicons
                       :MunifTanjim/nui.nvim]
        :cmd [:DiffEditor]
        : after}}
