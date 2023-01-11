;; (macro ensure [user repo install-path ?additional-cmd]
;;   `(let [install-path# ,(string.format
;;                           "%s/%s"
;;                           (vim.fn.stdpath :data)
;;                           install-path)]
;;      (when (> (vim.fn.empty (vim.fn.glob install-path#)) 0)
;;        (print (string.format ,(string.format
;;                                 "Could not find %s, cloning new copy to %%s"
;;                                 repo)
;;                              install-path#))
;;        (vim.fn.system [:gita
;;                        :clone
;;                        :--filter=blob:none
;;                        ,(string.format "https://www.github.com/%s/%s"
;;                                         user
;;                                         repo)
;;                        :--branch=stable
;;                        install-path#])
;;        ,(when ?additional-cmd `(,?additional-cmd install-path#)))))
;;
;; (ensure :folke :lazy.nvim "lazy"
;;   #(vim.opt.rtp:prepend $1))
