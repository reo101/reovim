(let [{: conditions}
      (require :rv-config.heirline.common)

      ;;; Components

      ;; File-Block
      {: Filetype
       : Filename}
      (require :rv-config.heirline.components.file)

      ;; Align & Space
      {: Align
       : Space}
      (require :rv-config.heirline.components.align)

      ;;; Statusline

      ;; Inactive Statusline
      InactiveStatusline
      {:condition (fn [self]
                    (not (conditions.is_active)))
       1 (unpack [Filetype
                  Space
                  Filename
                  Align])}]

  {: InactiveStatusline})
