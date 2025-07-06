(vim.api.nvim_create_autocmd
  :FileType
  {:pattern "d"
   :callback #(tset vim.opt_local :errorformat "%f(%l\\,%c):\\ %*[^:]:\\ %m")})
