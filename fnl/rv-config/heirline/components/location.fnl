(let [{: heirline
       : conditions
       : utils
       : colors
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-config.heirline.common)

      ;; Navic
      {: Navic
       : NavicNonemptyIndicator}
      (require :rv-config.heirline.components.navic)

      ;; Relative Path
      RelativePath
      {:init      (fn [self]
                    (let [buf-name  (vim.api.nvim_buf_get_name 0)
                          filename  (vim.fn.fnamemodify buf-name ":t")
                          extension (vim.fn.fnamemodify filename ":e")
                          (icon icon_color) (icons.get_icon_color
                                              filename
                                              extension
                                              {:default true})
                          path (vim.fn.fnamemodify buf-name ":~:.:h")
                          path (if
                                 (= path "")
                                 :.
                                 (not (conditions.width_percent_below
                                        (length path)
                                        0.4))
                                 (vim.fn.fnamemodify path ":t")
                                 ;; else
                                 path)
                          directories (string.gmatch path "([^/]+)")
                          components {}]
                      ;; Directories
                      (each [directory directories]
                        ;; Directory name
                        (table.insert components {:provider directory
                                                  :hl       {:fg colors.blue}})
                        ;; Directory separator
                        (table.insert components {:provider " / "
                                                  :hl       {:fg colors.orange}}))
                      ;; File Icon
                      (table.insert components {:provider (fn [self]
                                                            (and icon
                                                                 (.. icon " ")))
                                                :hl       {:fg icon_color}})
                      ;; File Name
                      (table.insert components {:provider (fn [self]
                                                            filename)
                                                :hl       {:fg icon_color}})
                      (tset self 1 (self:new components 1))))
       :condition (fn [self]
                    (not= (vim.api.nvim_buf_get_name 0) ""))}

      ;; Relative Path
      RelativePath
      (utils.insert
        RelativePath
        (unpack [{:provider (fn [self]
                              (string.gsub (.. self.path :/) "/" " / "))
                  :hl       {:fg colors.blue}}
                 {:provider (fn [self]
                              (and self.icon
                                   (.. self.icon " ")))
                  :hl       (fn [self]
                              {:fg self.icon_color})}
                 {:provider (fn [self]
                              self.filename)
                  :hl       {:fg colors.orange}}]))

      ;; Separator
      Separator
      {:condition (fn [self]
                     (and
                       (RelativePath.condition)
                       (= (Navic.condition)
                          NavicNonemptyIndicator)))
       :update    [:CursorMoved
                   :CursorMovedI]
       :provider  " >=> "
       :hl        {:fg colors.red}}

      ;; TODO: clickable directories (open) and code places (jump)

      ;; Location
      Location
      [RelativePath
       Separator
       {:fallthrough false
        :flexible 3
        1 (unpack
            [Navic
             {:provider "⋯"}])}]]

  {: Location})
