(let [{: utils}
      (require :rv-config.heirline.common)

      ;;; Components

      ;; Align & Space
      {: Align}
      (require :rv-config.heirline.components.align)

      ;; Location
      {: Location}
      (require :rv-config.heirline.components.location)

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
