(fn after []
  (let [octo (require :octo)
        dk (require :def-keymaps)
        opt {;; use local files on right side of reviews
             :use_local_fs false
             ;; shows a list of builtin actions when no action is provided
             :enable_builtin false
             ;; order to try remotes
             :default_remote ["upstream" "origin"]
             ;; default merge method which should be used when calling `Octo pr merge`, could be `commit`, `rebase` or `squash`
             :default_merge_method "commit"
             ;; SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
             :ssh_aliases {}
             ;; or "fzf-lua"
             :picker "telescope"
             :picker_config
               {;; only used by "fzf-lua" picker for now
                :use_emojis false
                 ;; mappings for the pickers
                :mappings
                  {:open_in_browser {:lhs "<C-b>" :desc "open issue in browser"}
                   :copy_url {:lhs "<C-y>" :desc "copy url to system clipboard"}
                   :checkout_pr {:lhs "<C-o>" :desc "checkout pull request"}
                   :merge_pr {:lhs "<C-r>" :desc "merge pull request"}}}
             ;; comment marker
             :comment_icon "▎"
             ;; outdated indicator
             :outdated_icon "󰅒 "
             ;; resolved indicator
             :resolved_icon " "
             ;; marker for user reactions
             :reaction_viewer_hint_icon " "
             ;; user icon
             :user_icon " "
             ;; timeline marker
             :timeline_marker " "
             ;; timeline indentation
             :timeline_indent 2
             ;; bubble delimiter
             :right_bubble_delimiter ""
             ;; bubble delimiter
             :left_bubble_delimiter ""
             ;; GitHub Enterprise host
             :github_hostname ""
             ;; number or lines around commented lines
             :snippet_context_lines 4
             ;; Command to use when calling Github CLI
             :gh_cmd "gh"
             ;; extra environment variables to pass on to GitHub CLI, can be a table or function returning a table
             :gh_env {}
             ;; timeout for requests between the remote server
             :timeout 5000
             ;; use projects v2 for the `Octo card ...` command by default. Both legacy and v2 commands are available under `Octo cardlegacy ...` and `Octo cardv2 ...` respectively.
             :default_to_projects_v2 false
             ;; show "modified" marks on the sign column
             :ui {:use_signcolumn true}
             :issues
               {;; criteria to sort results of `Octo issue list`
                :order_by
                  {;; either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
                   :field "CREATED_AT"
                   ;; either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
                   :direction "DESC"}}
             :pull_requests
               {;; criteria to sort the results of `Octo pr list`
                :order_by
                  {;; either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
                   :field "CREATED_AT"
                   ;; either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
                   :direction "DESC"}
                ;; always give prompt to select base remote repo when creating PRs
                :always_select_remote_on_create false}
             :file_panel
               {;; changed files panel rows
                :size 10
                ;; use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
                :use_icons true}
             ;; used for highlight groups (see Colors section below)
             :colors
               {:white "#ffffff"
                :grey "#2A354C"
                :black "#000000"
                :red "#fdb8c0"
                :dark_red "#da3633"
                :green "#acf2bd"
                :dark_green "#238636"
                :yellow "#d3c846"
                :dark_yellow "#735c0f"
                :blue "#58A6FF"
                :dark_blue "#0366d6"
                :purple "#6f42c1"}
             ;; disable default mappings if true, but will still adapt user mappings
             :mappings_disable_default false
             :mappings
               {:issue
                  {:close_issue {:lhs "<localleader>ic" :desc "close issue"}
                   :reopen_issue {:lhs "<localleader>io" :desc "reopen issue"}
                   :list_issues {:lhs "<localleader>il" :desc "list open issues on same repo"}
                   :reload {:lhs "<C-r>" :desc "reload issue"}
                   :open_in_browser {:lhs "<C-b>" :desc "open issue in browser"}
                   :copy_url {:lhs "<C-y>" :desc "copy url to system clipboard"}
                   :add_assignee {:lhs "<localleader>aa" :desc "add assignee"}
                   :remove_assignee {:lhs "<localleader>ad" :desc "remove assignee"}
                   :create_label {:lhs "<localleader>lc" :desc "create label"}
                   :add_label {:lhs "<localleader>la" :desc "add label"}
                   :remove_label {:lhs "<localleader>ld" :desc "remove label"}
                   :goto_issue {:lhs "<localleader>gi" :desc "navigate to a local repo issue"}
                   :add_comment {:lhs "<localleader>ca" :desc "add comment"}
                   :delete_comment {:lhs "<localleader>cd" :desc "delete comment"}
                   :next_comment {:lhs "]c" :desc "go to next comment"}
                   :prev_comment {:lhs "[c" :desc "go to previous comment"}
                   :react_hooray {:lhs "<localleader>rp" :desc "add/remove 🎉 reaction"}
                   :react_heart {:lhs "<localleader>rh" :desc "add/remove ❤️ reaction"}
                   :react_eyes {:lhs "<localleader>re" :desc "add/remove 👀 reaction"}
                   :react_thumbs_up {:lhs "<localleader>r+" :desc "add/remove 👍 reaction"}
                   :react_thumbs_down {:lhs "<localleader>r-" :desc "add/remove 👎 reaction"}
                   :react_rocket {:lhs "<localleader>rr" :desc "add/remove 🚀 reaction"}
                   :react_laugh {:lhs "<localleader>rl" :desc "add/remove 😄 reaction"}
                   :react_confused {:lhs "<localleader>rc" :desc "add/remove 😕 reaction"}}
                :pull_request
                  {:checkout_pr {:lhs "<localleader>po" :desc "checkout PR"}
                   :merge_pr {:lhs "<localleader>pm" :desc "merge commit PR"}
                   :squash_and_merge_pr {:lhs "<localleader>psm" :desc "squash and merge PR"}
                   :rebase_and_merge_pr {:lhs "<localleader>prm" :desc "rebase and merge PR"}
                   :list_commits {:lhs "<localleader>pc" :desc "list PR commits"}
                   :list_changed_files {:lhs "<localleader>pf" :desc "list PR changed files"}
                   :show_pr_diff {:lhs "<localleader>pd" :desc "show PR diff"}
                   :add_reviewer {:lhs "<localleader>va" :desc "add reviewer"}
                   :remove_reviewer {:lhs "<localleader>vd" :desc "remove reviewer request"}
                   :close_issue {:lhs "<localleader>ic" :desc "close PR"}
                   :reopen_issue {:lhs "<localleader>io" :desc "reopen PR"}
                   :list_issues {:lhs "<localleader>il" :desc "list open issues on same repo"}
                   :reload {:lhs "<C-r>" :desc "reload PR"}
                   :open_in_browser {:lhs "<C-b>" :desc "open PR in browser"}
                   :copy_url {:lhs "<C-y>" :desc "copy url to system clipboard"}
                   :goto_file {:lhs "gf" :desc "go to file"}
                   :add_assignee {:lhs "<localleader>aa" :desc "add assignee"}
                   :remove_assignee {:lhs "<localleader>ad" :desc "remove assignee"}
                   :create_label {:lhs "<localleader>lc" :desc "create label"}
                   :add_label {:lhs "<localleader>la" :desc "add label"}
                   :remove_label {:lhs "<localleader>ld" :desc "remove label"}
                   :goto_issue {:lhs "<localleader>gi" :desc "navigate to a local repo issue"}
                   :add_comment {:lhs "<localleader>ca" :desc "add comment"}
                   :delete_comment {:lhs "<localleader>cd" :desc "delete comment"}
                   :next_comment {:lhs "]c" :desc "go to next comment"}
                   :prev_comment {:lhs "[c" :desc "go to previous comment"}
                   :react_hooray {:lhs "<localleader>rp" :desc "add/remove 🎉 reaction"}
                   :react_heart {:lhs "<localleader>rh" :desc "add/remove ❤️ reaction"}
                   :react_eyes {:lhs "<localleader>re" :desc "add/remove 👀 reaction"}
                   :react_thumbs_up {:lhs "<localleader>r+" :desc "add/remove 👍 reaction"}
                   :react_thumbs_down {:lhs "<localleader>r-" :desc "add/remove 👎 reaction"}
                   :react_rocket {:lhs "<localleader>rr" :desc "add/remove 🚀 reaction"}
                   :react_laugh {:lhs "<localleader>rl" :desc "add/remove 😄 reaction"}
                   :react_confused {:lhs "<localleader>rc" :desc "add/remove 😕 reaction"}
                   :review_start {:lhs "<localleader>vs" :desc "start a review for the current PR"}
                   :review_resume {:lhs "<localleader>vr" :desc "resume a pending review for the current PR"}}
                :review_thread
                  {:goto_issue {:lhs "<localleader>gi" :desc "navigate to a local repo issue"}
                   :add_comment {:lhs "<localleader>ca" :desc "add comment"}
                   :add_suggestion {:lhs "<localleader>sa" :desc "add suggestion"}
                   :delete_comment {:lhs "<localleader>cd" :desc "delete comment"}
                   :next_comment {:lhs "]c" :desc "go to next comment"}
                   :prev_comment {:lhs "[c" :desc "go to previous comment"}
                   :select_next_entry {:lhs "]q" :desc "move to previous changed file"}
                   :select_prev_entry {:lhs "[q" :desc "move to next changed file"}
                   :select_first_entry {:lhs "[Q" :desc "move to first changed file"}
                   :select_last_entry {:lhs "]Q" :desc "move to last changed file"}
                   :close_review_tab {:lhs "<C-c>" :desc "close review tab"}
                   :react_hooray {:lhs "<localleader>rp" :desc "add/remove 🎉 reaction"}
                   :react_heart {:lhs "<localleader>rh" :desc "add/remove ❤️ reaction"}
                   :react_eyes {:lhs "<localleader>re" :desc "add/remove 👀 reaction"}
                   :react_thumbs_up {:lhs "<localleader>r+" :desc "add/remove 👍 reaction"}
                   :react_thumbs_down {:lhs "<localleader>r-" :desc "add/remove 👎 reaction"}
                   :react_rocket {:lhs "<localleader>rr" :desc "add/remove 🚀 reaction"}
                   :react_laugh {:lhs "<localleader>rl" :desc "add/remove 😄 reaction"}
                   :react_confused {:lhs "<localleader>rc" :desc "add/remove 😕 reaction"}}
                :submit_win
                  {:approve_review {:lhs "<C-a>" :desc "approve review"}
                   :comment_review {:lhs "<C-m>" :desc "comment review"}
                   :request_changes {:lhs "<C-r>" :desc "request changes review"}
                   :close_review_tab {:lhs "<C-c>" :desc "close review tab"}}
                :review_diff
                  {:submit_review {:lhs "<localleader>vs" :desc "submit review"}
                   :discard_review {:lhs "<localleader>vd" :desc "discard review"}
                   :add_review_comment {:lhs "<localleader>ca" :desc "add a new review comment"}
                   :add_review_suggestion {:lhs "<localleader>sa" :desc "add a new review suggestion"}
                   :focus_files {:lhs "<localleader>e" :desc "move focus to changed file panel"}
                   :toggle_files {:lhs "<localleader>b" :desc "hide/show changed files panel"}
                   :next_thread {:lhs "]t" :desc "move to next thread"}
                   :prev_thread {:lhs "[t" :desc "move to previous thread"}
                   :select_next_entry {:lhs "]q" :desc "move to previous changed file"}
                   :select_prev_entry {:lhs "[q" :desc "move to next changed file"}
                   :select_first_entry {:lhs "[Q" :desc "move to first changed file"}
                   :select_last_entry {:lhs "]Q" :desc "move to last changed file"}
                   :close_review_tab {:lhs "<C-c>" :desc "close review tab"}
                   :toggle_viewed {:lhs "<localleader><localleader>" :desc "toggle viewer viewed state"}
                   :goto_file {:lhs "gf" :desc "go to file"}}
                :file_panel
                  {:submit_review {:lhs "<localleader>vs" :desc "submit review"}
                   :discard_review {:lhs "<localleader>vd" :desc "discard review"}
                   :next_entry {:lhs "j" :desc "move to next changed file"}
                   :prev_entry {:lhs "k" :desc "move to previous changed file"}
                   :select_entry {:lhs "<cr>" :desc "show selected changed file diffs"}
                   :refresh_files {:lhs "R" :desc "refresh changed files panel"}
                   :focus_files {:lhs "<localleader>e" :desc "move focus to changed file panel"}
                   :toggle_files {:lhs "<localleader>b" :desc "hide/show changed files panel"}
                   :select_next_entry {:lhs "]q" :desc "move to previous changed file"}
                   :select_prev_entry {:lhs "[q" :desc "move to next changed file"}
                   :select_first_entry {:lhs "[Q" :desc "move to first changed file"}
                   :select_last_entry {:lhs "]Q" :desc "move to last changed file"}
                   :close_review_tab {:lhs "<C-c>" :desc "close review tab"}
                   :toggle_viewed {:lhs "<localleader><localleader>" :desc "toggle viewer viewed state"}}}
              :suppress_missing_scope
               {:projects_v2 true}}]
    (octo.setup opt)

    (vim.treesitter.language.register :markdown :octo)

    (dk :n
        {}
        {:prefix :<localleader>})))

{:src "https://github.com/pwntester/octo.nvim"
 :data {:dependencies [:nvim-lua/plenary.nvim
                       :nvim-telescope/telescope.nvim
                       ;; OR :ibhagwan/fzf-lua
                       :nvim-tree/nvim-web-devicons]
        : after
        :cmd [:Octo]
        :enabled (= (vim.fn.executable :gh) 1)}}
