(fn after []
  (let [orgmode (require :orgmode)
        dk (require :def-keymaps)
        opt {:org_agenda_files "~/orgfiles/**/*"
             :org_default_notes_file "~/orgfiles/refile.orgmode"}]
    (orgmode.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{:src "https://github.com/nvim-orgmode/orgmode"
 :version :0.7.2
 :data {: after
        :ft [:org]
        :enabled false}}
