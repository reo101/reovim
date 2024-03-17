(import-macros
  {: mdo}
  :fp.mdo-macros)

(local Result {})

;;; Metatable
(local Result-mt
       {:__index
          (fn [self key]
            (if (= (type key) :number)
                (rawget self key)
                ((. Result key) self)))})

;;; Validation
(fn Result.ok? [mx]
  (match mx
    [:ok & _] true
    _ false))
(fn Result.err? [mx]
  (match mx
    [:err & _] true
    _ false))
(fn Result.result? [mx]
  (or (Result.ok?  mx)
      (Result.err? mx)))

;;; Construction
(fn Result.ok [...]
  (setmetatable [:ok ...] Result-mt))
(fn Result.err [...]
  (setmetatable [:err ...] Result-mt))
(fn Result.new [...]
  (match ...
    (where r (Result.result? r)) r
    (nil err)                    (Result.err err)
    _                            (Result.ok ...)))
(fn Result.pcall [...]
  (match (pcall ...)
    (true  ok)  (Result.ok  ok)
    (false err) (Result.err err)))

;;; Functor
(fn Result.map [mx f]
  (match mx
    [:ok & ok] (Result.ok (f (unpack ok)))
    _ mx))
(fn Result.maperr [mx f]
  (match mx
    [:err & err] (Result.err (f (unpack err)))
    _ mx))
(fn Result.bimap [mx of ef]
  (match mx
    [:ok  & ok]  (Result.ok  (of (unpack ok)))
    [:err & err] (Result.err (ef (unpack err)))))

;;; Monad
(fn Result.pure [...]
  (match ...
    (nil) [:err nil]
    _     [:ok ...]))
(fn Result.join [mx]
  (match mx
    [:err & err] [:err (values (unpack err))]
    [:ok r]      [:ok r]))
(fn Result.>>= [mx f]
  (match mx
    [:ok & ok] (f (unpack ok))
    _ mx))

;;; Miscellaneous
(fn Result.validate [v p e]
  (mdo Result
    (<- x v)
    (if (p x)
        (Result.new x)
        (Result.err e))))
(fn Result.unwrap [mx]
  (match mx
    [:ok & ok] (values (unpack ok))
    _ nil))
(fn Result.unwrap! [mx]
  (match mx
    [:ok  & ok]  (values (unpack ok))
    [:err & err] (error err)))

(mdo Result
  (<- x (Result.new 5))
  (<- y (Result.new 6))
  (Result.pure (+ x y)))

Result
