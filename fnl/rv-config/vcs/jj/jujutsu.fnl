(fn after []
  (let [dk (require :def-keymaps)
        jj (require :jujutsu-nvim)
        opt {:diff_preset :diffview}]
    (jj.setup opt)))

{:src "https://github.com/yannvanhalewyn/jujutsu.nvim"
 :data {:cmd [:JJ]
        : after}}
