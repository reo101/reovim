(let [{: conditions
       : colors}
      (require :rv-config.heirline.common)

      {: header-bubble}
      (require :rv-config.heirline.utils)

      ;; bg      "#011627"
      ;; giticon "#FF8800"
      ;; gitbg   "#6ee756" ;; "#6e9256" ;; "#5C2C2E"

      ;; Git Icon
      Git-Icon
      {:provider ""}

      ;; Git Status Blob
      Git-Status-Blob
      (fn [status_dict_key colors_git_key symbol]
        {:provider (fn [self]
                     (let [count (or (. self.status_dict status_dict_key) 0)]
                       (and (> count 0)
                            (.. " " symbol " " count))))
         :hl       {:fg (. colors.git colors_git_key)}})

      ;; Git Status
      Git-Status
      (vim.tbl_extend
        :error
        {}
        [{:provider (fn [self]
                     self.status_dict.head)
          :hl       {:bold true}}
         (vim.tbl_extend
           :error
           {:condition (fn [self]
                         self.has_changes)}
           [(Git-Status-Blob :added   :add    "")
            (Git-Status-Blob :removed :del    "")
            (Git-Status-Blob :changed :change "")])])

      ;; Git
      Git
      (vim.tbl_extend
        :error
        {:condition conditions.is_git_repo
         :init      (fn [self]
                      (set self.status_dict
                           vim.b.gitsigns_status_dict)
                      (set self.has_changes
                           (or (not= self.status_dict.added   0)
                               (not= self.status_dict.removed 0)
                               (not= self.status_dict.changed 0))))}
        [(header-bubble
            ["" ""]
            {:header {:fg "#000000"
                      :bg "#FF8800"}
             :body   {:fg "#000000"
                      :bg "#ffff66"}}
            Git-Icon
            Git-Status)])]

  {: Git})
