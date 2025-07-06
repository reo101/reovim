(fn after []
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

    (let [mappings {:gs {:group :Sort
                         :! {:group :Reverse}}}]
      (each [_ delimiter (ipairs opt.delimiters)]
        (tset mappings.gs
              delimiter
              #(sort.sort "" delimiter))
        (tset mappings.gs.!
              delimiter
              #(sort.sort "!" delimiter)))
      #_(vim.print mappings)
      (dk :v
          mappings))))

{:src "https://github.com/sQVe/sort.nvim"
 :data {:cmd ["Sort"]
        : after}}
