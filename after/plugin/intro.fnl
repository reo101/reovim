;; Credits to https://gist.github.com/GnikDroy/62556534324f9dc9192f7bba5a88cc43

(when (or (not= (vim.fn.argc) 0)
          (not= (length (vim.api.nvim_list_wins)) 1))
  (lua "return nil"))

(vim.opt.shortmess:remove :I)

(local WIDTH (vim.api.nvim_win_get_width 0))
(local HEIGHT (vim.api.nvim_win_get_height 0))

(when (or (< WIDTH 120)
          (< HEIGHT 40))
  (lua "return nil"))

(vim.api.nvim_set_hl
  0
  :NvimGreen
  {:default true
   :fg 7054142})
(vim.api.nvim_set_hl
  0
  :NvimBlue
  {:default true
   :fg 03054811})

(fn shuffle [tbl]
  (for [i (length tbl) 2 (- 1)]
    (local j (math.random i))
    (local tmp (. tbl i))
    (tset tbl i (. tbl j))
    (tset tbl j tmp))
  tbl)

(fn get-highlight-range [line pattern]
  (let [results {}]
    (var start 1)
    (while (<= start (length line))
      (local (s e) (string.find line pattern start))
      (when (= e nil) (lua "return results"))
      (table.insert results [s e])
      (set start (+ e 1)))
    results))

(fn widest [acc line]
  (math.max acc (vim.api.nvim_strwidth line)))

(comment
  "---@class EphemeralWidget
   ---@field opts EphemeralWidgetOpts
   ---@field win number?
   ---@field buf number?")
(local EphemeralWidget {})
(set EphemeralWidget.__index EphemeralWidget)

(comment
  "---@class EphemeralWidgetOpts
   ---@field label string
   ---@field win_opts table?
   ---@field lines string[]
   ---@field highlights table")

(comment
  "-- Constructor
   ---@param opts EphemeralWidgetOpts
   ---@return EphemeralWidget
   ---@nodiscard")
(fn EphemeralWidget.new [opts]
  (let [widget (setmetatable {} EphemeralWidget)]
    (set widget.opts opts)
    widget))

(fn EphemeralWidget.render [self]
  (let [buf (vim.api.nvim_create_buf false true)
        win (vim.api.nvim_open_win buf false self.opts.win_opts)]
    (set self.buf buf)
    (set self.win win)
    (tset (. vim.wo win) :winhl "Normal:NONE,EndOfBuffer:NONE")
    (tset (. vim.wo win) :foldenable false)

    (vim.api.nvim_buf_set_lines buf 0 (- 1) true self.opts.lines)

    (local ns (vim.api.nvim_create_namespace self.opts.label))
    (each [col line (ipairs self.opts.lines)]
      (each [_ pattern-hl-pair (ipairs self.opts.highlights)]
        (each [_ range (ipairs (get-highlight-range line (. pattern-hl-pair 1)))]
          (vim.api.nvim_buf_add_highlight
            buf
            ns
            (. pattern-hl-pair 2)
            (- col 1)
            (- (. range 1) 1)
            (. range 2)))))

    (local augroup (vim.api.nvim_create_augroup self.opts.label {}))

    (fn cleanup []
      (when (vim.api.nvim_win_is_valid win)
        (vim.api.nvim_win_close win true))
      (when (vim.api.nvim_buf_is_valid buf)
        (vim.api.nvim_buf_clear_namespace buf ns 0 (- 1))
        (vim.api.nvim_buf_delete buf {:force true}))
      (vim.on_key nil ns)
      (vim.api.nvim_clear_autocmds {:group self.opts.label})
      (vim.api.nvim_del_augroup_by_id augroup))

    (vim.on_key cleanup ns)
    (vim.api.nvim_create_autocmd
      :VimResized
      {:callback cleanup
       :group augroup})))

(local intro-fmt "
NVIM v%s

Nvim is open source and freely distributable
https://neovim.io/#chat

type  :help nvim<Enter>       if you are new! 
type  :checkhealth<Enter>     to optimize Nvim
type  :q<Enter>               to exit         
type  :help<Enter>            for help        

type  :help news<Enter> to see changes in v%s

Become a registered Vim user!
type  :help register<Enter>   for information")

(local ver (vim.version))
(local ver-str-min (string.format "%d.%d" ver.major ver.minor))
(var intro (vim.split
             (string.format
               intro-fmt
               (tostring ver)
               ver-str-min)
             "\n"))

(local intro-win-width
       (-> intro
           vim.iter
           (: :fold 0 (fn [acc line]
                        (math.max acc (length line))))))

(set intro (-> intro
               vim.iter
               (: :map (fn [line]
                         (.. (string.rep
                               " "
                               (math.ceil (/ (- intro-win-width
                                                (length line))
                                             2)))
                             line)))
               (: :totable)))
(-> (EphemeralWidget.new
      {:label :intro
       :lines intro
       :win_opts {:col (* (- WIDTH intro-win-width) 0.5)
                  :focusable false
                  :height (length intro)
                  :relative :win
                  :row (* (- HEIGHT (length intro)) 0.5)
                  :style :minimal
                  :width intro-win-width
                  :zindex 25}
       :highlights [[:NVIM                     :NvimGreen]
                    ["v[0-9]+[0-9.a-zA-z-+]+"  :NvimGreen]
                    ["https://neovim.io/#chat" :Underlined]
                    [":%a+"                    :NvimBlue]
                    ["<.*>"                    :NvimGreen]
                    ["if you are new!"         :DiagnosticOk]
                    ["to exit"                 :DiagnosticError]]})
    (: :render))

(local sysinfo-fmt "
SYSTEM INFO
Hostname  │ %s
OS        │ %s %s
Memory    │ %d Gib
Processor │ %s")

(local hostname (vim.uv.os_gethostname))
(local os-uname (vim.uv.os_uname))
(local mem-gigs (/ (/ (/ (vim.uv.get_total_memory) 1024) 1024) 1024))
(local cpu-info (vim.uv.cpu_info))

(local sysinfo (vim.split
                 (string.format
                   sysinfo-fmt
                   hostname
                   os-uname.machine
                   os-uname.sysname
                   mem-gigs
                   (. (. cpu-info 1) :model))
                 "\n"))

(local sysinfo-win-width
       (-> sysinfo
           vim.iter
           (: :fold 0 widest)))
(-> (EphemeralWidget.new {:highlights [["^.*$" :LineNr
                                        ["^SYSTEM INFO$" :NvimGreen]
                                        ["^.*│" :NvimBlue]]]
                           :label :sysinfo
                           :lines sysinfo
                           :win_opts {:anchor :SW
                                      :col 1
                                      :focusable false
                                      :height (length sysinfo)
                                      :relative :win
                                      :row (- HEIGHT 1)
                                      :style :minimal
                                      :width sysinfo-win-width
                                      :zindex 25}})
    (: :render))

(fn parse-keywords-in-section [lines]
  (let [keywords {}]
    (each [_ line (ipairs lines)]
      (each [w (string.gmatch line "|(%S+%(%))|")]
        ;; Truncate long function names
        (when (> (length w) 40)
          (set-forcibly! w (.. (w:sub 1 40) "..")))
        (tset keywords (+ (length keywords) 1) w)))
    ;; Shuffle here to avoid same news sections
    (shuffle keywords)))

(fn parse-news []
  (let [lines (icollect [line (io.lines
                                (.. vim.env.VIMRUNTIME
                                    :/doc/news.txt))]
                line)]

    ;; Don't want to write a parser for news
    ;; Perhaps I can do this with treesitter later?
    (local section-labels
           ["BREAKING CHANGES"
            "NEW FEATURES"
            "CHANGED FEATURES"
            "REMOVED FEATURES"
            "DEPRECATIONS"])
    (local sections {})
    (var current-section nil)
    (each [_ line (ipairs lines)]
      (when (not= (string.find line (string.rep "=" 10)) nil)
        (set current-section nil))
      (when (not= current-section nil)
        (when (= (. sections current-section) nil)
          (tset sections current-section {}))
        (table.insert (. sections current-section) line))
      (each [_ label (ipairs section-labels)]
        (when (not= (string.find line label) nil)
          (set current-section label))))
    sections))

(local news-fmt "
WHAT'S NEW IN v%s?

New Features
%s

Breaking changes
%s

Deprecations
%s")

(local keywords {})
(each [section lines (pairs (parse-news))]
  (tset keywords section
        (-> lines
            parse-keywords-in-section
            vim.iter
            (: :take 7)
            (: :totable))))

(local news (vim.split
              (string.format
                news-fmt
                ver-str-min
                (table.concat
                  (. keywords "NEW FEATURES")
                  "\n")
                (table.concat
                  (. keywords "BREAKING CHANGES")
                  "\n")
                (table.concat
                  (. keywords :DEPRECATIONS)
                  "\n"))
              "\n"))

(local news-win-width
       (-> news
           vim.iter
           (: :fold 0 widest)))

(-> (EphemeralWidget.new {:highlights [["^.*$" :LineNr
                                        ["^WHAT'S NEW IN.*$" :NvimGreen]
                                        ["^New Features$" :DiagnosticOk]
                                        ["^Breaking changes$" :DiagnosticWarn]
                                        [:^Deprecations$ :DiagnosticError]]]
                           :label :news
                           :lines news
                           :win_opts {:anchor :NW
                                      :col 2
                                      :focusable false
                                      :height (- HEIGHT 7)
                                      :relative :win
                                      :row 1
                                      :style :minimal
                                      :width news-win-width
                                      :zindex 25}})
    (: :render))

(local keyboard-fmt "
                      Keyboard ❤️  Neovim
╭───┬───┬───┬───┬───┬───┬───┬───┬───┬───╮
│ Q │ W │ E │ R │ T │ Y │ U │ I │ O │ P │
╰┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴╮
 │ A │ S │ D │ F │ G │ ← │ ↓ │ ↑ │ → │ ; │
 ╰┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──╯
  │ Z │ X │ C │  │ B │  │ M │ < │ > │
  ╰───┴───┴───┴───┴───┴───┴───╯───┴───╯")

(local keyboard (vim.split keyboard-fmt "\n"))
(local keyboard-win-width
       (-> keyboard
           vim.iter
           (: :fold 0 widest)))

(local keyboard-widget
       (EphemeralWidget.new
         {:label :keyboard
          :lines keyboard
          :win_opts {:anchor :SE
                     :col (- WIDTH 1)
                     :focusable false
                     :height (length keyboard)
                     :relative :win
                     :row (- HEIGHT 1)
                     :style :minimal
                     :width keyboard-win-width
                     :zindex 25}
          :highlights [["^.*$" :LineNr]
                       ["[A-Z;<>]" :NvimBlue]
                       ["" :NvimGreen]
                       ["" :NvimGreen]
                       ["←" :NvimGreen]
                       ["↑" :NvimGreen]
                       ["↓" :NvimGreen]
                       ["→" :NvimGreen]
                       [:Neo :NvimGreen]
                       [:vim :NvimBlue]
                       [:b :NvimGreen]]}))
(keyboard-widget:render)
(tset (. vim.wo keyboard-widget.win) :winblend 50)

(local tools-fmt "
CLI & TOOLCHAINS

C compiler │ %s
       git │ %s
      node │ %s
   ripgrep │ %s
        fd │ %s
")

(local compiler-present
       (-> [:cc :gcc :clang :cl :zig]
           vim.iter
           (: :fold false (fn [acc exe]
                            (or acc
                                (= (vim.fn.executable exe)
                                   1))))))
(local tools (vim.split
               (string.format
                 tools-fmt
                 (if compiler-present                "" "󰅙")
                 (if (= (vim.fn.executable :git)  1) "" "󰅙")
                 (if (= (vim.fn.executable :node) 1) "" "󰅙")
                 (if (= (vim.fn.executable :rg)   1) "" "󰅙")
                 (if (= (vim.fn.executable :fd)   1) "" "󰅙"))
               "\n"))
(local tools-win-width
       (-> tools
           vim.iter
           (: :fold 0 widest)))

(-> (EphemeralWidget.new {:label :tools
                           :lines tools
                           :win_opts {:anchor :NE
                                      :col (- WIDTH 1)
                                      :focusable false
                                      :height (length tools)
                                      :relative :win
                                      :row 2
                                      :style :minimal
                                      :width tools-win-width
                                      :zindex 25}
                           :highlights [["^.*$" :LineNr]
                                        ["CLI & TOOLCHAINS" :NvimBlue]
                                        ["│ $" :DiagnosticOk]
                                        ["│ 󰅙$" :DiagnosticError]]})
    (: :render))

(local features-fmt "
 TREESITTER & PLUGINS

  Treesitter ABI │ %d
  Scripts Loaded │ %d




          VIM OPTIONS

       mapleader │ [%s]
  vim.opt.backup │  %s
vim.opt.swapfile │  %s
vim.opt.autoread │  %s")

(local features (vim.split
                  (string.format
                    features-fmt
                    vim.treesitter.language_version
                    (length (vim.fn.getscriptinfo))
                    vim.g.mapleader
                    (if vim.o.backup   "" "󰅙")
                    (if vim.o.swapfile "" "󰅙")
                    (if vim.o.autoread "" "󰅙"))
                  "\n"))
(local features-win-width
       (-> features
           vim.iter
           (: :fold 0 widest)))

(-> (EphemeralWidget.new {:label :features
                           :lines features
                           :win_opts {:anchor :NE
                                      :col (- WIDTH 1)
                                      :focusable false
                                      :height (length features)
                                      :relative :win
                                      :row (math.floor (/ (- HEIGHT
                                                             (length features))
                                                          2))
                                      :style :minimal
                                      :width features-win-width
                                      :zindex 25}
                           :highlights [["^.*$" :LineNr]
                                        ["│ %d+" :DiagnosticWarn]
                                        ["│ %[.*$" :DiagnosticWarn]
                                        ["│%s+$" :DiagnosticOk]
                                        ["│%s+󰅙$" :DiagnosticError]
                                        ["TREESITTER & PLUGINS" :NvimBlue]
                                        ["VIM OPTIONS" :NvimBlue]]})
    (: :render))

(local header-fmt "Type :Tutor and <Enter> for an interactive lesson\n")
(local header (vim.split header-fmt "\n"))
(local header-win-width
       (-> header
           vim.iter
           (: :fold 0 widest)))

(-> (EphemeralWidget.new {:label :header
                          :lines header
                          :win_opts {:anchor :NW
                                     :col (math.floor (/ (- WIDTH
                                                            header-win-width)
                                                         2))
                                     :focusable false
                                     :height (length header)
                                     :relative :win
                                     :row 2
                                     :style :minimal
                                     :width header-win-width
                                     :zindex 25}
                          :highlights [["^.*$" :LineNr]
                                       [":Tutor" :NvimBlue]
                                       ["<.*>" :NvimGreen]]})
    (: :render))
