(fn config []
  (let [lastplace (require :nvim-lastplace)
        opt {:lastplace_ignore_buftype
               [:quickfix
                :nofile
                :help]
             :lastplace_ignore_filetype
               [:gitcommit
                :gitrebase
                :svn
                :hgcommit]
             :lastplace_open_folds true}]
    (lastplace.setup opt)))

{: config}
