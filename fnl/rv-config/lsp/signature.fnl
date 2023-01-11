(fn config []
   (let [opt {:hint_scheme :String
              :bind true
              :use_lspsaga false
              :extra_trigger_chars []
              :hi_parameter :Search
              :doc_lines 2
              :max_width 120
              :hint_enable true
              :handler_opts {:border :shadow}
              :floating_window true
              :max_height 12
              :fix_pos false
              :hint_prefix "🐼 "}]
     ((. (require :lsp_signature) :on_attach) opt)))

{: config}
