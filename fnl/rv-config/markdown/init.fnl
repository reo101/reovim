(fn config []
  (let [markdown (require :render-markdown)
        dk (require :def-keymaps)
        opt {:heading
               {:sign false}
             :code
               {:sign false
                :width :block}
             :win_options
               {:conceallevel
                 {:default (vim.api.nvim_get_option_value :conceallevel {})
                  :rendered 2}
                :concealcursor
                 {:default (vim.api.nvim_get_option_value :concealcursor {})
                  :rendered ""}}}]
    (markdown.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{;; 1 :MeanderingProgrammer/markdown.nvim
 1 :scottmckendry/markdown.nvim
 :dependencies ["nvim-treesitter/nvim-treesitter"
                "nvim-tree/nvim-web-devicons"]
 ;; :tag :v5.0.0
 :event :VeryLazy
 : config}
