(let [pattern :*
      group (vim.api.nvim_create_augroup
              :auto_create_dir
              {:clear true})
      callback (fn [ctx]
                 (let [dir (vim.fn.fnamemodify ctx.file ":p:h")]
                   (vim.fn.mkdir dir :p)))]
  (vim.api.nvim_create_autocmd
    [:BufWritePre]
    {: pattern
     : group
     : callback}))
