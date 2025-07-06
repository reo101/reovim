;; Configure Vim's comment settings for WIT files.
;; This handles doc comments (///, /** */) and regular comments (//, /* */).
;; The order is important: longest match must come first.
;; s1:/**,mb: *,ex:*/ - Docblock comments
;; s1:/*,mb:*,ex:*/   - Regular block comments
;; :///               - Doc-line comments
;; ://                - Regular line comments
(tset vim.opt_local :comments "s1:/**,mb: *,ex:*/,s1:/*,mb:*,ex:*/,:///,://")

;; Define how to create a new single-line comment.
;; The '%s' is where the commented text will go.
;; This is used by operators like 'gc' or plugins like vim-commentary.
(tset vim.opt_local :commentstring "// %s")
