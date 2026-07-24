(local cmd
  (if (and vim.env.JAI_ROOT (not= vim.env.JAI_ROOT ""))
      [:jails :-jai_path vim.env.JAI_ROOT]
      [:jails]))

{:cmd cmd
 :filetypes [:jai]
 :root_markers [:jails.json
                :build.jai
                :.git]
 :single_file_support true}
