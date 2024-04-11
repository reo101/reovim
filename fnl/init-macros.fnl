;; fennel-ls: macro-file.

(fn rv [path]
  (assert-compile
    (= (type path) "string")
    "Path must be a string" path)
  `(hashfn
     ((. (require ,(.. :rv-config :. path)) :config))))

(fn dbg! [expr]
  `(do
     (let [expr# ,expr]
       (vim.print expr#)
       expr#)))

(fn assert-tbl [tbl]
  (assert-compile
    (or
      (table? tbl)
      (sym? tbl))
    "tbl should be a table"
    tbl))

(fn assert-seq [seq]
  (assert-compile
    (or
      (table? seq)
      (sym? seq))
    "seq should be a sequence"
    seq))

(fn apply [func args]
  (assert-seq args)
  `(,func ,(table.unpack args)))

(fn -m> [val ...]
  "Thread a value through a list of method calls"
  (assert-compile
    val
    "There should be an input value to the pipeline")
  (accumulate [res val
               _   [f & args] (ipairs [...])]
    `(: ,res ,f ,(unpack args))))

(fn -m?> [val ...]
  "Thread (maybe) a value through a list of method calls"
  (assert-compile
    val
    "There should be an input value to the pipeline")
  (var res# (gensym))
  (var res `(do (var ,res# ,val)))
  (each [_ [f & args] (ipairs [...])]
    (table.insert
      res
      `(when (and (not= nil ,res#)
                  (not= nil (. ,res# ,f)))
         (set ,res# (: ,res# ,f ,(unpack args))))))
  res)

(fn as-> [hole val ...]
  "Thread a value through a list of operations with a placeholder for the hole"
  (assert-compile
    val
    "There should be an input value to the pipeline")
  (assert-compile
    (sym? hole)
    "Hole should be a symbol")
  (local hole (tostring hole))
  (fn deep-sed [ast target res]
    (vim.print {: ast
                : target})
    (case (getmetatable ast)
      ;; Bottom of ast
      nil
      ast
      (where _ (not= :table (type ast)))
      ast
      ;; Target symbol
      (where {1 "SYMBOL"} (= (tostring ast) target))
      res
      ;; Another symbol
      {1 "SYMBOL"}
      ast
      ;; Iterate
      {1 "LIST"}
      (-> ast
          ipairs
          vim.iter
          (: :map #(deep-sed $2 target res))
          (: :totable)
          (#(list (unpack $))))
      {: keys}
      (collect [_ key (ipairs keys)]
        (values key (deep-sed (. ast key)
                              target
                              res)))
      {:sequence ["SEQUENCE"]}
      (-> ast
          ipairs
          vim.iter
          (: :map #(deep-sed $2 target res))
          (: :totable))
      ;; Just in case
      _
      (do
        (vim.print {: ast})
        (error :wtf))))
  (accumulate [res val
               _ call (ipairs [...])]
    (deep-sed call hole res)))

(fn >=> [tbl predicate? ?res]
  "Filter through a table and optionally append to a predefined result table
  NOTE: `predicate?` can take the key as a second argument"
  (assert-tbl tbl)
  (when ?res
    (assert-tbl ?res))
  (if (table? tbl)
      (do
        (var res (or ?res {}))
        (collect [k# v# (pairs tbl)
                  &into res]
          (if (predicate? v# k#)
            (values k# v#)))
        (res))
      (sym? tbl)
      `(collect [k# v# (pairs ,tbl)
                 &into (or ,?res {})]
         (if (,predicate? v# k#)
          (values k# v#)))))

(fn i>=> [seq predicate? ?res]
  "Filter through a sequence and optionally append to a predefined result sequence"
  (assert-seq seq)
  (when ?res
    (assert-seq ?res))
  (if (sequence? seq)
      (do
        (var res (or ?res []))
        (icollect [i# v# (ipairs seq)
                   &into res]
          (if (predicate? v#) v#))
        (res))
      (sym? seq)
      `(icollect [i# v# (ipairs ,seq)
                  &into (or ,?res [])]
         (if (,predicate? v#) v#))))

(fn |> [val ...]
  "Pipeline a value/values through a series of functions"
  (assert-compile
    val
    "There should be an input value to the pipeline")
  (var res val)
  (each [_ v (ipairs [...])]
    (set res (list v res)))
  res)

(fn ||> [...]
  "Compose functions"
  (var res _VARARG)
  (each [_ v (ipairs [...])]
    (set res (list v res)))
  `(fn [,_VARARG] ,res))

(fn >== [tbl fun]
  "Consume a table by passing every element to a function"
  (assert-tbl tbl)
  (if (table? tbl)
      (do
        (var res (list (sym :do)))
        (each [k# v# (pairs tbl)]
          (table.insert res `(,fun ,v#)))
       res)
      (sym? tbl)
      `(each [i# v# (pairs ,tbl)]
         (,fun v#))))

(fn i>== [seq fun]
  "Consume a sequence by passing every element to a function"
  (assert-seq seq)
  (if (sequence? seq)
      (do
        (var res (list (sym :do)))
        (each [i# v# (ipairs seq)]
          (table.insert res `(,fun ,v#)))
        res)
      (sym? seq)
      `(each [i# v# (ipairs ,seq)]
         (,fun v#))))

(fn map [tbl ...]
  "Map a table using a series of functions"
  (local fun (||> ...))
  (if (table? tbl)
      (do
        (var res {})
        (collect [k# v# (pairs tbl)
                  &into res]
          (values k# `(fun ,v#)))
        res)
      ;; else
      `(collect [k# v# (pairs ,tbl)
                 &into {}]
         (values k# (,fun v#)))))

(fn imap [seq ...]
  "Map a sequence using a series of functions"
  (local fun (||> ...))
  (if (sequence? seq)
      (do
        (var res [])
        (icollect [i# v# (ipairs seq)
                   &into res]
          `(fun ,v#))
        res)
      ;; else
      `(icollect [i# v# (ipairs ,seq)
                  &into []]
         (,fun v#))))

{: rv
 : dbg!
 : assert-tbl
 : assert-seq
 : apply :call apply
 : -m> : -m?>
 : as->
 : >=> :filter >=>
 : i>=> :ifilter i>=>
 : |> :pipe |>
 : ||> :o ||> :compose ||>
 : >== :foreach >==
 : i>== :forieach i>==
 : map
 : imap}
