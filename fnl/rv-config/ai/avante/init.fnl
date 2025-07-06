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
        :event :DeferredUIEnter
        ;;-@module "avante"
        ;;-@type avante.Config
        :dependencies
         [:nvim-lua/plenary.nvim
          :MunifTanjim/nui.nvim
          ;;; The below dependencies are optional
          ;;; for file_selector provider mini.pick
          ;; :echasnovski/mini.pick
          ;;; for file_selector provider telescope
          :nvim-telescope/telescope.nvim
          ;;; autocompletion for avante commands and mentions
          ;; :hrsh7th/nvim-cmp
          ;;; for file_selector provider fzf
          ;; :ibhagwan/fzf-lua
          ;;; for input provider dressing
          :stevearc/dressing.nvim
          ;;; for input provider snacks
          ;; :folke/snacks.nvim
          ;;; or echasnovski/mini.icons
          :nvim-tree/nvim-web-devicons
          ;;; for providers="copilot"
          :zbirenbaum/copilot.lua]}}
          ;; support for image pasting
          ;; {:src "HakonHarnes/img-clip.nvim"
          ;;   :data {:event "VeryLazy"
          ;;          :opts
          ;;           {;; recommended settings
          ;;            :default
          ;;             {:embed_image_as_base64 false
          ;;              :prompt_for_file_name false
          ;;              :drag_and_drop {:insert_mode true}
          ;;              ;; required for Windows users
          ;;              :use_absolute_path = true}}}}
          ;; ;; Make sure to set this up properly if you have lazy=true
          ;; {:src "MeanderingProgrammer/render-markdown.nvim"
          ;;  :data {:opts {:file_types ["markdown" "Avante"]}
          ;;         :ft ["markdown" "Avante"]}}]}}
