(fn config []
  (let [git-conflict (require :git-conflict)
        dk (require :def-keymaps)
        opt {;; Disable buffer local mapping created by this plugin
             :default_mappings false
             ;; Disable commands created by this plugin
             :default_commands true
             ;; Disable the diagnostics in a buffer whilst it is conflicted
             :disable_diagnostics true
             ;; They must have background color, otherwise the default color will be used
             :highlights {:incoming :DiffAdd
                          :current  :DiffText}}]
    (dk [:n]
        {:g {:name "Git"
             :c {:name "Choose"
                 :o [#(git-conflict.choose :ours)   "Ours"]
                 :t [#(git-conflict.choose :theirs) "Theirs"]
                 :b [#(git-conflict.choose :base)   "Base"]
                 :B [#(git-conflict.choose :both)   "Both"]
                 :n [#(git-conflict.choose :none)   "None"]}}}
        {:prefix :<leader>})
    (dk [:n]
        {"[x" [#(git-conflict.find_prev :ours) "Previous conflict"]
         "]x" [#(git-conflict.find_next :ours) "Next conflict"]})
    (git-conflict.setup opt)))

{1 :akinsho/git-conflict.nvim
 : config}
