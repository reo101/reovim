{:cmd [:cmake-language-server]
 :filetypes [:cmake]
 :root_markers [:compile_commands
                :build
                :CMakeLists.txt
                :cmake]
 :init_options {:buildDirectory :build}
 :formatter {:args {}
             :exe :clang-format}
 :single_file_support true}
