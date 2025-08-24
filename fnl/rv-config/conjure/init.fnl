(fn after []
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
                 _ {(k1:gsub "-" "_") v1}))))))
  (fn set-conjure-settings [settings]
    (-> settings
        (flatten-table
           #(.. $1 :# $2))
        vim.iter
        (: :each
           #(tset vim.g $1 $2))))

  ;; Settings
  (set-conjure-settings
    {:conjure
      {:mapping
        {:prefix                    :<leader>u
         :eval-current-form         :ee
         :eval-root-form            :er
         :eval-word                 :ew
         :eval-comment-current-form :ece
         :eval-comment-root-form    :ecr
         :eval-comment-word         :ecw
         :eval-replace-form         :e!
         :eval-marked-form          :em
         :eval-file                 :ef
         :eval-buf                  :eb
         :eval-visual               :E
         :eval-motion               :E
         :log-split                 :ls
         :log-vsplit                :lv
         :log-tab                   :lt
         :log-buf                   :lb
         :log-toggle                :lg
         :log-reset-soft            :lr
         :log-reset-hard            :lR
         :log-jump-to-latest        :ll
         :log-close-visible         :lq
         :def-word                  :gd
         :doc-word                  :K}
       :extract
        {:tree-sitter
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
          {:u {:group "Conjure"
               :e {:group "Eval"
                   :e ["Current Form"]
                   :r ["Root Form"]
                   :w ["Word"]
                   :c {:group "Comment"
                       :e ["Current Form"]
                       :r ["Root Form"]
                       :w ["Word"]}
                   :! ["Replace Form"]
                   :m ["Marked Form"]
                   :f ["File"]
                   :b ["Buffer"]}
               :l {:group "Log"
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
          {:u {:group :Conjure
               :E ["Eval Visual"]}}]
        ; motion-mappings
        ;   {:u {:group :Conjure
        ;        :E ["Eval Motion"]}}]
    (dk :n
        mappings
        {:prefix :<leader>})
    (dk :v
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
                   (vim.defer_fn
                     #(vim.lsp.buf_detach_client
                        bufnr
                        client-id)
                     10))})

    ;; Disable diagnostics
    ; (vim.api.nvim_create_autocmd
    ;   :BufNewFile
    ;   {:pattern :conjure-log-*
    ;    : group
    ;    :callback (fn [{:buf bufnr}]
    ;                (vim.diagnostic.disable bufnr))})

    ;; Enable Baleia colourization
    (vim.api.nvim_create_autocmd
      :BufWinEnter
      {:pattern :conjure-log-*
       : group
       :callback (fn [{:buf bufnr}]
                   (let [baleia (-> (require :baleia)
                                    (: :setup))]
                     (baleia.automatically bufnr)))})

    ;; Remove `Sponsored by` message
    (vim.api.nvim_create_autocmd
      :BufWinEnter
      {:pattern :conjure-log-*
       : group
       :callback (fn [{:buf bufnr}]
                   ;; NOTE: `conjure` hardcodes its `comment-prefix`
                   ;;       this leads to mismatches (with lisps), so
                   ;;       we also hardcode `;` as a valid prefix
                   (let [;; commentstring (. vim.bo bufnr :commentstring)
                         ;; message (string.format commentstring "Sponsored by @.*")
                         ;; message (string.format "\\(;\\|%s\\)" message)
                         ;; message (message:gsub "/" "\\/")
                         message "Sponsored by @.*"
                         command (string.format "silent g/%s/d _" message)]
                     (vim.schedule
                       #(vim.cmd command))))}))

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

[#_{:src "https://github.com/PaterJason/cmp-conjure"
    :data {:config
            #(let [cmp (require :cmp)
                   config (cmp.get_config)]
               (table.insert
                 config.sources
                 {:group :buffer
                  :option {:sources
                            [{:name :conjure}]}})
               (cmp.setup config))}}
 {:src "https://github.com/m00qek/baleia.nvim"
  :version :v1.4.0
  :data {:config true}}
 {:src "https://github.com/Olical/conjure"
  :data {:dependencies [#_:PaterJason/cmp-conjure
                        :m00qek/baleia.nvim]
         :ft [:clojure
              :fennel
              :racket
              :rust
              :lisp
              :hy]
         : after}}]
