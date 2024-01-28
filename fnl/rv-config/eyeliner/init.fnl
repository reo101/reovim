(fn config []
  (let [eyeliner (require :eyeliner)
        opt {;; show highlights only after keypress
             :highlight_on_key true
             ;; dim all other characters if set to true (recommended!)
             :dim true}]
    (eyeliner.setup opt)))

{: config}
