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

      ;; Special Statusline
      SpecialStatusline
      (vim.tbl_extend
        :error
        {:condition (fn [self]
                      (conditions.buffer_matches
                        {:buftype [:nofile
                                   :prompt
                                   :help
                                   :quickfix]
                         :filetype [:^.git.*]}))}
        [Filetype
         Space
         Filename
         Align])]

  {: SpecialStatusline})
