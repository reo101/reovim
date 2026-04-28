(vim.filetype.add
  {:extension {:agda :agda
               :lagda :agda}
   :pattern {".*%.lagda%..*" :agda
             ".*%.lagda%.md" "markdown.agda"}})
