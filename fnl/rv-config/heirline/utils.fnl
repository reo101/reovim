(let [{: heirline
       : conditions
       : utils
       : colors
       : navic
       : icons}
      (require :rv-config.heirline.common)

      {: Space}
      (require :rv-config.heirline.components.align)

      ;; Header Bubble
      header-bubble
      (fn [delimiters colours header body]
       (let [left-delim   (. delimiters 1)
             middle-delim (. delimiters 2)
             right-delim  (or (. delimiters 3)
                              middle-delim)
             colours (if (= (type colours) :function)
                         (colours)
                         ;; else
                         colours)
             header (vim.tbl_deep_extend "force" header {})
             body   (vim.tbl_deep_extend "force" body   {})]

         [;;  -><-  master 
          {:hl (fn [self]
                 (let [header-bg (. colours :header :bg)]
                   {:fg header-bg}))
           :provider left-delim}
          ;;   -><-  master 
          (vim.tbl_extend
            :error
            {:hl (fn [self]
                  (let [header-bg (. colours :header :bg)
                        header-fg (. colours :header :fg)]
                    {:fg header-fg
                     :bg header-bg}))}
            [header])
          ;;   -><-  master 
          {:hl (fn [self]
                 (let [header-bg (. colours :header :bg)
                       body-bg   (. colours :body   :bg)]
                   {:fg header-bg
                    :bg body-bg}))
           :provider middle-delim}
          ;;   -> <- master 
          (vim.tbl_extend
            :error
            {:hl (fn [self]
                  (let [body-bg (. colours :body :bg)
                        body-fg (. colours :body :fg)]
                    {:fg body-fg
                     :bg body-bg}))}
            [Space])
          ;;    ->master<-  
          (vim.tbl_extend
            :error
            {:hl (fn [self]
                  (let [body-fg (. colours :body :fg)
                        body-bg (. colours :body :bg)]
                    {:fg body-fg
                     :bg body-bg}))}
            [body])
          ;; ;;   master -> <- 
          ;; (vim.tbl_extend
          ;;   :error
          ;;   {:hl (fn [self]
          ;;          (let [body-fg (. colours :body :fg)
          ;;                body-bg (. colours :body :bg)]
          ;;            {:fg body-fg
          ;;             :bg body-bg}))}
          ;;   [Space])
          ;;   master  -><-
          {:hl (fn [self]
                 (let [body-bd (. colours :body :bg)]
                   {:fg body-bd}))
           :provider right-delim}]))]

  {: header-bubble})
