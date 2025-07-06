;; Nix lockfile update helper - concurrent version
;; Provides :NixUpdateLock command to update sha256 hashes in nvim-pack-lock.json
;; Uses vim.system() (Neovim 0.10+) with a worker pool for concurrent prefetching

;; Default concurrency - fetch this many plugins in parallel
(local DEFAULT-CONCURRENCY 8)

;; Progress notification interval (notify every N completions)
(local PROGRESS-INTERVAL 10)

;; Supported git hosts registry
;; Each entry defines how to parse SSH/HTTPS URLs and generate archive URLs
;; :patterns - vector of [regex owner-idx repo-idx] for extracting from URL
;; :archive-fn - receives owner repo rev, returns tarball URL
(local HOSTS
  {:github.com
    {:patterns
      [["^git@github.com:([^/]+)/([^/]+)$" 1 2]
       ["^https://github.com/([^/]+)/([^/]+)" 1 2]]
     :archive-fn #(.. "https://github.com/" $1 "/" $2 "/archive/" $3 ".tar.gz")}
   :git.sr.ht
    {:patterns
      [["^git@git.sr.ht:~([^/]+)/([^/]+)$" 1 2]
       ["^https://git.sr.ht/~([^/]+)/([^/]+)" 1 2]]
     :archive-fn #(.. "https://git.sr.ht/~" $1 "/" $2 "/archive/" $3 ".tar.gz")}})

(fn parse-url [src]
  "Parse git URL into {:host :owner :repo} or nil if not a supported remote"
  (when src
    (-> HOSTS
        vim.iter
        (: :map (fn [host-name host]
                  (-> host.patterns
                      vim.iter
                      (: :map (fn [pattern]
                                (let [(owner repo) (src:match (. pattern 1))]
                                  (when owner
                                    {:host host-name : owner : repo}))))
                      (: :find #$1))))
        (: :find #$1))))

(fn archive-url [parsed-url rev]
  "Generate tarball URL from parsed URL and revision"
  (let [{: host : owner : repo} parsed-url
        host-config (. HOSTS host)]
    (when host-config
      (host-config.archive-fn owner repo rev))))

(fn needs-prefetch? [src])
"Check if source URL needs nix prefetch (remote git vs local path)"
(let [has-src? (not= src nil)
      not-absolute? (if src (not (src:match "^/")) false)
      not-relative? (if src (not (src:match "^%.")) false)
      parsed (if src (parse-url src) nil)]
  (and has-src? not-absolute? not-relative? parsed))

(fn extract-hash [output]
  "Extract sha256 hash from nix-prefetch-url output"
  ;; nix-prefetch-url outputs the base32 hash on stdout, but there may be
  ;; trailing newlines. Find first non-empty line instead of last line.
  (var result nil)
  (each [line (vim.gsplit output "\n")]
    (when (not result)
      (let [hash (line:match "^%s*(%S+)%s*$")]
        (when (and hash (> (length hash) 0))
          (set result hash)))))
  result)

(fn convert-to-sri [base32-hash callback]
  "Convert base32 hash to SRI format using nix hash to-sri"
  (vim.system
    [:nix :hash :convert :--hash-algo :sha256 :--to :sri base32-hash]
    {:text true}
    (fn [obj]
      (vim.schedule
        (fn []
          (if (not= obj.code 0)
              (callback false nil {:reason :sri-convert-failed :stderr obj.stderr})
              (let [sri-hash (-> obj.stdout (: :gsub "^%s*" "") (: :gsub "%s*$" ""))]
                (callback true sri-hash))))))))

(fn run-nix-prefetch [src rev callback]
  "Run nix-prefetch-url to get sha256 hash using vim.system()"
  (let [parsed (parse-url src)
        url (archive-url parsed rev)]
    (if (not url)
        (vim.schedule #(callback false nil {:reason :unsupported-host :src src}))
        (vim.system
          [:nix-prefetch-url :--unpack url]
          {:text true}
          (fn [obj]
            (vim.schedule
              (fn []
                (if (not= obj.code 0)
                    (callback false nil {:code obj.code :stderr obj.stderr})
                    (let [base32-hash (extract-hash obj.stdout)]
                      (if (not base32-hash)
                          (callback false nil {:reason :parse-failed :stdout obj.stdout})
                          (convert-to-sri base32-hash callback)))))))))))

(fn update-plugin-hash [plugin entry callback]
  "Get sha256 for a single plugin"
  (let [src entry.src
        rev entry.rev]
    (if (not src)
        (vim.schedule #(callback false nil {:reason :no-src :plugin plugin}))
        (not rev)
        (vim.schedule #(callback false nil {:reason :no-rev :plugin plugin}))
        (run-nix-prefetch src rev callback))))

(fn run-concurrent [items concurrency per-item done-all]
  "Run items concurrently with limited concurrency (worker pool pattern)"
  (var idx 1)
  (var in-flight 0)
  (var finished 0)
  (let [total (length items)]

    (fn maybe-start-more []
      (while (and (<= idx total) (< in-flight concurrency))
        (let [item (. items idx)
              item-idx idx]
          (set idx (+ idx 1))
          (set in-flight (+ in-flight 1))
          (per-item item
            (fn [success ?hash ?err]
              ;; Item complete - call completion handler
              (per-item :complete item-idx success ?hash ?err)
              ;; Update counters and check if done
              (set in-flight (- in-flight 1))
              (set finished (+ finished 1))
              (if (= finished total)
                  (done-all)
                  (maybe-start-more)))))))

    ;; Start initial batch
    (maybe-start-more)))

(fn update-plugin-hashes [lockfile plugins-to-update concurrency callback]
  "Update hashes for specific plugins in the lockfile. Calls callback with results when done."
  (let [total (length plugins-to-update)
        collected-hashes {}
        failures []]

    (var updated 0)
    (var failed 0)

    (vim.notify (.. "Updating " total " plugin hashes with concurrency " concurrency "...") vim.log.levels.INFO)

    ;; Progress notification helper (throttled)
    (fn notify-progress []
      (let [completed (+ updated failed)]
        (when (or (= completed total)
                  (= 0 (% completed PROGRESS-INTERVAL)))
          (vim.notify (.. "Progress: " completed "/" total " (ok=" updated " fail=" failed ")") vim.log.levels.INFO))))

    ;; Handle case where there are no items to update
    (if (= total 0)
        (vim.schedule #(callback {:updated 0 :failed 0 :collected-hashes {} :failures []}))
        ;; Run concurrent worker pool
        (run-concurrent
          plugins-to-update
          concurrency
          ;; Per-item handler
          (fn [item-or-signal ...]
            (if (= item-or-signal :complete)
                ;; Completion signal: item-idx success ?hash ?err
                (let [(item-idx success hash err) ...]
                  (if success
                      (do
                        (set updated (+ updated 1))
                        (let [{: plugin} (. plugins-to-update item-idx)]
                          (tset collected-hashes plugin hash)))
                      (do
                        (set failed (+ failed 1))
                        (let [{: plugin} (. plugins-to-update item-idx)]
                          (table.insert failures {:plugin plugin :err err})
                          ;; Notify failures immediately
                          (vim.notify (.. "Failed: " plugin) vim.log.levels.WARN))))
                  (notify-progress))
                ;; Start signal: process the item
                (let [{: plugin : entry} item-or-signal
                      done-callback (select 1 ...)]
                  (update-plugin-hash plugin entry done-callback))))
          ;; Done-all handler - call the callback with results
          (fn []
            ;; Apply all collected hashes to lockfile
            (each [plugin hash (pairs collected-hashes)]
              (when (?. lockfile :plugins plugin)
                (tset (. lockfile.plugins plugin) :sha256 hash)))
            ;; Call callback with results
            (callback {:updated updated
                       :failed failed
                       :collected-hashes collected-hashes
                       :failures failures}))))))

(fn update-parsers-from-treesitter [lockfile concurrency callback]
  "Extract parsers from treesitter/init.fnl and add them to lockfile. Calls callback with results when done."
  ;; Try multiple ways to get the custom grammars
  (var custom-grammars nil)

  ;; Method 1: Try the global set by treesitter's after() function
  (when _G.reovim/treesitter-grammars
    (set custom-grammars _G.reovim/treesitter-grammars))

  ;; Method 2: Try _G.custom-grammars (alternate export)
  (when (and (not custom-grammars) _G.custom-grammars)
    (set custom-grammars _G.custom-grammars))

  ;; Method 3: Try to get from module return (if it exports them)
  (when (not custom-grammars)
    (let [(ok ts-module) (pcall require :rv-config.treesitter)]
      (when ok
        (when ts-module.custom-grammars
          (set custom-grammars ts-module.custom-grammars))
        ;; Module returns a list, check if any item has the grammars
        (when (and (not custom-grammars) (vim.islist ts-module))
          (each [_ item (ipairs ts-module)]
            (when (and (not custom-grammars) item.custom-grammars)
              (set custom-grammars item.custom-grammars)))))))

  ;; Default to empty if nothing found
  (when (not custom-grammars)
    (set custom-grammars {}))

  (var added 0)
  (var updated 0)
  (local parsers-to-build [])

  ;; Ensure grammars section exists
  (when (not lockfile.grammars)
    (tset lockfile :grammars {}))

  ;; Find parsers that need to be added or updated
  (each [lang cfg (pairs custom-grammars)]
    (let [info (or cfg.install_info {})
          grammar-name (.. "tree-sitter-" lang)
          existing (?. lockfile :grammars grammar-name)
          current-rev (or info.revision (.. "refs/heads/" (or info.branch "master")))]

      (if (not existing)
          ;; New parser - add to lockfile grammars section
          (do
            (set added (+ added 1))
            (tset lockfile.grammars grammar-name
                  {:src info.url
                   :rev current-rev
                   :files info.files})
            ;; Only add to parsers-to-build if it can be prefetched (not local path)
            (when (needs-prefetch? info.url)
              (table.insert parsers-to-build {:plugin grammar-name
                                              :entry (. lockfile.grammars grammar-name)})))
          ;; Existing parser - check if rev changed (needs update)
          (let [rev-changed? (and existing.rev (not= existing.rev current-rev))
                needs-hash? (not existing.sha256)
                needs-update (and rev-changed? needs-hash? (needs-prefetch? info.url))]
            (when needs-update
              (set updated (+ updated 1))
              (tset existing :src info.url) ;; Update src to new URL from config
              (tset existing :rev current-rev)
              (tset existing :sha256 nil) ;; Clear hash to trigger re-fetch
              (tset existing :files info.files) ;; Update files from config
              (table.insert parsers-to-build {:plugin grammar-name
                                              :entry existing}))))))

  (if (= (length parsers-to-build) 0)
      ;; No parsers to build - call callback immediately with empty results
      (do
        (vim.notify (.. "Parsers: " added " added, " updated " need update (all have hashes)") vim.log.levels.INFO)
        (callback {:added added :updated updated :built 0 :failed 0}))
      ;; Have parsers to build - call update-plugin-hashes with callback
      (do
        (vim.notify (.. "Parsers: " added " added, " updated " need hash update, building " (length parsers-to-build) "...") vim.log.levels.INFO)
        (update-plugin-hashes
          lockfile
          parsers-to-build
          concurrency
          (fn [result]
            ;; Apply results to lockfile grammars section
            (each [grammar-name hash (pairs result.collected-hashes)]
              (when (?. lockfile :grammars grammar-name)
                (tset (. lockfile.grammars grammar-name) :sha256 hash)))
            ;; Call callback with final results
            (callback {:added added :updated updated :built result.updated :failed result.failed}))))))

(fn update-all-hashes [?mode ?concurrency]
  "Update all plugin and/or parser hashes in lockfile concurrently
   Mode: 'plugins' | 'parsers' | 'both' (default)"
  (let [mode (or ?mode :both)
        concurrency (or ?concurrency DEFAULT-CONCURRENCY)]

      ;; Validate mode
      (when (not (or (= mode :plugins) (= mode :parsers) (= mode :both)))
        (vim.notify (.. "Invalid mode: " mode ". Use: plugins, parsers, or both") vim.log.levels.ERROR)
        (lua :return))

      ;; Early check for nix-prefetch-url
      (when (= (vim.fn.executable :nix-prefetch-url) 0)
        (vim.notify "nix-prefetch-url not found in PATH. It should be available in any Nix installation." vim.log.levels.ERROR)
        (lua :return))

      (let [config-dir (vim.fn.stdpath :config)
            lockfile-path (.. config-dir :/nvim-pack-lock.json)
            lockfile-content (table.concat (vim.fn.readfile lockfile-path) "\n")
            lockfile (vim.json.decode lockfile-content)
            plugins-without-hash []
            ;; Track overall results
            results {:plugins {:updated 0 :failed 0 :total 0}
                     :parsers {:added 0 :updated 0 :built 0 :failed 0}}]

        ;; Collect plugins that need updating (synchronous prep)
        (when (or (= mode :plugins) (= mode :both))
          (each [plugin entry (pairs lockfile.plugins)]
            (let [has-sha? (not (not entry.sha256))
                  needs-prefetch (needs-prefetch? entry.src)
                  is-grammar? (plugin:match "^tree%-sitter%-")
                  should-skip-grammar? (and (= mode :both) is-grammar?)]
              (when (and (not has-sha?) needs-prefetch (not should-skip-grammar?))
                (table.insert plugins-without-hash {:plugin plugin :entry entry}))))
          (tset results.plugins :total (length plugins-without-hash)))

        ;; Helper to finalize and write results
        (fn finalize-and-write []
          ;; Write lockfile if changes were made
          (when (or (> results.plugins.updated 0)
                    (> results.parsers.added 0)
                    (> results.parsers.built 0)
                    (> results.parsers.failed 0))
            (let [encoded (vim.json.encode lockfile {:indent "  "})
                  lines (vim.split encoded "\n")]
              (vim.fn.writefile lines lockfile-path)))

          ;; Final notification
          (let [plugin-msg (if (or (= mode :plugins) (= mode :both))
                              (if (> (or results.plugins.total 0) 0)
                                  (.. "Plugins: " results.plugins.updated "/" results.plugins.total " updated"
                                      (if (> results.plugins.failed 0) (.. ", " results.plugins.failed " failed") ""))
                                  "Plugins: all up to date")
                              "")
                parser-msg (if (or (= mode :parsers) (= mode :both))
                              (if (or (> results.parsers.added 0) (> results.parsers.built 0) (> results.parsers.updated 0))
                                  (.. "Parsers: " results.parsers.added " added, " results.parsers.built " hashed"
                                      (if (> results.parsers.failed 0) (.. ", " results.parsers.failed " failed") ""))
                                  "Parsers: all up to date")
                              "")
                sep (if (and (not= plugin-msg "") (not= parser-msg "")) " | " "")
                msg (.. plugin-msg sep parser-msg)]
            (vim.notify msg (if (and (= results.plugins.failed 0) (= results.parsers.failed 0))
                              vim.log.levels.INFO
                              vim.log.levels.WARN))))

        ;; Helper to run parser update after plugins (if in :both mode)
        (fn run-parser-update-then-finalize []
          (if (or (= mode :parsers) (= mode :both))
              (update-parsers-from-treesitter
                lockfile
                concurrency
                (fn [parser-result]
                  (tset results.parsers :added parser-result.added)
                  (tset results.parsers :updated parser-result.updated)
                  (tset results.parsers :built parser-result.built)
                  (tset results.parsers :failed parser-result.failed)
                  (finalize-and-write)))
              ;; Skip parsers, just finalize
              (finalize-and-write)))

        ;; Execute based on mode
        (if (or (= mode :plugins) (= mode :both))
            ;; Need to run plugins first
            (let [total (length plugins-without-hash)]
              (if (= total 0)
                  ;; No plugins to update - skip to parsers or finalize
                  (do
                    (when (= mode :plugins)
                      (vim.notify "All plugins already have sha256 hashes" vim.log.levels.INFO))
                    (run-parser-update-then-finalize))
                  ;; Have plugins to update
                  (update-plugin-hashes
                    lockfile
                    plugins-without-hash
                    concurrency
                    (fn [plugin-result]
                      (tset results.plugins :updated plugin-result.updated)
                      (tset results.plugins :failed plugin-result.failed)
                      (run-parser-update-then-finalize)))))
            ;; Parsers only mode - skip plugins
            (run-parser-update-then-finalize)))))

;; Register user command with optional what and concurrency args
;; Usage: :NixUpdateLock [what] [concurrency]
;;   what = plugins | parsers | both (default)
;;   concurrency = number (default 8)
(vim.api.nvim_create_user_command
  :NixUpdateLock
  (fn [opts]
    (let [args (vim.split opts.args " " true)
          arg1 (. args 1)
          arg2 (. args 2)
          ;; Check if arg1 is a mode or a number (concurrency)
          is-mode (when arg1
                    (or (= arg1 "plugins") (= arg1 "parsers") (= arg1 "both")))
          ;; Determine mode and concurrency from args
          mode (if is-mode
                 (match arg1
                   "plugins" :plugins
                   "parsers" :parsers
                   "both" :both)
                 :both)  ;; Default if arg1 is a number or nil
          concurrency (or (tonumber (if is-mode arg2 arg1))
                          DEFAULT-CONCURRENCY)]
       (update-all-hashes mode concurrency)))
  {:nargs "*"
   :complete (fn [arglead cmdline _]
               ;; Count how many arguments we already have (excluding the command)
               (local args-before (->> (vim.split cmdline " " true)
                                       (length)
                                       (- 1)))  ;; Subtract 1 for command itself
               ;; If on first argument, complete modes
               (if (<= args-before 1)
                   (let [modes ["plugins" "parsers" "both"]
                         filtered (icollect [_ m (ipairs modes)]
                                    (when (vim.startswith m arglead)
                                      m))]
                     (if (> (length filtered) 0)
                         filtered
                         modes))
                   ;; If on second argument and first is a mode, suggest concurrency
                   (let [first-arg (-> cmdline
                                       (vim.split " " true)
                                       (. 2))]
                     (if (or (= first-arg "plugins") (= first-arg "parsers") (= first-arg "both"))
                         ["8" "16" "32"]
                         []))))
   :desc "Update nix hashes. Args: [plugins|parsers|both] [concurrency]"})

{: update-all-hashes
 : run-nix-prefetch
 : update-plugin-hashes
 : update-parsers-from-treesitter}
