(lambda def-keymaps [mode keymaps ?opts]
  {:fnl/docstring
   "
   Recursively define keybinds using nested tables

   ```fennel
   (def-keymaps :n
     {:a {:name :abc
          :hydra true
          :which-key false
          :b [#(print :ab) \"Print ab\"]
          :c #(print :ac)
          :d [\"External\"]}}
     {:prefix :<leader>})
   ```

   The above example defines two keybinds:
   <leader>ab - prints \"ab\", has custom description, for hydra and which-key
   <leader>ac - prints \"ac\"
   <leader>ad - (undefined what it does), has custom description, for hydra and which-key

   A group of keymaps can be 'hydrated' using `:hydra true` and its friends
   "
   :fnl/arglist [mode keymaps ?opts]}
  (let [(has-hydra?     hydra)     (pcall require :hydra)
        (has-which-key? which-key) (pcall require :which-key)
        opts (or ?opts {})
        {:prefix ?prefix
         &       opts} opts
        prefix (or ?prefix "")
        {:hydra  hydra?
         :name   name?
         :hint   hint?
         :config config?
         ;; :docs   docs?
         &       keymaps} keymaps
        is-valid-cmd (fn [cmd]
                       (vim.tbl_contains
                         [:string :function]
                         (type cmd)))
        is-valid-desc (fn [desc]
                        (vim.tbl_contains
                          [:string]
                          (type desc)))
        canonicalize-rhs (fn [rhs]
                           (if
                             ;; Undocumented rhs
                             (is-valid-cmd rhs)
                             {:cmd   rhs
                              :final true}
                             ;; Documented rhs
                             (and (vim.tbl_islist rhs)
                                  (= (length rhs) 2)
                                  (is-valid-cmd  (. rhs 1))
                                  (is-valid-desc (. rhs 2)))
                             {:cmd   (. rhs 1)
                              :desc  (. rhs 2)
                              :final true}
                             ;; Empty (but documented) rhs
                             (and (vim.tbl_islist rhs)
                                  (= (length rhs) 1)
                                  (is-valid-desc (. rhs 1)))
                             {:cmd   nil
                              :desc  (. rhs 1)
                              :final true}
                             ;; Nested table, leave be
                             (not (vim.tbl_islist rhs))
                             rhs
                             ;; else
                             nil))
        keymaps (vim.tbl_map canonicalize-rhs keymaps)
        base-keymap-opts {:silent  true
                          :noremap true}
        keymap-opts (vim.tbl_extend "force"
                                    base-keymap-opts
                                    opts)]
    ;; Check for hydra
    (when (and hydra? (not has-hydra?))
      (vim.notify_once "Hydra not found, continuing normally"))
    ;; Adding keybinds (with hydra or natively)
    (if
      hydra?
      (hydra {:name   name?
              :hint   hint?
              :config config?
              :mode   mode
              :body   prefix
              :heads  (icollect [lhs rhs (pairs keymaps)]
                        (if rhs.final
                            [lhs rhs.cmd {:desc rhs.desc}]))})
      ;; else
      (each [lhs rhs (pairs keymaps)]
        (let [lhs (.. prefix lhs)]
          (if
            rhs.final
            (if rhs.cmd
                (vim.keymap.set mode
                                lhs
                                rhs.cmd
                                (vim.tbl_extend
                                  "force"
                                  keymap-opts
                                  {:desc rhs.desc}))
                ;; else
                (when (and has-which-key?
                           rhs.desc)
                  (which-key.register {lhs {:desc rhs.desc}}
                                      {: mode})))
            ;; else
            (do
              (when (and has-which-key?
                         rhs.name)
                ;; Add name for group
                (which-key.register {lhs {:name rhs.name}}
                                    {: mode}))
              (def-keymaps mode
                           rhs
                           (vim.tbl_extend
                             :force
                             opts
                             {:prefix lhs})))))))))

def-keymaps
