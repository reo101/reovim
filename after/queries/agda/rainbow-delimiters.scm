; extends

;; NOTE: all atoms

(atom
  ["(" "{" "{{" "⦃"] @delimiter
  [")" "}" "}}" "⦄"] @delimiter @sentinel) @container

;; NOTE: all bindings

(typed_binding
  ["(" "{" "{{" "⦃"] @delimiter
  ":" @delimiter
  [")" "}" "}}" "⦄"] @delimiter @sentinel) @container

(untyped_binding
  ["(" "{" "{{" "⦃"] @delimiter
  (":" @delimiter)?
  [")" "}" "}}" "⦄"] @delimiter @sentinel) @container

;; NOTE: forall

;; BUG:
;;  ∀ needs to be one @container lower
;;  child expr should be one @container up

(expr
  (forall
    .
    ["forall" "∀"] @delimiter
    .
    (untyped_binding)
    .
    (typed_binding)*
    .
    (["->" "→"] @delimiter)
    .
    (expr) @sentinel
    .
    )
  ) @container

;; NOTE: lambda
;; BUG:
;;  can't get both lambda forms to work simultaneously

(lambda
  .
  ["\\" "λ"] @delimiter
  .
  [
    (
      [
        (typed_binding)
        (untyped_binding)
      ]*
      .
      ["->" "→"] @delimiter
      .
      (expr) @container @sentinel
    )
    (
      "{" @delimiter
      ; (
      ;   (lambda_clause
      ;     ["->" "→"] @delimiter @sentinel) @container
      ;   (";" @delimiter)?
      ; )*
      "}" @delimiter @sentinel
    )
  ]
  .
  ) @container

; (lambda
;   "{" @delimiter
;   "}" @delimiter @sentinel) @container

(
  (lambda_clause
    (atom) @container
    ["->" "→"] @delimiter
    (expr) @sentinel) ;; @container
  .
  (";" @delimiter)?
)

; (lambda
;   .
;   ["\\" "λ"] @delimiter
;   .
;   [
;    (typed_binding)
;    (untyped_binding)
;    ]*
;   .
;   ["->" "→"] @delimiter
;   .
;   (expr)
;   .)

; (lambda
;   .
;   ["\\" "λ"] @delimiter
;   .
;   "{" @delimiter
;   ((lambda_clause
;      ["->" "→"] @delimiter @sentinel) @container
;    (";" @delimiter)?)*
;   "}" @delimiter @sentinel
;   .)

;; NOTE: data/record

(data
  (data_name)
  .
  (
    [
      (untyped_binding)
      (typed_binding)
    ]* @sentinel
  ) @container
  .
  ":" @delimiter
  (expr) @container @sentinel) @container

(record_signature
  (record_name)
  .
  (
    [
      (untyped_binding)
      (typed_binding)
    ]* @sentinel
  ) @container
  .
  ":" @delimiter
  (expr) @container @sentinel) @container

(record_assignments
  "{" @delimiter
  (
    (field_assignment
      (field_name)
      "=" @delimiter @sentinel
      (expr) ;; @sentinel
      ; (expr
      ;   .
      ;   _ @sentinel) @container
      ) @container
    (";" @delimiter)?
  )*
  "}" @delimiter @sentinel) @container

;; NOTE: holes

(expr
  (atom
    "{"
    (expr
      .
      (atom
        (qid)) @_left_bang
      (atom
        (qid)) @_right_bang
      .)
    "}" @delimiter @sentinel)
  (#eq? @_left_bang  "!")
  (#eq? @_right_bang "!")) @delimiter @container

;; NOTE: typing judgements

(expr
  .
  [
    (atom)
    (typed_binding)
    (untyped_binding)
  ]+
  .
  (["->" "→"] @delimiter)
  .
  (expr) @sentinel
  .
  ) @container

;; NOTE: lower container level for last type in judgements

;; BUG: succesfully lowers the level, but leaks (no good place for @sentinel)
(
  ; (expr) @_expr @container
  (expr
    .
    _ @sentinel) @_expr @container
  (#has-parent? @_expr expr)
  (#has-no-child? @_expr "->" "→")
)

(rhs
  ":" @delimiter
  (expr) @sentinel) @container

(signature
  (field_name)+
  ":" @delimiter
  (expr) @sentinel) @container

;; NOTE: function declaration

(rhs
  "=" @delimiter
  (expr) @sentinel) @container

;; NOTE: import

(import_directive
  "(" @delimiter
  ; .
  ; (
  ;   (id)
  ;   .
  ;   (";" @delimiter)?
  ; )*
  ; .
  ")" @delimiter @sentinel
  ) @container

(
  (id)
  .
  (";" @delimiter)?
)

;; NOTE: relics, early hardcoded half-working solutions

; (import_directive
;   "(" @delimiter
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   ")" @delimiter @sentinel) @container

; (lambda
;   "{" @delimiter
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   (";" @delimiter)*
;   "}" @delimiter @sentinel) @container
