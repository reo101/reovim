(fn config []
  (local dk (require :def-keymaps))
  (local opt {:load {;; Load all the default modules
                     :core.defaults {}
                     ;; Manage directories
                     :core.dirman {:config
                                   {:workspaces
                                     {:Notes      "~/Notes"
                                      :IPProjects "~/Projects/FMI/AssistCPP/Projects"
                                      :GTD        "~/GTD"}}}
                     ;; Configure keybinds
                     :core.keybinds {:config
                                     {:default_keybinds true
                                      :neorg_leader :<leader>n
                                      :hook (fn [keybinds]
                                              ;; TODO: implement
                                              (dk [:n]
                                                  {:n {:name "Neorg"}}
                                                  {:prefix :<leader>})}}
                     ;; Allows for use of icons
                     :core.concealer {:config
                                      {:markup_preset :dimmed
                                       :icon_preset :diamond
                                       :icons {:marker {:icon " "}
                                               :todo {:enable true
                                                      :pending   {:icon ""}
                                                      :uncertain {:icon ""}
                                                      :urgent    {:icon ""}
                                                      :on_hold   {:icon ""}
                                                      :cancelled {:icon ""}}}}}
                     ;; Enable nvim-cmp completion
                     :core.completion {:config
                                       {:engine :nvim-cmp}}
                     ;; Enable the telescope module
                     :core.integrations.telescope {}
                     ;; Enable the metagen module
                     :core.esupports.metagen {:config
                                              {:type :auto}}
                     ;; Enable the presenter module
                     :core.presenter {:config
                                      {:zen_mode :truezen
                                       :slide_count {:enable true
                                                     :position :top
                                                     :count_format "[%d/%d]"}}}}})
  ((. (require :neorg) :setup) opt))

{: config}
