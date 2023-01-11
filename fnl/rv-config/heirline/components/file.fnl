(let [{: heirline
       : conditions
       : utils
       : colors
       : icons}
      (require :rv-config.heirline.common)

      ;; File-Block
      File-Block
      {:init (fn [self]
               (set self.filename (vim.api.nvim_buf_get_name 0)))}

      ;; Filename-Icon
      Filetype-Icon
      {:init     (fn [self]
                   (local filename self.filename)
                   (local extension (vim.fn.fnamemodify filename ":e"))
                   (set-forcibly!
                     (self.icon self.icon_color)
                     (icons.get_icon_color
                      filename
                      extension
                      {:default true})))
       :provider (fn [self]
                   (and self.icon (.. self.icon " ")))
       :hl       (fn [self]
                   {:fg self.icon_color})}

      ;; Filename
      Filename
      {:condition (fn [self]
                    (not= (vim.fn.fnamemodify self.filename ":.") :null))
       :provider (fn [self]
                   (let [filename (vim.fn.fnamemodify self.filename ":.")]
                     (if
                       (= filename "")
                       "[No Name]"
                       (not (conditions.width_percent_below
                              (length filename)
                              0.25))
                       (vim.fn.pathshorten filename)
                       ;; else
                       filename)))
       :hl       {:fg (. (utils.get_highlight :Directory) :fg)}}

      ;; FileFlags
      File-Flags
      [{:provider (fn [self]
                    (if (or (not vim.bo.modifiable)
                            vim.bo.readonly)
                      ""))
        :hl       {:fg colors.green}}
       {:provider (fn [self]
                    (if vim.bo.modified
                      "[+]"))
        :hl       {:fg colors.orange}}]

      ;; FilenameModifer
      Filename-Modifer
      {:hl (fn [self]
             (if vim.bo.modified
               {:fg    colors.cyan
                :bold  true
                :force true}))}

      ;; Filetype
      Filetype
      {:provider (fn [self]
                   (string.upper vim.bo.filetype))

       :hl       {:fg   (. (utils.get_highlight :Type) :fg)
                  :bold true}}

      ;; File-Encoding
      File-Encoding
      {:provider (fn [self]
                  (let [enc (or (and (not= vim.bo.fenc "")
                                     vim.bo.fenc)
                                vim.o.enc)]
                   (and (not= enc :utf-8) (enc:upper))))}

      ;; File-Format
      File-Format
      {:provider (fn [self]
                   (let [fmt vim.bo.fileformat]
                     (and (not= fmt :unix) (fmt:upper))))}

      ;; File-LastModified
      File-LastModified
      {:provider (fn [self]
                   (let [ftime (vim.fn.getftime
                                 (vim.api.nvim_buf_get_name
                                   0))]
                     (and (> ftime 0) (os.date :%c ftime))))}

      ;; File-Block
      File-Block
      (utils.insert
        File-Block
        Filetype-Icon
        Filename
        (unpack File-Flags)
        Filename-Modifer
        File-Encoding
        File-Format
        {:provider :%<})]

  {: Filetype
   : Filetype-Icon
   : Filename
   : File-Block})
