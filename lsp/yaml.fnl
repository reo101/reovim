{:cmd [:yaml-language-server
       :--stdio]
 :filetypes [:yaml
             :yaml.docker-compose]
 :root_markers [:.git]
 :single_file_support true
 :settings {:redhat {:telemetry {:enabled false}}
            :yaml {:schemas {:https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json "/.gitlab-ci.yml"}}}}
