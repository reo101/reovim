(doto vim.opt_local.isfname
  (: :append "{")
  (: :append "}"))

;; (tset vim.opt
;;       :includeexpr
;;       ;; "substitute(v:fname, '\\$\\{\\(\\w\\)\\}', '$\\1', 'g')"
;;       "lua =string.gsub(vim.v.fname, '%$(%a+)', '%${%1}')"))
