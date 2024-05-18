(fn config []
  (let [idris2 (require :idris2)
        idris2-repl (require :idris2.repl)
        idris2-code-action (require :idris2.code_action)
        dk (require :def-keymaps)
        {: lsp-mappings} (require :rv-config.lsp.utils)
        opts {:code_action_post_hook #(vim.cmd "silent write")}]
    ;;; Setup
    (idris2.setup opts)

    ;;; Mappings
    (lsp-mappings)
    (vim.api.nvim_create_autocmd
      [:BufRead
       :BufNewFile]
      {:pattern [:*.idr]
       :callback
         #(do (dk :n
                  {:i {:name :Idris
                       :e [idris2-repl.evaluate            "Evaluate"]
                       :c [idris2-code-action.case_split   "Case split"]
                       :m [idris2-code-action.make_case    "Make case"]
                       :m [idris2-code-action.make_lemma   "Make lemma"]
                       :a [idris2-code-action.add_clause   "Add clause"]
                       :e [idris2-code-action.expr_search  "Expr search"]
                       :g [idris2-code-action.generate_def "Generate def"]
                       :r [idris2-code-action.refine_hole  "Refine hole"]
                       :i [idris2-code-action.intro        "Intro"]}}
                  {:prefix :<leader>}))})))

{1 :ShinKage/idris2-nvim
 :dependencies [:neovim/nvim-lspconfig
                :MunifTanjim/nui.nvim]
 :ft [:idris]
 : config}
