{:cmd [:pylsp]
 :filetypes [:python]
 :root_markers [:pyproject.toml
                :setup.py
                :setup.cfg
                :requirements.txt
                :Pipfile
                :pyrightconfig.json]
 :settings {:python {:analysis {:autoSearchPaths true
                                :useLibraryCodeForTypes true
                                :diagnosticMode :workspace}}}
 :single_file_support true}
