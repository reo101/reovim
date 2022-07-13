(let [{: heirline
       : conditions
       : utils
       : colors
       : gps
       : navic
       : luasnip
       : icons}
      (require :rv-heirline.common)

      {: Snippets}
      (require :rv-heirline.components.snippets)

      ;; ViMode
      ViMode
      {:init     (fn [self]
                   (set self.mode (vim.fn.mode 1))
                   (when (not self.once)
                    (vim.api.nvim_create_autocmd
                      :ModeChanged
                      {:command :redrawstatus})
                    (set self.once true)))
       :static   {:mode-names {:n       :N    ;; NORMAL
                               :no      :N?   ;; Operator-pending
                               :nov     :N?   ;; Operator-pending (forced charwise |o_v|)
                               :noV     :N?   ;; Operator-pending (forced linewise |o_V|)
                               "no\022" :N?   ;; Operator-pending (forced blockwise |o_CTRL-V|)
                               :niI     :nil  ;; Normal using |i_CTRL-O| in |Insert-mode|
                               :niR     :Nr   ;; Normal using |i_CTRL-O| in |Replace-mode|
                               :niV     :Nv   ;; Normal using |i_CTRL-O| in |Virtual-Replace-mode|
                               :nt      :Nt   ;; Normal Terminal
                               :v       :V    ;; VISUAL
                               :vs      :Vs   ;; Visual substitute
                               :V       :V_   ;; VISUAL-LINE
                               :Vs      :Vs   ;; Visual Line substitute
                               "\022"   :^V   ;; VISUAL-BLOCK
                               "\022s"  :^V   ;; Visual Block substitute
                               :s       :S    ;; SELECT
                               :S       :S_   ;; SELECT-LINE
                               "\019"   :^S   ;; SELECT-BLOCK
                               :i       :I    ;; INSERT
                               :ic      :Ic   ;; Insert mode completion |compl-generic|
                               :ix      :Ix   ;; Insert mode |i_CTRL-X| completion
                               :R       :R    ;; REPLACE
                               :Rc      :Rc   ;; Replace mode completion |compl-generic|
                               :Rx      :Rx   ;; Replace mode |i_CTRL-X| completion
                               :Rv      :Rv   ;; Virtual Replace mode
                               :Rvc     :Rv   ;; Virtual Replace mode completion |compl-generic|
                               :Rvx     :Rv   ;; Virtual Replace mode |i_CTRL-X| completion
                               :c       :C    ;; COMMAND
                               :cv      :Ex   ;; Vim Ex Mode
                               :ce      :Ex   ;; Normal Ex Mode
                               :r       "..." ;; - HIT-Enter -
                               :rm      :M    ;; - More -
                               :r?      "?"   ;; - Confirm -
                               :!       "!"   ;; Shell Running
                               :t       :T}}  ;; TERMINAL
       :provider (fn [self]
                   (.. " %2(" (. self.mode-names self.mode) "%)"))
       :hl       (fn [self]
                   (let [color (self:mode-color)]
                     {:bg      color
                      :fg      :black
                      :bold    true}))}
      ViMode
      (utils.surround
        ["" ""]
        (fn [self]
          (self:mode-color))
        [ViMode
         Snippets])]

  {: ViMode})
