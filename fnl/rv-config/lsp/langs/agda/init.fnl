(fn config []
  (let [dk (require :def-keymaps)
        opts {:use-global-binary true
              :max-size          30
              :max-width         40
              :split-location    :vertical
              :agda-prefix       ","
              :no-agda-input     1}]
    ;;; Set options
    (each [k v (pairs opts)]
      (tset vim.g
            (.. :cornelis_ (k:gsub "-" "_"))
            v))

    ;;; Set easy-align options
    (tset vim.g :easy_align_delimiters
          {:r {:pattern      "[≤≡≈∎]"
               :left_margin  2
               :right_margin 0}})

    ;;; `:CornelisLoad` on load/save
    ;; (vim.api.nvim_create_autocmd
    ;;   [:BufReadPre
    ;;    :BufWritePost]
    ;;   {:pattern [:*.agda
    ;;              :*.lagda*]
    ;;    :callback #(vim.cmd :CornelisLoad)})

    (local {: inverse-raw-symbols} (require :rv-config.lsp.langs.agda.symbols))

    ;;; Mappings
    (fn agda-mappings []
      (dk [:n]
          {:a {:name :Agda
               :l  [#(vim.cmd.CornelisLoad) :Load]
               :r  [#(vim.cmd.CornelisRefine) :Refine]
               :d  [#(vim.cmd.CornelisMakeCase) :MakeCase]
               "," [#(vim.cmd.CornelisTypeContext) :TypeContext]
               "." [#(vim.cmd.CornelisTypeContextInfer) :TypeContextInfer]
               :n  [#(vim.cmd.CornelisSolve) :Solve]
               :a  [#(vim.cmd.CornelisAuto) :Auto]
               :e  [#(let [old-reg     (vim.fn.getreg "a")
                           _           (vim.cmd "redir @a> | ascii | redir END")
                           ascii       (vim.fn.getreg "a")
                           _           (vim.fn.setreg "a" old-reg)
                           char        (ascii:gsub ".*<([^>]*)>.*" "%1")
                           char-recipe (?. inverse-raw-symbols char)]
                      (vim.print char-recipe))
                    "Explain symbol"]}}
          {:prefix :<leader>
           :buffer true})
      (dk [:n]
          {:gd  [#(vim.cmd.CornelisGoToDefinition) :Definition]
           :K   [#(vim.cmd.CornelisTypeInfer) "Type Infer"]
           "[/" [#(vim.cmd.CornelisPrevGoal) "Previous goal"]
           "]/" [#(vim.cmd.CornelisNextGoal) "Next goal"]}
          {:buffer true})
      (vim.cmd "TSBufDisable highlight"))

    (vim.api.nvim_create_autocmd
      [:BufRead
       :BufNewFile]
      {:pattern [:*.agda]
       :callback agda-mappings})

    (agda-mappings)

    ;;; cmp latex-like thing
    (let [cmp (require :cmp)
          source (require :rv-config.lsp.langs.agda.source)]
      (cmp.register_source
        :agda
        (source.new))
      (cmp.setup.filetype
        :agda
        {:sources
          (cmp.config.sources
            [{:name :agda}])}))))
      ;; (cmp.setup.cmdline
      ;;   ":"
      ;;   {:sources
      ;;      (cmp.config.sources
      ;;        [{:name :cmdline}
      ;;         {:name :agda}])}))))

{1 :isovector/cornelis
 :dependencies [:neovimhaskell/nvim-hs.vim
                :kana/vim-textobj-user
                :junegunn/vim-easy-align]
 :ft [:agda]
 : config}
