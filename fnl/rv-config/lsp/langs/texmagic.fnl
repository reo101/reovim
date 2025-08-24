(fn after []
   (let [opt {:engines {:pdflatex {:isContinuous false
                                   :executable :latexmk
                                   :args [:-pdflatex
                                          :-interaction=nonstopmode
                                          :-synctex=1
                                          :-outdir=.build
                                          :-pv
                                          "%f"]}
                        :luatex {:isContinuous false
                                 :onSave true
                                 :executable :latexmk
                                 :args [:-pdflua
                                        :-interaction=nonstopmode
                                        :-synctex=1
                                        :-pv
                                        "%f"]}
                        :lualatex {:isContinuous false
                                   :onSave true
                                   :executable :lualatex
                                   :args [:-interaction=nonstopmode
                                          :-synctex=1
                                          :-shell-escape
                                          :-pvc
                                          "%f"]}
                        ;; :xelatex {:isContinuous false
                        ;;           :executable :latexmk
                        ;;           :onSave true
                        ;;           :args [:-xelatex
                        ;;                  :-pdf
                        ;;                  :-interaction=nonstopmode
                        ;;                  :-synctex=1
                        ;;                  :-pvc
                        ;;                  "%f"]}
                        :xelatex {:isContinuous false
                                  :executable :xelatex
                                  :onSave true
                                  :args ["%f"]}}}]
     ((. (require :texmagic) :setup) opt)))

{:src "https://github.com/jakewvincent/texmagic.nvim"
 :data {:ft ["tex"
             "latex"]
        : after}}
