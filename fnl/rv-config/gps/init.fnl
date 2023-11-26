(fn config []
  (let [gps (require :nvim-gps)
        dk (require :def-keymaps)
        opt {;; Setting it to true will disable all icons
             :disable_icons false
             :icons {;; Classes and class-like objects
                     :class-name " "
                     ;; Functions
                     :function-name " "
                     ;; Methods (functions inside class-like objects)
                     :method-name " "
                     ;; Containers (example: lua tables)
                     :container-name "⛶ "
                     ;; Tags (example: html tags)
                     :tag-name "炙"}
             ;; Add custom configuration per language or
             ;; Disable the plugin for a language
             ;; Any language not disabled here is enabled by default
             :languages {;; Some languages have custom icons
                         :json
                           {:icons
                              {:array-name   " "
                               :boolean-name "ﰰﰴ "
                               :null-name    "[] "
                               :number-name  "# "
                               :object-name  " "
                               :string-name  " "}}
                         :toml
                           {:icons
                              {:array-name        " "
                               :boolean-name      "ﰰﰴ "
                               :date-name         " "
                               :date-time-name    " "
                               :float-name        " "
                               :inline-table-name " "
                               :integer-name      "# "
                               :string-name       " "
                               :table-name        " "
                               :time-name         " "}}
                         :verilog
                           {:icons
                              {:module-name " "}}
                         :yaml
                           {:icons
                              {:boolean-name  "ﰰﰴ "
                               :float-name    " "
                               :integer-name  "# "
                               :mapping-name  " "
                               :null-name     "[] "
                               :sequence-name " "
                               :string-name   " "}}
                         :yang
                           {:icons
                              {:action-name    " "
                               :augment-path   " "
                               :container-name " "
                               :grouping-name  " "
                               :identity-name  " "
                               :leaf-list-name " "
                               :leaf-name      " "
                               :list-name      "﬘ "
                               :module-name    " "
                               :typedef-name   " "}}}
                         ;; Disable for particular languages
                         ;; :bash false ;; disables nvim-gps for bash
                         ;; :go false ;; disables nvim-gps for golang
                         ;; Override default setting for particular languages
                         ;; :ruby
                         ;;   {;; Overrides default separator with '|'
                         ;;    :separator "|"
                         ;;    :icons
                         ;;      {;; to ensure empty values, set an empty string
                         ;;       :function-name ""
                         ;;       :tag-name ""
                         ;;       :class-name "::"
                         ;;       :method-name "#"}}
             :separator "  "
             ;; limit for amount of context shown
             ;; 0 means no limit
             :depth 0
             ;; indicator used when context hits depth limit
             :depth_limit_indicator ".."}]
    (gps.setup opt)

    (dk [:n]
        {}
        {:prefix :<leader>})))

{: config}
