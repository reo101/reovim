(fn rv [path]
  (assert-compile
    (= (type path) "string")
    "Path must be a string" path)
  `(hashfn
     ((. (require ,(.. "rv-" path)) :config))))

(fn apply [func args]
  (assert-compile
    (and
      ;; (= (type func) "function")
      (sequence? args))
    "Args should be a sequential table"
    {: func
     : args})
  `(,func ,(table.unpack args)))

(fn filter [tbl predicate? ?res]
  (assert-compile
    (table? tbl)
    "tbl should be a table"
    tbl)
  `(collect [k# v# (pairs ,tbl)
             :into (or ,?res {})]
     (if (,predicate? k# v#)
       (values k# v#))))

(fn ifilter [seq predicate? ?res]
  (assert-compile
    (sequence? seq)
    "seq should be a sequential table"
    seq)
  `(icollect [i# v# (ipairs ,seq)
              :into (or ,?res [])]
     (if (,predicate? v#) v#)))

{: rv
 : apply
 : filter
 : ifilter}
