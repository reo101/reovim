(let [{: heirline
       : conditions
       : utils
       : colors
       : gps
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-config.heirline.common)

      ;; Work-Dir
      Work-Dir
      {:provider (fn [self]
                   (local icon
                     (.. (or (and (= (vim.fn.haslocaldir 0) 1)
                                  :l)
                             :g)
                         " "
                         " "))
                   (var cwd (vim.fn.getcwd 0))
                   (set cwd (vim.fn.fnamemodify cwd ":~"))
                   (when (not (conditions.width_percent_below (length cwd)
                                                              0.25))
                     (set cwd (vim.fn.pathshorten cwd)))
                   (local trail
                     (or (and (= (cwd:sub (- 1)) "/") "") "/"))
                   (.. icon cwd trail))
       :hl       {:fg   colors.blue
                  :bold true}}

      ;; Flexible Work-Dir
      Work-Dir-Flexible
      {:flexible 1
       1 (unpack [;; evaluates to the full-lenth path
                  {:provider (fn [self]
                               (local trail
                                 (or (and (= (self.cwd:sub (- 1))
                                             "/")
                                          "")
                                     "/"))
                               (.. self.icon self.cwd trail " "))}
                  ;; evaluates to the shortened path
                  {:provider (fn [self]
                               (local cwd
                                 (vim.fn.pathshorten self.cwd))
                               (local trail
                                 (or (and (= (self.cwd:sub (- 1))
                                             "/")
                                          "")
                                     "/"))
                               (.. self.icon cwd trail " "))}
                  ;; evaluates to "", hiding the component
                  {:provider ""}])}]

  {: Work-Dir})
