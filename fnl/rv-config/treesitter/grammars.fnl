;;; Runtime registration helpers backed by the central tree-sitter registry.

(local registry (require :rv-config.treesitter.registry))

(fn register-language-aliases []
  (each [lang filetypes (pairs registry.extra-language-aliases)]
    (vim.treesitter.language.register lang filetypes))
  (each [lang grammar (pairs registry.grammars)]
    (let [filetypes (registry.grammar-filetypes grammar)]
      (when (> (length filetypes) 0)
        (vim.treesitter.language.register lang filetypes)))))

(fn register-custom-parsers []
  (local parser-configs (require :nvim-treesitter.parsers))
  (each [lang grammar (pairs registry.grammars)]
    (tset parser-configs lang {:install_info grammar.install_info}))
  (register-language-aliases))

{:custom-grammars registry.grammars
 :extra-language-aliases registry.extra-language-aliases
 :register-custom-parsers register-custom-parsers
 :register-language-aliases register-language-aliases}
