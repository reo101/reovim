(fn config []
  (let [dk  (require :def-keymaps)
        ufo (require :ufo)
        ft-map {:fennel [:treesitter
                         :indent]
                ""      ""}
        handler (fn [virt-text lnum end-lnum width truncate]
                  (let [new-virt-text {}]
                    (var suffix (: "  %d " :format (- end-lnum lnum)))
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
                                       (: " " :rep (- (- target-width
                                                         cur-width)
                                                      chunk-width)))))
                            (lua :break)))
                      (set cur-width (+ cur-width chunk-width)))
                    (table.insert new-virt-text {1 suffix 2 :MoreMsg})
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
    (set vim.o.foldcolumn     :0)
    (set vim.o.foldlevel      99)
    (set vim.o.foldlevelstart 99)
    (set vim.o.foldenable     true)
    (dk :n
        {:zR [ufo.openAllFolds  "Open all folds"]
         :zM [ufo.closeAllFolds "Close all folds"]
         :K  (fn []
               (let [winid (ufo.peekFoldedLinesUnderCursor)]
                 (when (not winid)
                   (vim.lsp.buf.hover))))})
    (ufo.setup opt)))

{1 :kevinhwang91/nvim-ufo
 :dependencies [:kevinhwang91/promise-async]
 : config}
