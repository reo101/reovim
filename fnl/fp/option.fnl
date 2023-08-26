(import-macros
  {: mdo}
  :fp.mdo-macros)

(local Option {})

;;; Validation
(fn Option.some? [mx]
  (match mx
    [:some & _] true
    _ false))
(fn Option.none? [mx]
  (match mx
    [:none] true
    _ false))
(fn Option.option? [mx]
  (or (Option.some? mx)
      (Option.none? mx)))

;;; Construction
(fn Option.some [...]
  [:some ...])
(fn Option.none [...]
  [:none])
(fn Option.new [x]
  (match x
    (nil) (Option.none)
    _     (Option.some x)))

;;; Monad
(fn Option.pure [...]
  (Option.ok ...))
(fn Option.join [mx]
  (match mx
    [:some [:some & x]] (values (unpack x))))
(fn Option.>>= [mx f]
  (match mx
    [:some & x] (f (unpack x))
    _           mx))

;;; Miscellaneous
(fn Option.unwrap [mx]
  (match mx
    [:some & x] (values (unpack x))
    [:none] nil))
(fn Option.unwrap! [mx]
  (match mx
    [:some & x] (values (unpack x))
    [:none] (error "Tried to unwrap a none")))

Option
