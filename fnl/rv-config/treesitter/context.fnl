(fn config []
  (let [dk (require :def-keymaps)
        treesitter-context (require :treesitter-context)
        opt {;; Enable this plugin (Can be enabled/disabled later via commands)
             :enable true
             ;; Throttles plugin updates (may improve performance)
             :throttle true
             ;; How many lines the window should span. Values <= 0 mean no limit.
             :max_lines 0
             ;; Match patterns for TS nodes. These get wrapped to match at word boundaries.
             :patterns
               {;; For all filetypes
                ;;  Note that setting an entry here replaces all other patterns for this entry.
                ;;  By setting the "default" entry below, you can control which nodes you want to
                ;;  appear in the context window.
                :default
                  [:class
                   :function
                   :method]}}]
                   ;; "for" ;; These won't appear in the context
                   ;;  "while"
                   ;;  "if"
                   ;;  "switch"
                   ;;  "case"
                ;; Example for a specific filetype.
                ;; If a pattern is missing, *open a PR* so everyone can benefit.
                ;; :rust
                ;;   ["impl_item"]
    (treesitter-context.setup opt)
    (dk :n
        {:t {:group :Toggle
             :s {:group :TreeSitter
                 :c [#(treesitter-context.toggle) :Context]}}}
        {:prefix :<leader>})))

{1 :romgrk/nvim-treesitter-context
 :event :VeryLazy
 : config}
