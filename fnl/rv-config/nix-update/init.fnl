(fn after []
  (let [dk (require :def-keymaps)
        nix-update (require :nix-update)
        opt {:extra-prefetchers
               {}}]
               ;; {:fetchTest
               ;;  {:required-cmds [:echo]
               ;;   :required-keys [:a :b :c]
               ;;   :prefetcher
               ;;    (fn [{: a
               ;;          : b
               ;;          : c}]
               ;;      (local cmd "echo")
               ;;
               ;;      (local args ["v2.3.4"])
               ;;
               ;;      {: cmd
               ;;       : args})
               ;;   :extractor
               ;;    (fn [stdout]
               ;;      {:rev (. stdout 1)})}}}]

    (dk :n
        {:n {:group :NixUpdate
             :c [#(nix-update.prefetch_fetch) "Under cursor"]}}
        {:prefix :<leader>})

    (nix-update.setup opt)))

{:src "https://github.com/reo101/nix-update.nvim"
 :data {:ft [:nix]
        : after}}
