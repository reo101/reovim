(fn config []
  ;; |Alias Name                                |Explanation                                      |Examples                           |
  ;; |------------------------------------------|-------------------------------------------------|-----------------------------------|
  ;; |`augend.integer.alias.decimal`            |decimal natural number                           |`0`, `1`, ..., `9`, `10`, `11`, ...|
  ;; |`augend.integer.alias.decimal_int`        |decimal integer (including negative number)      |`0`, `314`, `-1592`, ...           |
  ;; |`augend.integer.alias.hex`                |hex natural number                               |`0x00`, `0x3f3f`, ...              |
  ;; |`augend.integer.alias.octal`              |octal natural number                             |`0o00`, `0o11`, `0o24`, ...        |
  ;; |`augend.integer.alias.binary`             |binary natural number                            |`0b0101`, `0b11001111`, ...        |
  ;; |`augend.date.alias["%Y/%m/%d"]`           |Date in the format `%Y/%m/%d` (`0` padding)      |`2021/01/23`, ...                  |
  ;; |`augend.date.alias["%m/%d/%Y"]`           |Date in the format `%m/%d/%Y` (`0` padding)      |`23/01/2021`, ...                  |
  ;; |`augend.date.alias["%d/%m/%Y"]`           |Date in the format `%d/%m/%Y` (`0` padding)      |`01/23/2021`, ...                  |
  ;; |`augend.date.alias["%m/%d/%y"]`           |Date in the format `%m/%d/%y` (`0` padding)      |`01/23/21`, ...                    |
  ;; |`augend.date.alias["%d/%m/%y"]`           |Date in the format `%d/%m/%y` (`0` padding)      |`23/01/21`, ...                    |
  ;; |`augend.date.alias["%m/%d"]`              |Date in the format `%m/%d` (`0` padding)         |`01/04`, `02/28`, `12/25`, ...     |
  ;; |`augend.date.alias["%-m/%-d"]`            |Date in the format `%-m/%-d` (no paddings)       |`1/4`, `2/28`, `12/25`, ...        |
  ;; |`augend.date.alias["%Y-%m-%d"]`           |Date in the format `%Y-%m-%d` (`0` padding)      |`2021-01-04`, ...                  |
  ;; |`augend.date.alias["%Y年%-m月%-d日"]`       |Date in the format `%Y年%-m月%-d日` (no paddings)|`2021年1月4日`, ...                |
  ;; |`augend.date.alias["%Y年%-m月%-d日(%ja)"]`  |Date in the format `%Y年%-m月%-d日(%ja)`         |`2021年1月4日(月)`, ...            |
  ;; |`augend.date.alias["%H:%M:%S"]`           |Time in the format `%H:%M:%S`                    |`14:30:00`, ...                    |
  ;; |`augend.date.alias["%H:%M"]`              |Time in the format `%H:%M`                       |`14:30`, ...                       |
  ;; |`augend.constant.alias.ja_weekday`        |Japanese weekday                                 |`月`, `火`, ..., `土`, `日`        |
  ;; |`augend.constant.alias.ja_weekday_full`   |Japanese full weekday                            |`月曜日`, `火曜日`, ..., `日曜日`  |
  ;; |`augend.constant.alias.bool`              |elements in boolean algebra (`true` and `false`) |`true`, `false`                    |
  ;; |`augend.constant.alias.alpha`             |Lowercase alphabet letter (word)                 |`a`, `b`, `c`, ..., `z`            |
  ;; |`augend.constant.alias.Alpha`             |Uppercase alphabet letter (word)                 |`A`, `B`, `C`, ..., `Z`            |
  ;; |`augend.semver.alias.semver`              |Semantic version                                 |`0.3.0`, `1.22.1`, `3.9.1`, ...    |
  (let [dial-map (require :dial.map)
        dial-util (require :dial.util)
        dial-config (require :dial.config)
        dial-augend (require :dial.augend)
        dial-augend-common (require :dial.augend.common)
        (has-utf8? utf8) (pcall require :lua-utf8)
        dk (require :def-keymaps)
        default [dial-augend.integer.alias.decimal
                 dial-augend.integer.alias.hex
                 dial-augend.integer.alias.binary
                 (. dial-augend.date.alias "%Y/%m/%d")
                 dial-augend.semver.alias.semver
                 dial-augend.constant.alias.bool]
        haskell-boolean (dial-augend.constant.new
                          {:cyclic true
                           :desc "Haskell True/False"
                           :elements [:True
                                      :False]
                           :word true})
        octal (dial-augend.user.new
                {:add
                  (fn [text addend _cursor]
                    (local wid (length text))
                    (var n (tonumber (string.sub text 3 8)))
                    (set n (+ n addend))
                    (when (< n 0)
                      (set n 0))
                    (set-forcibly! text
                                   (.. :0o
                                       (dial-util.tostring_with_base
                                        n
                                        8
                                        (- wid 2)
                                        :0)))
                    (set-forcibly! cursor
                                   (length text))
                    {:text (.. :0o
                               (dial-util.tostring_with_base
                                n
                                8
                                (- wid 2)
                                :0))
                     :cursor (length text)})
                 :desc "Octal integers"
                 :find (dial-augend-common.find_pattern "0o[0-7]+")})
        zig-octal     octal
        rust-octal    octal
        haskell-octal octal
        agda-script
          (fn [script]
            (when (not has-utf8?)
              (lua "return nil"))
            (let [scripts {:_ ["₀"  "₁"  "₂"  "₃"  "₄"  "₅"  "₆"  "₇"  "₈"  "₉"]
                           :^ ["⁰"  "¹"  "²"  "³"  "⁴"  "⁵"  "⁶"  "⁷"  "⁸"  "⁹"]
                           :b ["𝟘"  "𝟙"  "𝟚"  "𝟛"  "𝟜"  "𝟝"  "𝟞"  "𝟟"  "𝟠"  "𝟡"]
                           :B ["𝟎"  "𝟏"  "𝟐"  "𝟑"  "𝟒"  "𝟓"  "𝟔"  "𝟕"  "𝟖"  "𝟗"]
                           :F ["０" "１" "２" "３" "４" "５" "６" "７" "８" "９"]}
                  selected (. scripts script)
                  from (collect [i d (ipairs selected)]
                         (values d (- i 1)))
                  to (collect [i d (ipairs selected)]
                       (values (- i 1) d))]
              (dial-augend.user.new
                {:add
                  (fn [text addend _cursor]
                    (local new
                      (-> text
                          (#[(utf8.byte $ 1 (utf8.len $))])
                          vim.iter
                          (: :map utf8.char)
                          (: :map #(. from $))
                          (: :fold 0 (fn [acc digit]
                                       (+ digit (* 10 acc))))
                          (+ addend)
                          tostring
                          (vim.split "")
                          vim.iter
                          (: :map tonumber)
                          (: :map #(. to $))
                          (: :totable)
                          table.concat))
                    {:text new
                     :cursor nil})
                 :desc (string.format "Agda %sscript" script)
                 :find (dial-augend-common.find_pattern
                         (string.format "[%s]+"
                                        (table.concat
                                          selected)))})))
        augends-group {: default
                       :haskell (vim.tbl_extend
                                  :keep
                                  [dial-augend.integer.alias.decimal
                                   haskell-boolean
                                   haskell-octal]
                                  {})
                       :rust [dial-augend.integer.alias.decimal
                              dial-augend.integer.alias.hex
                              dial-augend.integer.alias.binary
                              (. dial-augend.date.alias "%Y/%m/%d")
                              dial-augend.semver.alias.semver
                              dial-augend.constant.alias.bool
                              rust-octal]
                       :zig [dial-augend.integer.alias.decimal
                             dial-augend.integer.alias.hex
                             dial-augend.integer.alias.binary
                             (. dial-augend.date.alias "%Y/%m/%d")
                             dial-augend.semver.alias.semver
                             dial-augend.constant.alias.bool
                             zig-octal]
                       :agda [dial-augend.integer.alias.decimal
                              (agda-script :_)
                              (agda-script :^)
                              (agda-script :b)
                              (agda-script :B)
                              (agda-script :F)]}]
    (dial-config.augends:register_group augends-group)
    (dk :n
        {:<C-a> [dial-map.inc_normal :Increment]
         :<C-x> [dial-map.dec_normal :Decrement]})
    (dk :v
        {:<C-a>  [dial-map.inc_visual  :Increment]
         :<C-x>  [dial-map.dec_visual  :Decrement]
         :g<C-a> [dial-map.inc_gvisual :Increment]
         :g<C-x> [dial-map.dec_gvisual :Decrement]})
    (local group (vim.api.nvim_create_augroup
                   :dial-filetype-autocommands
                   {:clear true}))
    (each [_ lang (ipairs [:haskell :zig :rust :agda])]
      (vim.api.nvim_create_autocmd
        :FileType
        {:pattern lang
         : group
         :callback
           #(do
              (dk :n
                  {:<C-a> (dial-map.inc_normal lang)
                   :<C-x> (dial-map.dec_normal lang)})
              (dk :v
                  {:<C-a>  [(dial-map.inc_visual lang)  :Increment]
                   :<C-x>  [(dial-map.dec_visual lang)  :Decrement]
                   :g<C-a> [(dial-map.inc_gvisual lang) :Increment]
                   :g<C-x> [(dial-map.dec_gvisual lang) :Decrement]}))}))))

{1 :monaqa/dial.nvim
 :event :VeryLazy
 : config}
