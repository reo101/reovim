(fn after []
  (let [avante (require :avante)
        dk (require :def-keymaps)
        opt {;; This file can contain specific instructions for your project
             :mode :agentic
             :instructions_file "avante.md"
             :input
              {:provider :native}
             ;; for example
             :provider :gemini-2.5-pro
             :providers
              {:gemini-2.5-pro
                {:__inherited_from "gemini"
                 :model "gemini-2.5-pro"}
               :gpt-5-pro
                {:__inherited_from "openai"
                 :model "gpt-5-pro"}}}]
    (avante.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{:src "https://github.com/yetone/avante.nvim"
 :version "9fe429eb62e51381b1b440b4c08256fc999e2419"
 ;; if you want to build from source then do `make BUILD_FROM_SOURCE=true`
 ;; ⚠️ must add this setting! ! !
 :data {: after
        :enabled false
        :build :make
        :event :DeferredUIEnter}}
