;;; Japanese Fennel Aliases
;;; Separated into specials (compiler core forms) and macros (built-in function aliases)

(local {: list : sym} (require :fennel))

(fn make-alias [english-name]
  "Create a macro function that wraps calls to the English form"
  #(list (sym english-name) $...))

(fn clone-of [target ?runtime]
  {:clone target
   :value (or ?runtime target)})

{:specials {;; Core forms (Keywords/operators)
            :且つ      (clone-of :and)
            :関数      (clone-of :fn)
            :なら      (clone-of :if)
            :又は      (clone-of :or)
            :非        (clone-of :not)
            :ローカル  (clone-of :local)
            :置く      (clone-of :let)
            :演る      (clone-of :do)
            :コメント  (clone-of :comment)}

 :macros {;; Built-in functions (Standard Macros)
          :マクロ        (clone-of :macro)
          :場合          (clone-of :when)
          :型            (clone-of :type (make-alias :type))
          :同一          (clone-of :rawequal (make-alias :rawequal))
          :刷る          (clone-of :print (make-alias :print))
          :組            (clone-of :pairs (make-alias :pairs))
          :添字組        (clone-of :ipairs (make-alias :ipairs))
          :展開する      (clone-of :unpack (make-alias :unpack))
          :誤る          (clone-of :error (make-alias :error))
          :文字列化      (clone-of :tostring (make-alias :tostring))}}
