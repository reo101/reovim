(import-macros
  {: as->}
  :init-macros)

(fn config []
  (let [ecolog (require :ecolog)
        dk (require :def-keymaps)
        opt {:integrations
               {:nvim_cmp true
                :lsp true}
             :shelter
               {:configuration
                  {:partial_mode false
                   :mask_char "*"}
                :modules
                  {:cmp true
                   :peek false
                   :files false
                   :telescope false}}
             :types true
             :path (vim.fn.getcwd)
             :preferred_environment :dev
             :providers
               [{:pattern "%(os%.getenv [:\"]%w*\"?%)?$"
                 :filetype :fennel
                 :extract_var
                   (fn [line col]
                     (-> line
                         (: :sub 1 col)
                         (: :match "%(os%.getenv [:\"]([%w_]*)$")))
                 :get_completion_trigger
                   #"%(os.getenv [:\"]%w+"}]}]
    (ecolog.setup opt)
    ;; FIXME: why do I have to do this manually?
    (as-> $ :ecolog.providers
        (require $)
        (. $ :register_many)
        ($ opt.providers))

    (let [cmp (require :cmp)
          config (cmp.get_config)]
       (table.insert
         config.sources
         {:name :ecolog})
       (cmp.setup config))

    (dk :n
        {}
        {:prefix :<leader>})))

{1 :philosofonusus/ecolog.nvim
 :dependencies [:hrsh7th/nvim-cmp]
 : config}
