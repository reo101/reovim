;;; Japanese Fennel Aliases
;;; Separated into specials (compiler core forms) and macros (built-in function aliases)

(local {: list : sym} (require :fennel))

(fn make-alias [english-name]
  "Create a macro function that wraps calls to the English form"
  #(list (sym english-name) $...))

(fn clone-of [target ?runtime]
  {:clone target
   :value (or ?runtime target)})

{:specials {;; Core forms (Keywords)
            :関数      (clone-of :fn)
            :もし      (clone-of :if)
            :ローカル  (clone-of :local)
            :付く      (clone-of :let)
            :演る      (clone-of :do)}

 :macros {;; Built-in functions (Standard Macros)
          :マクロ        (clone-of :macro)
          :場合          (clone-of :when)
          :刷る          (clone-of :print (make-alias :print))
          :展開する      (clone-of :unpack (make-alias :unpack))
          :非            (clone-of :not (make-alias :not))
          :誤る          (clone-of :error (make-alias :error))
          :文字列にする  (clone-of :tostring (make-alias :tostring))}}
