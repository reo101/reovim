;;; agda-native-source.fnl (Radically Simplified Structure)

(local inspect (or (pcall require :inspect) vim.inspect))
(fn p [...]
  (let [objects [...]
        inspected-list (icollect [_ v (ipairs objects)] (inspect v))
        str (table.concat inspected-list "	")]
    (print (.. "[agda-debug] " str))))

(p "Module is being loaded.")

;; Define the source object directly.
(local source {:trigger_characters ["\\"]})


(local symbols-module (pcall require :rv-config.lsp.langs.agda.symbols))

;; Attach functions to the source object.
(fn source.is_triggered [self ctx]
  (let [char ctx.char
        triggered (= char "\\")]
   (p (.. "is_triggered | char: '" char "' | returning: " (tostring triggered)))
   triggered))

(fn source.complete [self ctx callback]
  (p "complete() called.")
  (let [line ctx.cursor_before_line
        pattern-ok (string.match line "\\\\%S*$")
        symbols-ok (and symbols-module (. symbols-module :cmp-symbols))]

    (p (.. "Line: '" line "' | Pattern OK? " (tostring pattern-ok) " | Symbols OK? " (tostring symbols-ok)))

    (if (and pattern-ok symbols-ok)
        (let [symbols-list (. symbols-module :cmp-symbols)]
          (p (.. "✅ Sending " (# symbols-list) " symbols."))
          (callback symbols-list))
        (do
          (p "❌ Conditions not met. Sending empty list.")
          (callback {})))))

(fn source.new []
  (p "source.new() called.")
  (setmetatable {} {:__index source}))

source
