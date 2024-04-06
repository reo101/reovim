(let [{: heirline
       : utils}
      (require :rv-config.heirline.common)

      ;; Macro recording
      MacroRec
      (vim.tbl_extend
        :error
        {:condition #(and (not= (vim.fn.reg_recording) "")
                          (= vim.o.cmdheight 0))
         :provider  "  "
         :hl        {:fg   :orange
                     :bold true}
         :update [:RecordingEnter
                  :RecordingLeave]}
        [(utils.surround
           ["[" "]"]
           nil
           {:provider #(vim.fn.reg_recording)
            :hl       {:fg   :green
                       :bold true}})])]

  {: MacroRec})
