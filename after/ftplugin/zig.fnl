(tset vim.opt_local :errorformat
  ["%f:%l:%c: %t%*[^:]: %m"
   "%f:%l:%c: %m"
   "%-G%*[ ]^%#"
   "%-G%*[ ]~%#"
   "%-G%*[ ]|%.%#"
   "%-Greferenced by:"])
