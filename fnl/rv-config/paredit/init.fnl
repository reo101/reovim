(fn config []
  (let [paredit (require :nvim-paredit)
        opt {;; should plugin use default keybindings? (= default true)
             :use_default_keys false
             ;; sometimes user wants to restrict plugin to certain file types only
             ;; defaults to all supported file types including custom lang
             ;; extensions (see next section)
             :filetypes
               ["fennel"
                "scheme"
                "racket"
                "crisp"
                "clojure"]
             ;; This is some language specific configuration. Right now this is just used for
             ;; setting character lists that are considered whitespace.
             :languages
               {:fennel {:whitespace_chars [" " ","]}
                :clojure {:whitespace_chars [" " ","]}}
             ;; This controls where the cursor is placed when performing slurp/barf operations
             ;;
             ;; - "remain" - It will never change the cursor position, keeping it in the same place
             ;; - "follow" - It will always place the cursor on the form edge that was moved
             ;; - "auto"   - A combination of remain and follow, it will try keep the cursor
             ;;              in the original position unless doing so would result
             ;;              in the cursor no longer being within the original form.
             ;;              In this case it will place the cursor on the moved edge
             :cursor_behaviour :auto
             :dragging
               {;; If set to `true` paredit will attempt to infer if an element being
                ;; dragged is part of a 'paired' form like as a map. If so then the element
                ;; will be dragged along with it's pair.
                :auto_drag_pairs true}
             :indent
               {;; This controls how nvim-paredit handles indentation when performing operations
                ;; which should change the indentation of the form, such as when slurping or barfing
                ;;
                ;; When set to true then it will attempt to fix the indentation of nodes operated on
                :enabled true
                ;; A function that will be called after a slurp/barf
                ;; if you want to provide a custom indentation implementation.
                :indentor
                  (. (require :nvim-paredit.indentation.native)
                     :indentor)}
             ;; list of keybindings
             :keys
               {"<localleader>@" [paredit.unwrap.unwrap_form_under_cursor "Splice sexp"]

                ">(" [paredit.api.barf_backwards "Barf backwards"]
                ">)" [paredit.api.slurp_forwards "Slurp forwards"]

                "<(" [paredit.api.slurp_backwards "Slurp backwards"]
                "<)" [paredit.api.barf_forwards   "Barf forwards"]

                :>e [paredit.api.drag_element_forwards  "Drag element forwards"]
                :<e [paredit.api.drag_element_backwards "Drag element backwards"]

                :>o [paredit.api.drag_form_forwards  "Drag form forwards"]
                :<o [paredit.api.drag_form_backwards "Drag form backwards"]

                :<localleader>o [paredit.api.raise_form    "Raise form"]
                :<localleader>O [paredit.api.raise_element "Raise element"]

                "E" {1 paredit.api.move_to_next_element_tail
                     2 "Jump to next element tail"
                     ;; by default all keybindings are dot repeatable
                     :repeatable false
                     :mode [:n :x :o :v]}
                "W" {1 paredit.api.move_to_next_element_head
                     2 "Jump to next element head"
                     :repeatable false
                     :mode [:n :x :o :v]}

                "B" {1 paredit.api.move_to_prev_element_head
                     2 "Jump to previous element head"
                     :repeatable false
                     :mode [:n :x :o :v]}
                "gE" {1 paredit.api.move_to_prev_element_tail
                      2 "Jump to previous element tail"
                      :repeatable false
                      :mode [:n :x :o :v]}

                "(" {1 paredit.api.move_to_parent_form_start
                     2 "Jump to parent form's head"
                     :repeatable false
                     :mode [:n :x :v]}
                ")" {1 paredit.api.move_to_parent_form_end
                     2 "Jump to parent form's tail"
                     :repeatable false
                     :mode [:n :x :v]}

                ;; These are just text object selection keybindings which can be used with standard `{d,y,c}` or `v`
                "ao" {1 paredit.api.select_around_form
                      2 "Around form"
                      :repeatable false
                      :mode [:o :v]}
                "io" {1 paredit.api.select_in_form
                      2 "In form"
                      :repeatable false
                      :mode [:o :v]}
                "aO" {1 paredit.api.select_around_top_level_form
                      2 "Around top level form"
                      :repeatable false
                      :mode [:o :v]}
                "iO" {1 paredit.api.select_in_top_level_form
                      2 "In top level form"
                      :repeatable false
                      :mode [:o :v]}
                "ae" {1 paredit.api.select_element
                      2 "Around element"
                      :repeatable false
                      :mode [:o :v]}
                "ie" {1 paredit.api.select_element
                      2 :Element
                      :repeatable false
                      :mode [:o :v]}}}]
    (paredit.setup opt)))

[{1 :julienvincent/nvim-paredit
  :version :1.1.1
  :ft ["fennel"
       "scheme"
       "racket"
       "crisp"
       "clojure"]
  : config}]
