;;; Japanese Fennel Aliases
;;; Separated into specials (compiler core forms) and macros (built-in function aliases)

(local {: list : sym} (require :fennel))

(fn make-alias [english-name]
  "Create a macro function that wraps calls to the English form"
  #(list (sym english-name) $...))

(fn clone-of [target ?opts-or-runtime ?capture]
  (let [table-opts? (= (type ?opts-or-runtime) :table)
        capture-only? (and (not table-opts?)
                           (= ?capture nil)
                           (= (type ?opts-or-runtime) :string))
        runtime (if table-opts?
                    (. ?opts-or-runtime :value)
                    (if capture-only?
                        nil
                        ?opts-or-runtime))
        capture (if table-opts?
                    (. ?opts-or-runtime :capture)
                    (if capture-only?
                        ?opts-or-runtime
                        ?capture))]
    {:clone target
     :value (or runtime target)
     :capture capture}))

{:specials {;; Core forms (Keywords/operators)
            :且つ      (clone-of :and :keyword.operator)
            :関数      (clone-of :fn :keyword.function)
            :なら      (clone-of :if :keyword.conditional)
            :又は      (clone-of :or :keyword.operator)
            :非        (clone-of :not :keyword.operator)
            :ローカル  (clone-of :local :keyword)
            :置く      (clone-of :let :keyword)
            :演る      (clone-of :do :keyword)
            :コメント  (clone-of :comment :keyword)}

 :macros {;; Built-in functions (Standard Macros)
          :マクロ        (clone-of :macro :function.macro)
          :場合          (clone-of :when :keyword.conditional)
          :型            (clone-of :type (make-alias :type) :function.builtin)
          :同一          (clone-of :rawequal (make-alias :rawequal) :function.builtin)
          :刷る          (clone-of :print (make-alias :print) :function.builtin)
          :組            (clone-of :pairs (make-alias :pairs) :function.builtin)
          :添字組        (clone-of :ipairs (make-alias :ipairs) :function.builtin)
          :展開する      (clone-of :unpack (make-alias :unpack) :function.builtin)
          :誤る          (clone-of :error (make-alias :error) :function.builtin)
          :文字列化      (clone-of :tostring (make-alias :tostring) :function.builtin)}}
