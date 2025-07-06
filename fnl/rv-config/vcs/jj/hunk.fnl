(fn after []
  (let [dk (require :def-keymaps)
        hunk (require :hunk)
        opt {}]
    (hunk.setup opt)))

{:src "https://github.com/julienvincent/hunk.nvim"
 :data {:cmd [:DiffEditor]
        : after}}
