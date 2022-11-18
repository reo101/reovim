(lambda def-keymaps [mode keymaps ?keys]
  {:fnl/docstring
   "
   Recursively define keybinds using nested tables

   ```fennel
   (def-keymaps :n
     {:a {:name :abc
          :hydra true
          :b [#(print :ab) \"Print ab\"]
          :c #(print :ac)}}
     :<leader>)
   ```

   The above example defines two keybinds:
   <leader>ab - prints 'ab', (has custom description, for hydra and which-key)
   <leader>ac - prints 'ac'

   A group of keymaps can be 'hydrated' using `:hydra true` and its friends
   "
   :fnl/arglist [mode keymaps ?keys]}
  (let [keys (or ?keys "")
        (has-hydra? hydra)         (pcall require :hydra)
        (has-which-key? which-key) (pcall require :which-key)
        {:hydra     hydra?
         :name      name?
         :hint      hint?
         :config    config?
         :docs      docs?
         :which-key which-key?} keymaps
        keymaps (collect [lhs rhs (pairs keymaps)]
                  (if (not (vim.tbl_contains
                             [:hydra
                              :name
                              :hint
                              :config
                              :docs
                              :which-key
                              :final]
                             lhs))
                    (values lhs rhs)))
        convert-rhs (fn [rhs]
                      (if
                        ;; Undocumented rhs
                        (vim.tbl_contains
                          [:function
                           :string]
                          (type rhs))
                        {:cmd   rhs
                         :final true}
                        ;; Inconsequential/nested table, don't convert
                        (not (vim.tbl_islist rhs))
                        rhs
                        ;; Documented rhs
                        (vim.tbl_islist rhs)
                        {:cmd   (. rhs 1)
                         :desc  (. rhs 2)
                         :final true}))
        keymaps (vim.tbl_map convert-rhs keymaps)
        opts {:silent  true
              :noremap true}]
    ;; Check for hydra
    (when (not has-hydra?)
      (print "Hydra not found, continuing normally"))
    ;; Check for which-key
    (when (not has-which-key?)
      (print "Which-key not found, continuing normally"))
    ;; Assing keybinds (with hydra or natively)
    (if
      (and has-hydra?
           hydra?)
      (hydra {:name   name?
              :hint   hint?
              :config config?
              :mode   mode
              :body   keys
              :heads  (icollect [lhs rhs (pairs keymaps)]
                        (do
                          (when (and has-which-key?
                                     which-key?)
                            (which-key.register {(.. keys lhs)
                                                 [(. rhs :name)]}))
                          [lhs rhs.cmd {:desc rhs.desc}]))})
      ;; else
      (each [lhs rhs (pairs keymaps)]
        (if
          (. rhs :final)
          (do
            (when (and has-which-key?
                       which-key?)
              (which-key.register {(.. keys lhs)
                                   [rhs.desc]}))
            (vim.keymap.set mode (.. keys lhs) rhs.cmd (vim.tbl_extend :force
                                                                       opts
                                                                       {:desc rhs.desc})))
          ;; else
          (do
            (when (and has-which-key?
                       which-key?)
              (which-key.register {(.. keys lhs)
                                   [(. rhs :name)]}))
            (def-keymaps mode rhs (.. keys lhs))))))))

def-keymaps
