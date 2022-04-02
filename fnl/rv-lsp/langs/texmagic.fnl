(fn config []
   (let [opt {:engines {:pdflatex {:isContinuous false
                                   :executable :latexmk
                                   :args [:-pdflatex
                                          :-interaction=nonstopmode
                                          :-synctex=1
                                          :-outdir=.build
                                          :-pv
                                          "%f"]}
                        :lualatex {:isContinuous false
                                   :executable :latexmk
                                   :args [:-pdflua
                                          :-interaction=nonstopmode
                                          :-synctex=1
                                          :-pv
                                          "%f"]}
                        :xelatex {:isContinuous false
                                  :executable :latexmk
                                  :onSave true
                                  :args [:-xelatex
                                         :-pdf
                                         :-interaction=nonstopmode
                                         :-synctex=1
                                         :-pvc
                                         "%f"]}}}]
     ((. (require :texmagic) :setup) opt)))

{: config}
