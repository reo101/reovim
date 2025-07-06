;; Nix lockfile update helper - concurrent version
;; Provides :NixUpdateLock command to update sha256 hashes in nvim-pack-lock.json
;; Uses vim.system() (Neovim 0.10+) with a worker pool for concurrent prefetching

;; Default concurrency - fetch this many plugins in parallel
(local DEFAULT-CONCURRENCY 8)

;; Progress notification interval (notify every N completions)
(local PROGRESS-INTERVAL 10)

(fn normalize-url [src]
  "Convert git@ URLs to https:// and strip .git suffix"
  (let [is-github-ssh (src:match "^git@github.com:")
        is-sourcehut-ssh (src:match "^git@git.sr.ht:")
        url (if is-github-ssh
                (let [(user repo) (src:match "git@github.com:([^/]+)/([^/]+)$")]
                  (.. "https://github.com/" user "/" repo))
                is-sourcehut-ssh
                (let [(user repo) (src:match "git@git.sr.ht:~([^/]+)/([^/]+)$")]
                  (.. "https://git.sr.ht/~" user "/" repo))
                src)]
    ;; Strip .git suffix if present
    (url:gsub "%.git$" "")))

(fn parse-owner-repo [url]
  "Extract owner and repo from GitHub or Sourcehut URL"
  (let [github-owner (url:match "github.com/([^/]+)/([^/]+)$")
        sourcehut-owner (url:match "git.sr.ht/~([^/]+)/([^/]+)$")]
    (or github-owner sourcehut-owner)))

(fn make-archive-url [url rev]
  "Create tarball archive URL from git URL and rev"
  (let [(owner repo) (parse-owner-repo url)]
    (if (url:match "github.com")
        (.. "https://github.com/" owner "/" repo "/archive/" rev ".tar.gz")
        (url:match "git.sr.ht")
        (.. "https://git.sr.ht/~" owner "/" repo "/archive/" rev ".tar.gz")
        nil)))

(fn extract-hash [output]
  "Extract sha256 hash from nix-prefetch-url output"
  ;; nix-prefetch-url outputs raw base32 hash on last line
  (let [lines (vim.split output "\n")
        last-line (. lines (length lines))]
    (when last-line
      (let [hash (last-line:match "^%s*(%S+)%s*$")]
        (when (and hash (> (length hash) 0))
          hash)))))

(fn convert-to-sri [base32-hash callback]
  "Convert base32 hash to SRI format using nix hash to-sri"
  (vim.system
    [:nix :hash :convert :--hash-algo :sha256 :--to :sri base32-hash]
    {:text true}
    (fn [obj]
      (vim.schedule
        (fn []
          (if (not= obj.code 0)
              (callback false nil)
              (let [sri-hash (-> obj.stdout (: :gsub "^%s*" "") (: :gsub "%s*$" ""))]
                (callback true sri-hash nil))))))))

(fn run-nix-prefetch [src rev callback]
  "Run nix-prefetch-url to get sha256 hash using vim.system()"
  ;; Uses nix-prefetch-url --unpack to match fetchFromGitHub behavior
  (let [url (normalize-url src)
        is-github (url:match "github.com")
        is-sourcehut (url:match "git.sr.ht")
        archive-url (make-archive-url url rev)]
    (if (not archive-url)
        (vim.schedule #(callback false nil {:reason :unsupported-host
                                           :url url}))
        (vim.system
          [:nix-prefetch-url :--unpack archive-url]
          {:text true}
          (fn [obj]
            (vim.schedule
              (fn []
                (if (not= obj.code 0)
                    (callback false nil {:code obj.code :stderr obj.stderr})
                    (let [base32-hash (extract-hash obj.stdout)]
                      (if (not base32-hash)
                          (callback false nil {:reason :parse-failed
                                               :stdout obj.stdout})
                          ;; Convert base32 to SRI format
                          (convert-to-sri base32-hash callback)))))))))))

(fn update-plugin-hash [plugin entry callback]
  "Get sha256 for a single plugin"
  (let [src entry.src
        rev entry.rev]
    (run-nix-prefetch src rev callback)))

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

(fn update-all-hashes [?concurrency]
  "Update all plugin hashes in lockfile concurrently"
  (let [concurrency (or ?concurrency DEFAULT-CONCURRENCY)]

    ;; Early check for nix-prefetch-url
    (when (= (vim.fn.executable :nix-prefetch-url) 0)
      (vim.notify "nix-prefetch-url not found in PATH. It should be available in any Nix installation." vim.log.levels.ERROR)
      (lua :return))

    (let [config-dir (vim.fn.stdpath :config)
          lockfile-path (.. config-dir :/nvim-pack-lock.json)
          lockfile-content (table.concat (vim.fn.readfile lockfile-path) "\n")
          lockfile (vim.json.decode lockfile-content)
          plugins-without-hash []
          ;; Store results
          collected-hashes {}
          failures []]

      ;; Find plugins that need hashes
      (each [plugin entry (pairs lockfile.plugins)]
        (let [src entry.src]
          ;; Skip local paths and plugins that already have sha256
          (when (and (not (src:match "^/"))
                     (not (src:match "^%."))
                     (not entry.sha256))
            (table.insert plugins-without-hash {: plugin : entry}))))

      (if (= (length plugins-without-hash) 0)
          (vim.notify "All plugins already have sha256 hashes!" vim.log.levels.INFO)
          (let [total (length plugins-without-hash)]
            (var updated 0)
            (var failed 0)

            (vim.notify (.. "Updating " total " plugin hashes with concurrency " concurrency "...") vim.log.levels.INFO)

            ;; Progress notification helper (throttled)
            (fn notify-progress []
              (let [completed (+ updated failed)]
                (when (or (= completed total)
                          (= 0 (% completed PROGRESS-INTERVAL)))
                  (vim.notify (.. "Progress: " completed "/" total " (ok=" updated " fail=" failed ")") vim.log.levels.INFO))))

            ;; Run concurrent worker pool
            (run-concurrent
              plugins-without-hash
              concurrency
              ;; Per-item handler
              (fn [item-or-signal ...]
                (if (= item-or-signal :complete)
                    ;; Completion signal: item-idx success ?hash ?err
                    (let [(item-idx success hash err) ...]
                      (if success
                          (do
                            (set updated (+ updated 1))
                            (let [{: plugin} (. plugins-without-hash item-idx)]
                              (tset collected-hashes plugin hash)))
                          (do
                            (set failed (+ failed 1))
                            (let [{: plugin} (. plugins-without-hash item-idx)]
                              (table.insert failures {: plugin : err})
                              ;; Notify failures immediately
                              (vim.notify (.. "Failed: " plugin) vim.log.levels.WARN))))
                      (notify-progress))
                    ;; Start signal: process the item
                    (let [{: plugin : entry} item-or-signal
                          done-callback (select 1 ...)]
                      (update-plugin-hash plugin entry done-callback))))
              ;; Done-all handler
              (fn []
                ;; Apply all collected hashes to lockfile
                (each [plugin hash (pairs collected-hashes)]
                  (when (?. lockfile :plugins plugin)
                    (tset (. lockfile.plugins plugin) :sha256 hash)))
                ;; Write lockfile once with pretty JSON
                ;; Note: vim.fn.writefile expects list of lines, not single string
                (let [encoded (vim.json.encode lockfile {:indent "  "})
                      lines (vim.split encoded "\n")]
                  (vim.fn.writefile lines lockfile-path))
                ;; Final notification
                (vim.notify (.. "Done! Updated: " updated ", Failed: " failed) vim.log.levels.INFO)
                ;; Report failures if any
                (when (> (length failures) 0)
                  (vim.notify (.. "Failed plugins: " (table.concat
                                                        (icollect [_ {: plugin} (ipairs failures)] plugin)
                                                        ", "))
                              vim.log.levels.WARN)))))))))

;; Register user command with optional concurrency arg
(vim.api.nvim_create_user_command
  :NixUpdateLock
  (fn [opts]
    (let [concurrency (if (> (length opts.args) 0)
                          (tonumber opts.args)
                          nil)]
      (update-all-hashes concurrency)))
  {:nargs "?"
   :desc "Update nix sha256 hashes in nvim-pack-lock.json. Optional arg: concurrency (default 8)"})

{: update-all-hashes
 : run-nix-prefetch}
