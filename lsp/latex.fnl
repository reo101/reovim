{:cmd [:texlab]
 :filetypes [:tex
             :bib]
 :root_markers [:latexmkrc]
 :settings
  {:texlab
    {:rootDirectory "."
     :build _G.TeXMagicBuildConfig
     :forwardSearch {:executable :zathura
                     :onSave true
                     :args [:--synctex-forward
                            "%l:1:%f"
                            "%p"]}}}
 :single_file_support true}
