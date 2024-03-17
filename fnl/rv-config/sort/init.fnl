(fn config []
  (let [sort (require :sort)
        dk (require :def-keymaps)
        opt {;; List of delimiters, in descending order of priority, to automatically sort on
             :delimiters [","
                          "|"
                          ";"
                          ":"
                          ;;; Space
                          "s"
                          ;;; Tab
                          "t"]}]
    (sort.setup opt)

    (let [mappings {:gs {:name :Sort
                         :! {:name :Reverse}}}]
      (each [_ delimiter (ipairs opt.delimiters)]
        (tset mappings.gs
              delimiter
              [#(sort.sort "" delimiter)])
        (tset mappings.gs.!
              delimiter
              [#(sort.sort "!" delimiter)]))
      (dk [:v]
          mappings))))

{1 :sQVe/sort.nvim
 :cmd ["Sort"]
 : config}
