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

  ;; Settings
  (set-conjure-settings
    {:conjure
      {:mapping
        {:prefix                    :<leader>u
         :eval_current_form         :ee
         :eval_root_form            :er
         :eval_word                 :ew
         :eval_comment_current_form :ece
         :eval_comment_root_form    :ecr
         :eval_comment_word         :ecw
         :eval_replace_form         :e!
         :eval_marked_form          :em
         :eval_file                 :ef
         :eval_buf                  :eb
         :eval_visual               :E
         :eval_motion               :E
         :log_split                 :ls
         :log_vsplit                :lv
         :log_tab                   :lt
         :log_buf                   :lb
         :log_toggle                :lg
         :log_reset_soft            :lr
         :log_reset_hard            :lR
         :log_jump_to_latest        :ll
         :log_close_visible         :lq
         :def_word                  :gd
         :doc_word                  :K}
       :extract
        {:tree_sitter
          {:enabled true}}
       :log
        {:hud
          {:enabled false}
         :wrap true
         :strip-ansi-escape-sequences-line-limit 0}
       :highlight
        {:enabled true
         :group :IncSearch
         :timeout 200}}})

  (local dk (require :def-keymaps))
  (let [mappings
          {:u {:name "Conjure"
               :e {:name "Eval"
                   :e ["Current Form"]
                   :r ["Root Form"]
                   :w ["Word"]
                   :c {:name "Comment"
                       :e ["Current Form"]
                       :r ["Root Form"]
                       :w ["Word"]}
                   :! ["Replace Form"]
                   :m ["Marked Form"]
                   :f ["File"]
                   :b ["Buffer"]}
               :l {:name "Log"
                   :s ["Split"]
                   :v ["VSplit"]
                   :t ["Tab"]
                   :b ["Buffer"]
                   :g ["Toggle"]
                   :r ["Reset Soft"]
                   :R ["Reset Hard"]
                   :l ["Jump To Latest"]
                   :q ["Close Visible"]}
               :gd ["Def Word"]
               :K ["Doc Word"]}}
        visual-mappings
          {:u {:name :Conjure
               :E ["Eval Visual"]}}]
        ; motion-mappings
        ;   {:u {:name :Conjure
        ;        :E ["Eval Motion"]}}]
    (dk [:n]
        mappings
        {:prefix :<leader>})
    (dk [:v]
        visual-mappings
        {:prefix :<leader>}))
    ; (dk [:x :o]
    ;     motion-mappings
    ;     {:prefix :<leader>}))

  ;; Log buffer autocommands
  (let [group (vim.api.nvim_create_augroup
                :ConjureLogBuffer
                {:clear true})]
    ;; Detach LSPs
    (vim.api.nvim_create_autocmd
      :LspAttach
      {:pattern :conjure-log-*
       : group
       :callback (fn [{:buf bufnr :data {:client_id client-id}}]
                   (vim.lsp.buf_detach_client bufnr client-id))})

    ;; Enable Baleia colourization
    (vim.api.nvim_create_autocmd
      :BufReadPost
      {:pattern :conjure-log-*
       : group
       :callback (fn [{:buf bufnr}]
                   (let [baleia (require :baleia)]
                     (baleia.automatically bufnr)))})

    ;; Remove `Sponsored by` message
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

  ;; Use neovim's fennel
  (tset package.loaded :conjure.aniseed.deps.fennel
        package.loaded.fennel)

  (let [conjure-main (require :conjure.main)
        conjure-mapping (require :conjure.mapping)]
    (conjure-main.main)
    (conjure-mapping.on-filetype)))

{1 :Olical/conjure
 :dependencies [{1 :PaterJason/cmp-conjure
                 :config (fn []
                           (local cmp (require :cmp))
                           (local config (cmp.get_config))
                           (table.insert
                             config.sources
                             {:name :buffer
                              :option {:sources
                                        [{:name :conjure}]}})
                           (cmp.setup config))}
                {1 :m00qek/baleia.nvim
                 :tag :1.4.0
                 :config true}]
 :ft [:clojure
      :fennel
      :racket
      :rust]
 : config}
