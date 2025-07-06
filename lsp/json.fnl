{:cmd [:vscode-json-language-server
       :--stdio]
 :filetypes [:json
             :jsonc]
 :root_markers [:.git]
 :init_options {:provideFormatter true}
 :settings {:json {:schemas ((. (require :schemastore) :json :schemas))}}
 :single_file_support true}
