{:cmd [:bash-language-server
       :start]
 :cmd_env {:GLOB_PATTERN "*@(.sh|.inc|.bash|.command)"}
 :filetypes [:sh
             :bash
             :zsh]
 :single_file_support true}
