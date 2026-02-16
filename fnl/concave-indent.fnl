;;; concave-indent.fnl
;;; Custom indentation using mathematical curves
;;;
;;; The curve function receives `t` ∈ [0,1] (0 = first line, 1 = last line)
;;; and returns the indent width in columns. Endpoints are always t=0 and t=1.
;;;
;;; Usage:
;;;   (local ci (require :concave-indent))
;;;   (ci.enable (ci.sine-curve 16))
;;;   (ci.enable (fn [t] (* 20 (math.sin (* math.pi t)))))

(local indentexpr-by-buf {})

(fn current-bufnr []
  (vim.api.nvim_get_current_buf))

(fn make-indentexpr [curve-fn]
  "Create an indent function. `curve-fn` takes t ∈ [0,1] and returns indent columns."
  (fn [?lnum ?bufnr]
    (let [bufnr (or ?bufnr (current-bufnr))
          lnum (or ?lnum vim.v.lnum)
          total (vim.api.nvim_buf_line_count bufnr)
          t (if (<= total 1)
                0
                (/ (- lnum 1) (- total 1)))]
      (math.max 0 (math.floor (+ 0.5 (curve-fn t)))))))

(fn get-indent [?bufnr ?lnum]
  (let [bufnr (or ?bufnr (current-bufnr))
        indent-fn (. indentexpr-by-buf bufnr)]
    (if (= (type indent-fn) :function)
        (indent-fn ?lnum bufnr)
        -1)))

(fn ensure-global-dispatcher! []
  (when (not= _G.ConcaveGetIndent get-indent)
    (tset _G :ConcaveGetIndent get-indent)))

(fn enable [curve-fn]
  "Enable concave indentation for the current buffer.
   `curve-fn` takes t ∈ [0,1] (normalized line position) and returns indent columns."
  (let [bufnr (current-bufnr)
        indent-fn (make-indentexpr curve-fn)]
    (ensure-global-dispatcher!)
    (tset indentexpr-by-buf bufnr indent-fn)
    (tset vim.bo :indentexpr "v:lua.ConcaveGetIndent()")
    indent-fn))

;;; Curve generators — all produce 0 at t=0 and t=1

(fn sine-curve [max-indent]
  "Sine arch: 0 at edges, max-indent in the middle."
  (fn [t]
    (* max-indent (math.sin (* math.pi t)))))

(fn parabolic-curve [max-indent]
  "Parabola: 0 at edges, max-indent in the middle. 4·t·(1−t)."
  (fn [t]
    (* max-indent 4 t (- 1 t))))

(fn triangular-curve [max-indent]
  "Triangle: 0 at edges, max-indent in the middle."
  (fn [t]
    (* max-indent (- 1 (* 2 (math.abs (- t 0.5)))))))

(fn power-curve [max-indent ?power]
  "Raised sine: sin(π·t)^power. Higher power = sharper peak."
  (let [p (or ?power 2)]
    (fn [t]
      (* max-indent (math.pow (math.sin (* math.pi t)) p)))))

{: make-indentexpr
 : get-indent
 : enable
 : sine-curve
 : parabolic-curve
 : triangular-curve
 : power-curve}
