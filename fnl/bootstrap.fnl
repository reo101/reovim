(macro ensure [user repo ?additional-cmd]
  `(let [install-path# (string.format ,(string.format
                                         "%%s/site/pack/packer/start/%s"
                                         repo)
                                      (vim.fn.stdpath :data))]
     (when (> (vim.fn.empty (vim.fn.glob install-path#)) 0)
       (print (string.format ,(string.format
                                "Could not find %s, cloning new copy to %%s"
                                repo)
                             install-path#))
       (vim.fn.system [:git
                       :clone
                       ,(string.format "https://www.github.com/%s/%s"
                                        user
                                        repo)
                       install-path#])
       (vim.cmd ,(string.format "packadd %s" repo))
       ,(when ?additional-cmd
          `(,?additional-cmd install-path#)))))

(ensure :wbthomason :packer.nvim
  (fn []
    (vim.cmd "packadd vimball")))
