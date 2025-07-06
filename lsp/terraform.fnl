;; {:cmd [:terraform-lsp]
;;  :filetypes [:terraform
;;              :hcl]
;;  :root_dir (lsp-root-dir
;;              [:.terraform]
;;              true)}

{:cmd [:terraform-ls
       :serve]
 :filetypes [:terraform]
 :root_markers [:.terraform
                :.git]}
