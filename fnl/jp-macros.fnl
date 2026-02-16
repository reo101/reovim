;; [nfnl-macro]
;; fennel-ls: macro-file
;; Japanese macro aliases for `Fennel` built-ins
;; Injected globally in `./bootstrap-nfnl.fnl`

(fn make-alias [english-name]
  "Create a macro function that wraps calls to the English form"
  #(list (sym english-name) $...))

{;; Core forms
 :マクロ    (make-alias :macro)
 :関数      (make-alias :fn)
 :ローカル  (make-alias :local)
 :付く      (make-alias :let)
 :場合      (make-alias :when)
 :演る      (make-alias :do)

 ;; Built-in functions
 :刷る          (make-alias :print)
 :展開する      (make-alias :unpack)
 :非            (make-alias :not)
 :誤る          (make-alias :error)
 :文字列にする  (make-alias :tostring)}
