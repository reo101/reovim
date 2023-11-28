(local generic-lisp-extension (require :rv-config.paredit.generic-lisp-extension))

(fn config []
  (let [paredit (require :nvim-paredit)]
    ;; Scheme and Racket
    (each [_ lang (ipairs [:scheme :racket])]
      (paredit.extension.add_language_extension
        lang
        (generic-lisp-extension
          {:form-types [:list]
           :whitespace-chars [" "]})))
 
    ;; Crisp
    (paredit.extension.add_language_extension
      :crisp
      (generic-lisp-extension
        {:form-types [:sexpr
                      :fn
                      :fn_parameters
                      :let
                      :let_bindings
                      :binding
                      :if]
         :whitespace-chars [" "]}))))

{: config
 : generic-lisp-extension}
