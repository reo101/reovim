(fn config []
    ;; Keybinds
    (tset vim.g "conjure#mappings#prefix"                   :<leader>j)
    (tset vim.g "conjure#mapping#log_split"                       :jls)
    (tset vim.g "conjure#mapping#log_vsplit"                      :jlv)
    (tset vim.g "conjure#mapping#log_tab"                         :jlt)
    (tset vim.g "conjure#mapping#log_buf"                         :jlb)
    (tset vim.g "conjure#mapping#log_toggle"                      :jlg)
    (tset vim.g "conjure#mapping#log_reset_soft"                  :jlr)
    (tset vim.g "conjure#mapping#log_reset_hard"                  :jlR)
    (tset vim.g "conjure#mapping#log_jump_to_latest"              :jll)
    (tset vim.g "conjure#mapping#log_close_visible"               :jlq)
    (tset vim.g "conjure#mapping#eval_current_form"               :jee)
    (tset vim.g "conjure#mapping#eval_comment_current_form"      :jece)
    (tset vim.g "conjure#mapping#eval_root_form"                  :jer)
    (tset vim.g "conjure#mapping#eval_comment_root_form"         :jecr)
    (tset vim.g "conjure#mapping#eval_word"                       :jew)
    (tset vim.g "conjure#mapping#eval_comment_word"              :jecw)
    (tset vim.g "conjure#mapping#eval_replace_form"               :je!)
    (tset vim.g "conjure#mapping#eval_marked_form"                :jem)
    (tset vim.g "conjure#mapping#eval_file"                       :jef)
    (tset vim.g "conjure#mapping#eval_buf"                        :jeb)
    (tset vim.g "conjure#mapping#eval_visual"                      :jE)
    (tset vim.g "conjure#mapping#eval_motion"                      :jE)
    (tset vim.g "conjure#mapping#def_word"                        :jgd)
    (tset vim.g "conjure#mapping#doc_word"                         :jK)

    ;; Which-key Keybinds
    (local wk (require :which-key))
    (local mappings {:j {:name "Conjure"
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
                             :b ["Buffer"]}}})
    (wk.register mappings {:prefix :<leader>})
    (local visual-mappings {:j {:E ["Eval Visual"] :name :Conjure}})
    (wk.register visual-mappings {:prefix :<leader> :mode :v})
    (local motion-mappings {:j {:E ["Eval Motion"] :name :Conjure}})
    (wk.register motion-mappings {:prefix :<leader> :mode :x})
    (wk.register motion-mappings {:prefix :<leader> :mode :o})
    (vim.api.nvim_create_augroup :ConjureRemoveSponsor {:clear true})
    (vim.api.nvim_create_autocmd :BufWinEnter
                                 {:pattern :conjure-log-*
                                  :command "silent s/; Sponsored by @.*//e"})

    ;; Clojure
    (tset vim.g "conjure#client#clojure#nrepl#eval#auto_require"            false)
    (tset vim.g "conjure#client#clojure#nrepl#connection#auto_repl#enabled" false))

{: config}
