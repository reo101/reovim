(let [{: conditions
       : colors}
      (require :rv-config.heirline.common)

      ;; Diagnostics
      Diagnostics
      (vim.tbl_extend "error"
        {:init      (fn [self]
                      ;; TODO: macro this V
                      (set self.errors
                           (length (vim.diagnostic.get
                                     0
                                     {:severity vim.diagnostic.severity.ERROR})))
                      (set self.warnings
                           (length (vim.diagnostic.get
                                     0
                                     {:severity vim.diagnostic.severity.WARN})))
                      (set self.hints
                           (length (vim.diagnostic.get
                                     0
                                     {:severity vim.diagnostic.severity.HINT})))
                      (set self.info
                           (length (vim.diagnostic.get
                                     0
                                     {:severity vim.diagnostic.severity.INFO}))))
         :update    [:DiagnosticChanged
                     :BufEnter]
         :condition conditions.has_diagnostics
         ;; TODO: macro this V
         :static    {:error_icon (?. (vim.fn.sign_getdefined :DiagnosticSignError)
                                     1
                                     :text)
                     :info_icon  (?. (vim.fn.sign_getdefined :DiagnosticSignInfo)
                                     1
                                     :text)
                     :hint_icon  (?. (vim.fn.sign_getdefined :DiagnosticSignHint)
                                     1
                                     :text)
                     :warn_icon  (?. (vim.fn.sign_getdefined :DiagnosticSignWarn)
                                     1
                                     :text)}}
        ;; TODO: macro this V
        [{:provider "!["}
         {:condition (fn [self]
                       (> self.errors 0))
          1 {:provider (fn [self]
                         self.error_icon)}
          2 {:provider (fn [self]
                         (.. self.errors " "))}
          :hl       {:fg colors.diag.error}}
         {:condition (fn [self]
                       (> self.warnings 0))
          1 {:provider (fn [self]
                         self.warn_icon)}
          2 {:provider (fn [self]
                         (.. self.warnings " "))}
          :hl       {:fg colors.diag.warn}}
         {:condition (fn [self]
                       (> self.info 0))
          1 {:provider (fn [self]
                         self.info_icon)}
          2 {:provider (fn [self]
                         (.. self.warnings " "))}
          :hl       {:fg colors.diag.info}}
         {:condition (fn [self]
                       (> self.hints 0))
          1 {:provider (fn [self]
                         self.hint_icon)}
          2 {:provider (fn [self]
                         (.. self.hints " "))}
          :hl       {:fg colors.diag.hint}}
         {:provider "]"}])]

  {: Diagnostics})
