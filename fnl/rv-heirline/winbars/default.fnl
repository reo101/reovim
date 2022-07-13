(let [{: utils}
      (require :rv-heirline.common)

      ;;; Components

      ;; Align & Space
      {: Align}
      (require :rv-heirline.components.align)

      ;; Location
      {: Location}
      (require :rv-heirline.components.location)

      ;;; Winbar

      ;; Default Winbar
      DefaultWinbar
      [Align
       (utils.surround
         ["" ""]
         (fn [self]
           (. (utils.get_highlight :StatusLine) :bg))
         (unpack [Location]))
       Align]]

  {: DefaultWinbar})
