(fn config []
  (let [dk (require :def-keymaps)
        jj-diffconflicts (require :jj-diffconflicts)]
    nil))

{1 :rafikdraoui/jj-diffconflicts
 :dependencies [:nvim-tree/nvim-web-devicons
                :MunifTanjim/nui.nvim]
 :cmd [:JJDiffConflicts]
 : config}
