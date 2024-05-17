(fn config []
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
                                     {:default_keybinds true
                                      :neorg_leader :<leader>n
                                      :hook (fn [keybinds]
                                              ;; TODO: implement
                                              ;; <https://github.com/nvim-neorg/neorg/wiki/User-Keybinds>
                                              (dk [:n]
                                                  {:n {:name "Neorg"
                                                       :e [#(vim.cmd
                                                              (.. "Neorg export to-file "
                                                                  (vim.fn.expand "%:r")
                                                                  ".md"))
                                                           "Export to markdown"]}}
                                                  {:prefix :<leader>}))}}
                    ;;; Allows for use of icons
                    :core.concealer {:config
                                      {:folds true
                                       :init_open_folds :auto
                                       :markup_preset :dimmed}}
                                       ;; :icon_preset :diamond}}
                                       ;; :icons {:marker {:icon "󰁘 "}
                                       ;;         :todo {:enable true
                                       ;;                :pending   {:icon ""}
                                       ;;                :uncertain {:icon ""}
                                       ;;                :urgent    {:icon ""}
                                       ;;                :on_hold   {:icon "󰏤"}
                                       ;;                :cancelled {:icon ""}}}}
                    ;;; Enable exporing
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
    (neorg.setup opt)))

{1 :vhyrro/neorg
 :dependencies [:vhyrro/luarocks.nvim
                {1 :nvim-neorg/neorg-telescope
                 :event :VeryLazy
                 :dependencies [:nvim-telescope/telescope.nvim]}]
 :tag :v8.2.1
 ; :ft [:norg]
 ; :cmd [:NeorgStart]
 : config}
