(fn after []
  (let [octo (require :octo)
        dk (require :def-keymaps)]
    (dk :n
        {})))

{:src "https://github.com/justinmk/guh.nvim"
 :data {: after
        :cmd [:Guh]
        :enabled (= (vim.fn.executable :gh) 1)}}
