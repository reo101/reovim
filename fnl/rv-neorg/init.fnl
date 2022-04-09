(fn config []
  (local opt {:load {;; Load all the default modules
                     :core.defaults {}
                     ;; Manage directories
                     :core.norg.dirman {:config
                                        {:workspaces
                                         {:Notes      "~/Notes"
                                          :IPProjects "~/Projects/FMI/AssistCPP/Projects"
                                          :GTD        "~/GTD"}}}
                     ;; Manage GTD workflow
                     :core.gtd.base {:config
                                     {:workspace :GTD
                                      ;; Optional: all excluded files from the workspace are not part of the gtd workflow
                                      :exclude {}
                                      :projects {:show_completed_projects false
                                                 :show_projects_without_tasks false}
                                      :custom_tag_completion true}}
                     ;; Configure keybinds
                     :core.keybinds {:config
                                      {:default_keybinds true
                                       :neorg_leader :<leader>o
                                       :hook (fn [keybinds])}}
                     ;; Allows for use of icons
                     :core.norg.concealer {:config
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
                     :core.norg.completion {:config
                                            {:engine :nvim-cmp}}
                     ;; Enable the telescope module
                     :core.integrations.telescope {}
                     ;; Enable the metagen module
                     :core.norg.esupports.metagen {:config
                                                   {:type :auto}}
                     ;; Enable the presenter module
                     :core.presenter {:config
                                      {:zen_mode :truezen
                                       :slide_count {:enable true
                                                     :position :top
                                                     :count_format "[%d/%d]"}}}}})
  ((. (require :neorg) :setup) opt))

{: config}
