(fn after []
  (let [snacks (require :snacks)
        dk (require :def-keymaps)
        opt {:gh {}}]
    (snacks.setup opt)

    (dk :n
        {:g {:group :Git
             :i [#(_G.Snacks.picker.gh_issue)
                 "GitHub Issues (open)"]
             :I [#(_G.Snacks.picker.gh_issue {:state :all})
                 "GitHub Issues (all)"]
             :p [#(_G.Snacks.picker.gh_pr)
                 "GitHub Pull Requests (open)"]
             :P [#(_G.Snacks.picker.gh_pr {:state :all})
                 "GitHub Pull Requests (all)"]}}
        {:prefix :<leader>})))

{:src "https://github.com/folke/snacks.nvim"
 :version :v2.30.0
 :data {: after}}
