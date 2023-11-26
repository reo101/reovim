(let [{: conditions
       : colors}
      (require :rv-config.heirline.common)

      ;; Diagnostics
      Diagnostics
      {:init      (fn [self]
                    (each [_ severity (ipairs [:error :warning :hint :info])]
                      (tset self
                            (if (= severity :info)
                                severity
                                (.. severity :s))
                            (length
                              (vim.diagnostic.get
                                0
                                {:severity
                                  (. vim.diagnostic.severity
                                     (severity:upper))})))
                      nil))
       :update    [:DiagnosticChanged
                   :BufEnter]
       :condition conditions.has_diagnostics
       :static    (collect [_ severity (ipairs [:error :info :hint :warn])]
                    (values
                      (.. severity :_icon)
                      (?. (vim.fn.sign_getdefined
                            (.. :DiagnosticSign
                                (severity:gsub :^%l string.upper)))
                          1
                          :text)))
       1 [{:provider "!["}
          (icollect [_ [self-severity self-icon diag-color]
                     (ipairs [[:errors   :error_icon :error]
                              [:warnings :warn_icon  :warn]
                              [:info     :info_icon  :info]
                              [:hints    :hint_icon  :hint]])]
            {:condition (fn [self]
                          (> (. self self-severity) 0))
             :hl {:fg (.. :diag_ diag-color)}
             1 [{:provider (fn [self]
                             (. self self-icon))}
                {:provider (fn [self]
                             (.. (. self self-severity) " "))}]})
          {:provider "]"}]}]
        ;; [{:provider "!["}
        ;;  {:condition (fn [self]
        ;;                (vim.print self.error_icon)
        ;;                (> self.errors 0))
        ;;   1 {:provider (fn [self]
        ;;                  self.error_icon)}
        ;;   2 {:provider (fn [self]
        ;;                  (.. self.errors " "))}
        ;;   :hl       {:fg colors.diag.error}}
        ;;  {:condition (fn [self]
        ;;                (> self.warnings 0))
        ;;   1 {:provider (fn [self]
        ;;                  self.warn_icon)}
        ;;   2 {:provider (fn [self]
        ;;                  (.. self.warnings " "))}
        ;;   :hl       {:fg colors.diag.warn}}
        ;;  {:condition (fn [self]
        ;;                (> self.info 0))
        ;;   1 {:provider (fn [self]
        ;;                  self.info_icon)}
        ;;   2 {:provider (fn [self]
        ;;                  (.. self.warnings " "))}
        ;;   :hl       {:fg colors.diag.info}}
        ;;  {:condition (fn [self]
        ;;                (> self.hints 0))
        ;;   1 {:provider (fn [self]
        ;;                  self.hint_icon)}
        ;;   2 {:provider (fn [self]
        ;;                  (.. self.hints " "))}
        ;;   :hl       {:fg colors.diag.hint}}
        ;;  {:provider "]"}])]

  {: Diagnostics})
