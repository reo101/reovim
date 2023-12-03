(fn config []
    ;; Keybinds
    (tset vim.g "conjure#mappings#prefix"                   :<leader>u)
    (tset vim.g "conjure#mapping#log_split"                       :uls)
    (tset vim.g "conjure#mapping#log_vsplit"                      :ulv)
    (tset vim.g "conjure#mapping#log_tab"                         :ult)
    (tset vim.g "conjure#mapping#log_buf"                         :ulb)
    (tset vim.g "conjure#mapping#log_toggle"                      :ulg)
    (tset vim.g "conjure#mapping#log_reset_soft"                  :ulr)
    (tset vim.g "conjure#mapping#log_reset_hard"                  :ulR)
    (tset vim.g "conjure#mapping#log_jump_to_latest"              :ull)
    (tset vim.g "conjure#mapping#log_close_visible"               :ulq)
    (tset vim.g "conjure#mapping#eval_current_form"               :uee)
    (tset vim.g "conjure#mapping#eval_comment_current_form"      :uece)
    (tset vim.g "conjure#mapping#eval_root_form"                  :uer)
    (tset vim.g "conjure#mapping#eval_comment_root_form"         :uecr)
    (tset vim.g "conjure#mapping#eval_word"                       :uew)
    (tset vim.g "conjure#mapping#eval_comment_word"              :uecw)
    (tset vim.g "conjure#mapping#eval_replace_form"               :ue!)
    (tset vim.g "conjure#mapping#eval_marked_form"                :uem)
    (tset vim.g "conjure#mapping#eval_file"                       :uef)
    (tset vim.g "conjure#mapping#eval_buf"                        :ueb)
    (tset vim.g "conjure#mapping#eval_visual"                      :uE)
    (tset vim.g "conjure#mapping#eval_motion"                      :uE)
    (tset vim.g "conjure#mapping#def_word"                        :ugd)
    (tset vim.g "conjure#mapping#doc_word"                         :uK)

    ;; Which-key Keybinds
    (local dk (require :def-keymaps))
    (let [mappings
            {:u {:name "Conjure"
                 :gd ["Def Word"]
                 :K ["Doc Word"]
                 :l {:name "Log"
                     :q ["Close Visible"]
                     :t ["Tab"]
                     :v ["VSplit"]
                     :s ["Split"]
                     :l ["Jump To Latest"]
                     :r ["Reset Soft"]
                     :R ["Reset Hard"]
                     :g ["Toggle"]
                     :b ["Buffer"]}
                 :e {:name "Eval"
                     :c {:name "Comment"
                         :w ["Word"]
                         :r ["Root Form"]
                         :e ["Current Form"]}
                     :f ["File"]
                     :m ["Marked Form"]
                     :! ["Replace Form"]
                     :w ["Word"]
                     :r ["Root Form"]
                     :e ["Current Form"]
                     :b ["Buffer"]}}}
          visual-mappings
            {:u {:name :Conjure
                 :E ["Eval Visual"]}}
          motion-mappings
            {:u {:name :Conjure
                 :E ["Eval Motion"]}}]
      (dk [:n]
          mappings
          {:prefix :<leader>})
      (dk [:v]
          visual-mappings
          {:prefix :<leader>})
      (dk [:x :o]
          motion-mappings
          {:prefix :<leader>}))

    ;; Remove `Sponsored by` message
    (let [group (vim.api.nvim_create_augroup
                  :ConjureRemoveSponsor
                  {:clear true})]
      (vim.api.nvim_create_autocmd
        :BufWinEnter
        {:pattern :conjure-log-*
         : group
         :command "silent g/; Sponsored by @.*/d"}))

    ;; Clojure
    (tset vim.g "conjure#client#clojure#nrepl#eval#auto_require"            false)
    (tset vim.g "conjure#client#clojure#nrepl#connection#auto_repl#enabled" false)

    (let [conjure-main (require :conjure.main)
          conjure-mapping (require :conjure.mapping)]
      (conjure-main.main)
      (conjure-mapping.on-filetype)))

{: config}
