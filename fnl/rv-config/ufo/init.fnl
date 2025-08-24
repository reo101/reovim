(fn before []
  (set vim.opt.foldcolumn    :auto)
  (set vim.opt.foldlevel      99)
  (set vim.opt.foldlevelstart 99)
  (set vim.opt.foldenable     true))

(fn after []
  (let [ufo (require :ufo)
        dk  (require :def-keymaps)
        ft-map {}
               #_
               {:fennel [:treesitter
                         :indent]
                ""      ""}
        handler (fn [virt-text lnum end-lnum width truncate]
                  (let [new-virt-text {}]
                    (var suffix (-> " 󰁂 %d "
                                    (: :format (- end-lnum lnum))))
                    (local suf-width (vim.fn.strdisplaywidth suffix))
                    (local target-width (- width suf-width))
                    (var cur-width 0)
                    (each [_ chunk (ipairs virt-text)]
                      (var chunk-text (. chunk 1))
                      (var chunk-width (vim.fn.strdisplaywidth chunk-text))
                      (if (> target-width (+ cur-width chunk-width))
                          (table.insert new-virt-text chunk)
                          (do
                            (set chunk-text (truncate chunk-text
                                                      (- target-width
                                                         cur-width)))
                            (local hl-group (. chunk 2))
                            (table.insert new-virt-text [chunk-text hl-group])
                            (set chunk-width (vim.fn.strdisplaywidth chunk-text))
                            ;; str width returned from truncate()
                            ;; may less than 2nd argument, need padding
                            (when (< (+ cur-width
                                        chunk-width)
                                     target-width)
                              (set suffix
                                   (.. suffix
                                       (string.rep " " (- target-width
                                                          cur-width
                                                          chunk-width)))))
                            (lua :break)))
                      (set cur-width (+ cur-width chunk-width)))
                    (table.insert new-virt-text [suffix :MoreMsg])
                    new-virt-text))
        opt {:open_fold_hl_timeout 0
             :preview {:mappings {:scrollU :<C-u>
                                  :scrollD :<C-d>}
                       :win_config {:winblend 0
                                    :border [""
                                             "─"
                                             ""
                                             ""
                                             ""
                                             "─"
                                             ""
                                             ""]
                                    :winhighlight "Normal:Folded"}}
             :provider_selector (fn [bufnr filetype buftype]
                                  (or (. ft-map filetype)
                                      [:treesitter
                                       :indent]))
             :fold_virt_text_handler handler}]
    (ufo.setup opt)
    (dk :n
        {:zR [ufo.openAllFolds "Open all folds"]
         :zM [ufo.closeAllFolds "Close all folds"]
         :zr [ufo.openFoldsExceptKinds "Close all folds"]
         :K  [#(let [winid (ufo.peekFoldedLinesUnderCursor)]
                 (when (not winid)
                   (vim.lsp.buf.hover)))
              "Peek folded lines"]})))

{:src "https://github.com/kevinhwang91/nvim-ufo"
 :version :v1.4.0
 :data {:dependencies [:kevinhwang91/promise-async]
        :event :DeferredUIEnter
        : before
        : after
        :enabled false}}
