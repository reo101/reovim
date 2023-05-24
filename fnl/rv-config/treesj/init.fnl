(fn config []
  (let [dk    (require :def-keymaps)
        tsj   (require :treesj)
        langs {}
        opt   {;; Use default keymaps
               ;; (<space>m - toggle, <space>j - join, <space>s - split)
               :use_default_keymaps false
               ;; Nodes with syntax error will not be formatted
               :check_syntax_error  true
               ;; If line after join will be longer than max value,
               ;; node will not be formatted
               :max_join_length     120
               ;; hold|start|end:
               ;; hold - cursor follows the node/place on which it was called
               ;; start - cursor jumps to the first symbol of the node being formatted
               ;; end - cursor jumps to the last symbol of the node being formatted
               :cursor_behavior     :hold
               ;; Notify about possible problems
               :notify              true
               ;; Use `.` to repeat the action
               :dot_repeat          true
               ;; Pass along langs' setup
               : langs}]
    (tsj.setup opt)
    (dk [:n]
        {:j {:name "SplitJoin"
             :s [#(tsj.split)  "Split"]
             :j [#(tsj.join)   "Join"]
             :m [#(tsj.toggle) "Toggle"]
             :M [#(tsj.toggle {:split {:recursive true}}) "Toggle (recursive)"]}}
        {:prefix :<leader>})))

{: config}
