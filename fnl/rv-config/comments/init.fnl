(fn after []
  (let [dk (require :def-keymaps)
        ts-context-commentstring (require :ts_context_commentstring)
        opt {:enable_autocmd false}
        group (vim.api.nvim_create_augroup
                :reovim-commentstring-space
                {:clear true})
        get-option vim.filetype.get_option]
    (ts-context-commentstring.setup opt)
    (dk [:n :v :x :o]
        {:c "gc"}
        {:prefix :<leader>
         :remap true})
    (vim.api.nvim_create_autocmd
      [:FileType]
      {:desc "Force commentstring to include spaces"
       : group
       :callback (fn [event]
                   (let [cs (. vim.bo event.buf :commentstring)]
                     (tset (. vim.bo event.buf) :commentstring
                           (-> cs
                               (: :gsub "(%S)%%s" "%1 %%s")
                               (: :gsub "%%s(%S)" "%%s %1")))))})
    (set vim.filetype.get_option
         (fn [filetype option]
           (case option
             :commentstring
             (let [bufnr (vim.api.nvim_get_current_buf)
                   current-filetype (. vim.bo bufnr :filetype)]
               (if (not= filetype current-filetype)
                   (get-option filetype option)
                   (or (ts-context-commentstring.calculate_commentstring {:key :__default})
                       (. vim.bo bufnr :commentstring)
                       (get-option filetype option))))
             _ (get-option filetype option))))))

{:src "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
 :data {:dep_of [:nvim-treesitter]
        :event :DeferredUIEnter
        : after}}
