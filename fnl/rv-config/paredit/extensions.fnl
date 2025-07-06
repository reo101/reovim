(fn get-generic-lisp-extension []
  (require :rv-config.paredit.generic-lisp-extension))

(fn after []
  (let [paredit (require :nvim-paredit)
        generic-lisp-extension (get-generic-lisp-extension)]
    ;; Scheme and Racket
    (each [_ language (ipairs [:scheme :racket])]
      (paredit.extension.add_language_extension
        language
        (generic-lisp-extension
          {: language
           :form-types [:list]
           :whitespace-chars [" "]})))

    ;; Crisp
    (paredit.extension.add_language_extension
      :crisp
      (generic-lisp-extension
        {:language :crisp
         :form-types [:sexpr
                      :fn
                      :fn_parameters
                      :let
                      :let_bindings
                      :binding
                      :if]
         :whitespace-chars [" "]}))

    ;; Fennel
    (paredit.extension.add_language_extension
      :fennel
      (generic-lisp-extension
        {:language :fennel
         :form-types [;; :program
                      :discard
                      :list
                      :sequence
                      :sequence_binding
                      :table
                      ;; :table_pair
                      :table_binding
                      ;; :table_binding_pair
                      :local_form
                      :fn_form
                      :let_form
                      :let_vars
                      ;; :binding_pair
                      :each_form
                      :collect_form
                      :icollect_form
                      :iter_body]
         :whitespace-chars [" " ","]}))))

{: after
 : generic-lisp-extension}
