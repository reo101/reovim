(fn config []
  ;; TODO: tidy up
  (let [opt {:callbacks {:bitbucket.org (. (require :gitlinker.hosts)
                                           :get_bitbucket_type_url)
                         :codeberg.org (. (require :gitlinker.hosts)
                                          :get_gitea_type_url)
                         :git.kernel.org (. (require :gitlinker.hosts)
                                            :get_cgit_type_url)
                         :git.launchpad.net (. (require :gitlinker.hosts)
                                               :get_launchpad_type_url)
                         :git.savannah.gnu.org (. (require :gitlinker.hosts)
                                                  :get_cgit_type_url)
                         :git.sr.ht (. (require :gitlinker.hosts)
                                       :get_srht_type_url)
                         :github.com (. (require :gitlinker.hosts)
                                        :get_github_type_url)
                         :gitlab.com (. (require :gitlinker.hosts)
                                        :get_gitlab_type_url)
                         :repo.or.cz (. (require :gitlinker.hosts)
                                        :get_repoorcz_type_url)
                         :try.gitea.io (. (require :gitlinker.hosts)
                                          :get_gitea_type_url)
                         :try.gogs.io (. (require :gitlinker.hosts)
                                         :get_gogs_type_url)}
             :mappings nil
             :opts {:action_callback (. (require :gitlinker.actions)
                                        :copy_to_clipboard)
                    :add_current_line_on_normal_mode true
                    :print_url true
                    :remote nil}}]
    ((. (require :gitlinker) :setup) opt)
    (local wk (require :which-key))
    (each [_ mode (ipairs [:n :v])]
      (wk.register {:g {:b [(fn []
                              ((. (require :gitlinker)
                                  :get_buf_range_url)
                               mode
                               {:action_callback (. (require :gitlinker.actions)
                                                    :open_in_browser)}))
                            :Browse]
                        :name :Git}}
                   {: mode :prefix :<leader>}))))

{1 :ruifm/gitlinker.nvim
 :dependencies [:nvim-lua/plenary.nvim]
 :keys [:<leader>gb]
 : config}
