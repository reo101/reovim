(lambda def-keymaps [mode keymaps ?opts]
  {:fnl/docstring
   "
   Recursively define keybinds using nested tables

   ```fennel
   (def-keymaps :n
     {:a {:group :abc
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
         :debug  ?debug?
         &       opts} opts
        prefix (or ?prefix "")
        debug? (or ?debug? false)
        {:hydra  hydra?
         :group  group?
         :hint   hint?
         :config config?
         :mode   mode?
         ;; :docs   docs?
         &       keymaps} keymaps
        ;; TODO: remove global `mode` parameter, bring closer to which-key v3 spec
        mode (or mode? mode)
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
                             (and (vim.islist rhs)
                                  (= (length rhs) 2)
                                  (is-valid-cmd  (. rhs 1))
                                  (is-valid-desc (. rhs 2)))
                             {:cmd   (. rhs 1)
                              :desc  (. rhs 2)
                              :final true}
                             ;; Empty (but documented) rhs
                             (and (vim.islist rhs)
                                  (= (length rhs) 1)
                                  (is-valid-desc (. rhs 1)))
                             {:cmd   nil
                              :desc  (. rhs 1)
                              :final true}
                             ;; Nested table, leave be
                             (not (vim.islist rhs))
                             rhs
                             ;; else
                             nil))
        canonicalized-keymaps (vim.tbl_map canonicalize-rhs keymaps)
        base-keymap-opts {:silent true
                          :remap false}
        keymap-opts (vim.tbl_extend "force"
                                    base-keymap-opts
                                    opts)
        notify (fn [title mess]
                 (vim.notify
                   mess
                   vim.log.levels.TRACE
                   {: title})
                 (vim.print (string.format "%s: %s" title mess)))]
    ;; Check for hydra
    (when (and hydra? (not has-hydra?))
      (vim.notify_once "Hydra not found, continuing normally")
      (lua "return nil"))
    ;; Adding keybinds (with hydra and/or natively)
    (var just-hydra? false)
    (case hydra?
      true (let [hydra-conf {:group  group?
                             :hint   hint?
                             :config config?
                             :mode   mode
                             :body   prefix
                             :heads  (icollect [lhs rhs (pairs canonicalized-keymaps)]
                                       (if rhs.final
                                           [lhs rhs.cmd {:desc rhs.desc}]))}]
             (when debug?
               (notify
                 "Setting (just) hydra keymap"
                 (vim.inspect hydra-conf)))
             (hydra hydra-conf)
             (set just-hydra? true))
      hydra-keymaps (let [hydra-conf {:name   group?
                                      :hint   hint?
                                      :config config?
                                      :mode   mode
                                      :body   prefix
                                      :heads (-> hydra-keymaps
                                                 pairs
                                                 vim.iter
                                                 (: :map #(values $1 (canonicalize-rhs $2)))
                                                 (: :filter #(. $2 :final))
                                                 (: :map (fn [lhs {: cmd : desc}]
                                                           [lhs cmd {: desc}]))
                                                 (: :totable))}]
                      (when debug?
                        (notify
                          "Setting hydra keymap"
                          (vim.inspect hydra-conf)))
                      (hydra hydra-conf)))
    (when (not just-hydra?)
      (when (and has-which-key? group?)
        (when debug?
          (notify
            "Setting which-key group name"
            (vim.inspect {: mode
                          1 prefix
                          :group group?})))
        (which-key.add {: mode
                        1 prefix
                        :group group?}))
      (each [lhs rhs (pairs canonicalized-keymaps)]
        (let [lhs (.. prefix lhs)]
          (if
            rhs.final
            (if rhs.cmd
                (do
                  (when debug?
                    (notify
                      "Setting keymap"
                      (vim.inspect {: mode
                                    : lhs
                                    : rhs
                                    :opts (vim.tbl_extend
                                            "force"
                                            keymap-opts
                                            {:desc rhs.desc})})))
                  (vim.keymap.set mode
                                  lhs
                                  rhs.cmd
                                  (vim.tbl_extend
                                    "force"
                                    keymap-opts
                                    {:desc rhs.desc})))
                ;; else
                (when (and has-which-key?
                           rhs.desc)
                  (when debug?
                    (notify
                      "Setting which-key desc"
                      (vim.inspect {: mode
                                    1 lhs
                                    :desc rhs.desc})))
                  (which-key.add {: mode
                                  1 lhs
                                  :desc rhs.desc})))
            ;; else
            (do
              (when (and has-which-key?
                         rhs.name)
                ;; Add name for group
                (when debug?
                  (notify
                    "Setting which-key group name"
                    (vim.inspect {: mode
                                  1 lhs
                                  :group rhs.group})))
                (which-key.add {: mode
                                1 lhs :group rhs.group}))
              (def-keymaps mode
                           rhs
                           (vim.tbl_extend
                             :force
                             opts
                             {:prefix lhs
                              :debug debug?})))))))))

def-keymaps
