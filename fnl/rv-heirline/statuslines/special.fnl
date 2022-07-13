(let [{: conditions}
      (require :rv-heirline.common)

      ;;; Components

      ;; File-Block
      {: Filetype
       : Filename}
      (require :rv-heirline.components.file)

      ;; Align & Space
      {: Align
       : Space}
      (require :rv-heirline.components.align)

      ;;; Statusline

      ;; Special Statusline
      SpecialStatusline
      {:condition (fn [self]
                    (conditions.buffer_matches
                      {:buftype [:nofile
                                 :prompt
                                 :help
                                 :quickfix]
                       :filetype [:^.git.*]}))
       1 (unpack [Filetype
                  Space
                  Filename
                  Align])}]

  {: SpecialStatusline})
