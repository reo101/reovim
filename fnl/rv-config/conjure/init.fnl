(fn config []
  (fn flatten-table [tbl merge-keys]
    (-> tbl
        vim.iter
        (: :fold
           {}
           (fn [t k1 v1]
             (vim.tbl_extend
               :error
               t
               (case (type v1)
                 :table
                   (-> v1
                       (flatten-table merge-keys)
                       vim.iter
                       (: :map
                          (fn [k2 v2]
                            (values
                              (merge-keys k1 k2)
                              v2)))
                       (: :fold
                          {}
                          (fn [t k v]
                            (tset t k v)
                            t)))
                 _ {k1 v1}))))))
  (fn set-conjure-settings [settings]
    (-> (flatten-table
           settings
           #(.. $1 :# $2))
        vim.iter
        (: :each
           #(tset vim.g $1 $2))))

  ;; Keybinds
  (set-conjure-settings
    {:conjure
      {:mappings
        {:prefix :<leader>u}
       :mapping
        {:log_split                 :ul
         :log_vsplit                :ulv
         :log_tab                   :ul
         :log_buf                   :ulb
         :log_toggle                :ul
         :log_reset_soft            :ulr
         :log_reset_hard            :ul
         :log_jump_to_latest        :ull
         :log_close_visible         :ul
         :eval_current_form         :uee
         :eval_comment_current_form :uec
         :eval_root_form            :uer
         :eval_comment_root_form    :uec
         :eval_word                 :uew
         :eval_comment_word         :uec
         :eval_replace_form         :ue!
         :eval_marked_form          :ue
         :eval_file                 :uef
         :eval_buf                  :ue
         :eval_visual               :uE
         :eval_motion               :u
         :def_word                  :ugd
         :doc_word                  :uK}}})

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
  (set-conjure-settings
    {:conjure
      {:client
        {:clojure
          {:nrepl
            {:eval
              {:auto_require false}
             :connection
              {:auto_repl
                {:enabled false}}}}}}})

  (let [conjure-main (require :conjure.main)
        conjure-mapping (require :conjure.mapping)]
    (conjure-main.main)
    (conjure-mapping.on-filetype)))

{1 :Olical/conjure
 :ft [:clojure
      :fennel]
 : config}
