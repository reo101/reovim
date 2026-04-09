(import-macros
  {: dbg!}
  :init-macros)

(fn after []
  (let [dk (require :def-keymaps)
        {: register-custom-parsers}
        (require :rv-config.treesitter.grammars)
        query-ext (require :rv-config.treesitter.query-ext)
        ts-runtime (require :rv-config.treesitter.runtime)
        highlight-repair (require :rv-config.treesitter.highlight-repair)
        fennel-highlights (require :rv-config.treesitter.fennel-highlights)]

    (query-ext.setup)
    (register-custom-parsers)

    (vim.api.nvim_create_autocmd :User
      {:pattern :TSUpdate
       :callback register-custom-parsers
       :desc "Register custom tree-sitter parsers"})

    (ts-runtime.setup)
    (fennel-highlights.setup)
    (highlight-repair.setup)

    ;; <leader>t for T**r**eesitter stuff
    (let [mappings {:t {:group :Toggle
                        :r {:group :TreeSitter
                            :g [#(vim.cmd.InspectTree) :PlayGround]}}}]
      (dk :n mappings {:prefix :<leader>}))))

[{:src "https://github.com/mfussenegger/nvim-ts-hint-textobject"
  :data {:dep_of [:nvim-treesitter]}}
 {:src "https://github.com/OXY2DEV/tree-sitter-comment"
  :data {:dep_of [:nvim-treesitter]}}
 {:src "https://github.com/nvim-treesitter/nvim-treesitter"
  :data {:build ":TSUpdate"
         : after}}
 (require (.. ... :.rainbow))
 (require (.. ... :.context))]
