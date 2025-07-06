(fn after []
  (let [ultimate-autopair (require :ultimate-autopair)
        dk (require :def-keymaps)
        opt {:profile :default
             :map true
             :cmap true
             :pair_map true
             :pair_cmap true
             :multiline true
             :bs {:enable true
                  :map :<BS>
                  :cmap :<BS>
                  :overjumps false
                  :space :balance
                  :indent_ignore false
                  :singe_delete false
                  :conf {}
                  :multi false}
             :cr {:enable true
                  :map :<CR>
                  :autoclose false
                  :conf {:cond #(not ($.in_lisp))}
                  :multi false}
             :space
               {:enable false
                :map " "
                :cmap " "
                :check_box_ft [:markdown
                               :vimwiki
                               :neorg]
                :conf {}
                :multi false}
             :space2
               {:enable true
                :match :\k
                :conf {}
                :multi false}
             :fastwarp {:enable false}
             :close {:enable false}
             :tabout {:enable false}
             :extensions
               {:cmdtype {:skip ["/" "?" "@" "-"]
                          :p 100}
                :filetype {:nft [:TelescopePrompt]
                           :tree true
                           :p 90}
                :escape {:filter true
                         :p 80}
                :utf8 {:p 70}
                :tsnode {:separate [:comment
                                    :string
                                    :raw_string]
                         :p 60}
                :cond {:filter true
                       :p 40}
                :alpha {:filter false
                        :all false
                        :p 30}
                :suround {:p 20}
                :fly {:other_char [" "]
                      :nofilter false
                      :undomapconf {}
                      :undomap nil
                      :undocmap nil
                      :only_jump_end_pair false}}
             :internal_pairs
               [{1 "("
                 2 ")"
                 :fly true
                 :dosurround true
                 :newline true
                 :space true}
                {1 "["
                 2 "]"
                 :fly true
                 :dosurround true
                 :newline true
                 :space true}
                {1 "{"
                 2 "}"
                 :fly true
                 :dosurround true
                 :newline true
                 :space true}
                {1 "\""
                 2 "\""
                 :surround true
                 :multiline false
                 :alpha [:txt]}
                {1 "'"
                 2 "'"
                 :surround true
                 :cond #(and (not ($.in_lisp))
                             (not ($.in_string))
                             ;; NOTE: for `rust` lifetimes
                             (not ($.in_node [:type_parameters])))
                 ;; :alpha true
                 :nft [:tex
                       :latex]
                 :multiline false}
                {1 "\"\"\""
                 2 "\"\"\""
                 :fly true
                 :dosurround true
                 :newline true
                 :space true
                 :ft [:scala]}
                {1 "```"
                 2 "```"
                 :newline true
                 :ft [:markdown]}
                {1 :<!--
                 2 :-->
                 :newline true
                 :ft [:html
                      :markdown]}
                {1 "''"
                 2 "''"
                 :dosurround true
                 :newline true
                 :ft [:nix]
                 :conf #(not ($.in_string))}
                {1 :<!--
                 2 :-->
                 :newline true
                 :ft [:html
                      :markdown]}]
             :config_internal_pairs []}]
    ;; (tset (require :ultimate-autopair.core)
    ;;       :modes
    ;;       [:i :c :n]]

    (ultimate-autopair.setup opt)

    ;; (ultimate-autopair.init
    ;;   [(ultimate-autopair.extend_default
    ;;      opt)
    ;;    {:profile
    ;;      (. (require :ultimate-autopair.experimental.matchpair)
    ;;         :init)}]

    (dk :n
        {}
        {:prefix :<leader>})))

{:src "https://github.com/altermo/ultimate-autopair.nvim"
 :version :v0.6
 :data {:event  [:InsertEnter
                 :CmdlineEnter]
        : after}}
