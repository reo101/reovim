(fn config []
  (let [dk (require :def-keymaps)
        hunk (require :gitlinkerhunk)
        opt {}]
    (hunk.setup opt)))

{1 :julienvincent/hunk.nvim
 :dependencies [:nvim-tree/nvim-web-devicons
                :MunifTanjim/nui.nvim]
 :cmd [:DiffEditor]
 : config}
