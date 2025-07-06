(local source {})

(local symbols-module (require :rv-config.lsp.langs.agda.symbols))

(fn source.new [opts]
  "Creates an instance of the source and dynamically computes trigger characters."
  (let [self (setmetatable {} {:__index source})]
    (set self.opts opts)
    (set self.raw-symbols symbols-module.raw-symbols)

    self))

(fn source.enabled [self]
  "Enable this source for Haskell and Agda."
  (or (= vim.bo.filetype :agda)
      (= vim.bo.filetype :lagda.md)
      (= vim.bo.filetype :haskell)
      (= vim.bo.filetype :lhaskell)))

(fn source.get_trigger_characters [self]
  "Triggers completion on backslash."
  [;; "'"
   ;; " "
   ;; "!"
   ;; "\""
   ;; "("
   ;; ")"
   ;; "*"
   ;; "+"
   ;; "-"
   ;; "."
   ;; ":"
   ;; "<"
   ;; "="
   ;; ">"
   ;; "^"
   ;; "_"
   ;; "`"
   ;; "{"
   ;; "|"
   ;; "}"
   ;; "~"
   "\\"])

(fn source.get_keyword_pattern [self]
  "\\\\S*")

(fn source.get_completions [self ctx callback]
  "Provides the list of Agda symbols with a manually calculated robust range."
  ;; --- Robust Range Calculation ---
  ;; We ignore ctx.bounds and find the start of the sequence ourselves.
  (let [line-to-cursor (string.sub (vim.api.nvim_get_current_line) 1 (. ctx.cursor 2))]

    (when (= (type line-to-cursor) :string)
      ;; Find the start of the last `\` sequence on the line before the cursor.
      (let [match-start-col (line-to-cursor:find "\\.*$")]

        (when match-start-col
          (let [items []
                ;; Use the start column we found, not the unreliable one from ctx.
                start-char (- match-start-col 1)
                line (- (. ctx.cursor 1) 1)
                end-char (. ctx.cursor 2)]

            (each [key-sequence symbol (pairs self.raw-symbols)]
              (table.insert items
                {:label (.. key-sequence " " symbol)
                 :filterText (.. "\\" key-sequence)
                 :textEdit {:newText symbol
                            :range {:start {: line :character start-char}
                                    :end   {: line :character end-char}}}}))

            (when (> (# items) 0)
              (callback {: items}))))))))

source
