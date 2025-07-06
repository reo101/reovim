(fn after []
  (let [dk (require :def-keymaps)
        neorg (require :neorg)
        opt {:lazy_loading true
             :load {;;; Load all the default modules
                    :core.defaults {}
                    ;;; Manage directories
                    :core.dirman {:config
                                   {:workspaces
                                     {}}}
                    ;;; Configure keybinds
                    :core.keybinds {:config
                                     {:default_keybinds false}}
                    ;;; Enable the calendar module
                    :core.ui.calendar {}
                    ;;; Allows for use of icons
                    :core.concealer {:config
                                      {:folds true
                                       :init_open_folds :auto
                                       :markup_preset :dimmed
                                       :icon_preset :diamond
                                       :icons {:todo {:pending   {:icon ""}
                                                      :uncertain {:icon ""}
                                                      :urgent    {:icon ""}
                                                      :on_hold   {:icon "󰏤"}
                                                      :cancelled {:icon ""}}}}}
                    ; Enable exporing
                    :core.export {}
                    :core.export.markdown {}
                    ;;; Enable nvim-cmp completion
                    :core.completion {:config
                                       {:engine :nvim-cmp}}
                    ;;; Enable the telescope module
                    ;; :core.integrations.telescope {}
                    ;;; Enable the metagen module
                    :core.esupports.metagen {:config
                                              {:type :auto}}
                    ;;; Enable the presenter module
                    :core.presenter {:config
                                      {:zen_mode :truezen
                                       :slide_count {:enable true
                                                     :position :top
                                                     :count_format "[%d/%d]"}}}}}]
    (fn keymaps []
      (dk :n
          {:n {:group "Neorg"
               :e [#(vim.cmd
                      (->>
                        (vim.fn.expand "%:r")
                        (string.format
                          "Neorg export to-file %s.md")))
                   "Export to markdown"]
               :nn ["<Plug>(neorg.dirman.new-note)"                    "Create a new `.norg` file to take notes in"]
               :cm ["<Plug>(neorg.looking-glass.magnify-code-block)"   "Magnifies a code block to a separate buffer."]
               :id ["<Plug>(neorg.tempus.insert-date)"                 "Insert a link to a date at the given position"]
               :li ["<Plug>(neorg.pivot.list.invert)"                  "Invert all items in a list"]
               :lt ["<Plug>(neorg.pivot.list.toggle)"                  "Toggle a list from ordered <-> unordered"]
               :t {:group "Mark the [T]ask under the cursor as ..."
                   :a ["<Plug>(neorg.qol.todo-items.todo.task-ambiguous)" "Ambiguous"]
                   :c ["<Plug>(neorg.qol.todo-items.todo.task-cancelled)" "Cancelled"]
                   :d ["<Plug>(neorg.qol.todo-items.todo.task-done)"      "Done"]
                   :h ["<Plug>(neorg.qol.todo-items.todo.task-on-hold)"   "On-Hold"]
                   :i ["<Plug>(neorg.qol.todo-items.todo.task-important)" "Important"]
                   :p ["<Plug>(neorg.qol.todo-items.todo.task-pending)"   "Pending"]
                   :r ["<Plug>(neorg.qol.todo-items.todo.task-recurring)" "Recurring"]
                   :u ["<Plug>(neorg.qol.todo-items.todo.task-undone)"    "Undone"]}}}
          {:prefix :<leader>})
      (dk :i
          {:<C-d>  ["<Plug>(neorg.promo.demote)"                   "Demote an object recursively"]
           :<C-t>  ["<Plug>(neorg.promo.promote)"                  "Promote an object recursively"]
           :<M-CR> ["<Plug>(neorg.itero.next-iteration)"           "Create an iteration of e.g. a list item"]
           :<M-d>  ["<Plug>(neorg.tempus.insert-date.insert-mode)" "Insert a link to a date at the current cursor position"]})
      (dk :n
          {"<," ["<Plug>(neorg.promo.demote)"         "Demote an object non-recursively"]
           "<<" ["<Plug>(neorg.promo.demote.nested)"  "Demote an object recursively"]
           ">." ["<Plug>(neorg.promo.promote)"        "Promote an object non-recursively"]
           ">>" ["<Plug>(neorg.promo.promote.nested)" "Promote an object recursively"]
           :<M-Space> ["<Plug>(neorg.qol.todo-items.todo.task-cycle)" "Switch the task under the cursor between a select few states"]
           :<CR> ["<Plug>(neorg.esupports.hop.hop-link)"          "Hop to the destination of the link under the cursor"]
           :<M-CR> ["<Plug>(neorg.esupports.hop.hop-link.vsplit)" "Same as `<CR>`, except open the destination in a vertical split"]})
      (dk :v
          {"<" ["<Plug>(neorg.promo.demote.range)"  "Demote objects in range"]
           ">" ["<Plug>(neorg.promo.promote.range)" "Promote objects in range"]}))
    (let [group (vim.api.nvim_create_augroup
                  "reovim_neorg"
                  {:clear true})]
      (vim.api.nvim_create_autocmd
        :FileType
        {:pattern :norg
         : group
         :callback #(keymaps)}))
    (neorg.setup opt)))

[{:src "https://github.com/nvim-neorg/neorg-telescope"
  :data {:dep_of [:neorg]
         :event :DeferredUIEnter}}
 {:src "https://github.com/pocco81/true-zen.nvim"
  :data {:lazy true
         :dep_of [:neorg]}}
 {:src "https://github.com/nvim-neorg/neorg"
  :version :v9.1.1
  :data {:ft [:norg]
         : after}}]
