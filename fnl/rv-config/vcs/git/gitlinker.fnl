(fn after []
  (let [dk (require :def-keymaps)
        gitlinker (require :gitlinker)
        gitlinker-actions (require :gitlinker.actions)
        gitlinker-hosts (require :gitlinker.hosts)
        opt {:callbacks {:bitbucket.org        gitlinker-hosts.get_bitbucket_type_url
                         :codeberg.org         gitlinker-hosts.get_gitea_type_url
                         :git.kernel.org       gitlinker-hosts.get_cgit_type_url
                         :git.launchpad.net    gitlinker-hosts.get_launchpad_type_url
                         :git.savannah.gnu.org gitlinker-hosts.get_cgit_type_url
                         :git.sr.ht            gitlinker-hosts.get_srht_type_url
                         :github.com           gitlinker-hosts.get_github_type_url
                         :gitlab.com           gitlinker-hosts.get_gitlab_type_url
                         :repo.or.cz           gitlinker-hosts.get_repoorcz_type_url
                         :try.gitea.io         gitlinker-hosts.get_gitea_type_url
                         :try.gogs.io          gitlinker-hosts.get_gogs_type_url}
             :mappings nil
             :opts {:action_callback gitlinker-actions.copy_to_clipboard
                    :add_current_line_on_normal_mode true
                    :print_url true
                    :remote nil}}]
    (gitlinker.setup opt)
    (each [_ mode (ipairs [:n :v])]
      (dk mode
          {:g {:group :Git
               :b [#(gitlinker.get_buf_range_url
                       {:action_callback gitlinker-actions.open_in_browser})
                   :Browse]}}
          {:prefix :<leader>}))))

{:src "https://github.com/ruifm/gitlinker.nvim"
 :data {:keys [:<leader>gb]
        : after}}
