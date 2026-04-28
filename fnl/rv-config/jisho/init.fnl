(fn utf8-chars [s]
  (let [positions (vim.str_utf_pos s)
        num-chars (length positions)
        s-len (length s)
        result []]
    (for [i 1 num-chars]
      (let [start-byte (. positions i)
            end-byte (if (< i num-chars)
                       (- (. positions (+ i 1)) 1)
                       s-len)]
        ;; Slice the string and add it to our result table
        (table.insert result (string.sub s start-byte end-byte))))
    ;; Return the populated table
    result))

(var budoux-parser nil)

(fn japanese-char? [ch]
  (when (and ch (not= ch ""))
    (let [codepoint (vim.fn.char2nr ch true)]
      (or (and (>= codepoint 0x3040) (<= codepoint 0x309f))
          (and (>= codepoint 0x30a0) (<= codepoint 0x30ff))
          (and (>= codepoint 0x31f0) (<= codepoint 0x31ff))
          (and (>= codepoint 0x3400) (<= codepoint 0x4dbf))
          (and (>= codepoint 0x4e00) (<= codepoint 0x9fff))
          (and (>= codepoint 0xf900) (<= codepoint 0xfaff))
          (and (>= codepoint 0xff66) (<= codepoint 0xff9f))
          (= codepoint 0x3005) ; 々
          (= codepoint 0x30fc) ; ー
          (= codepoint 0x30fb) ; ・
          (= codepoint 0xff65) ; ･
          (= codepoint 0x309d)
          (= codepoint 0x309e)
          (= codepoint 0x30fd)
          (= codepoint 0x30fe)))))

(fn normalize-query [s]
  (when s
    (-> s
        vim.trim
        (: :gsub "^[%s　「」『』（）()%[%]【】、。！？…]+" "")
        (: :gsub "[%s　「」『』（）()%[%]【】、。！？…]+$" "")
        (: :gsub "%s+" " "))))

(fn get-budoux-parser []
  (if budoux-parser
    budoux-parser
    (let [(ok budoux) (pcall require :budoux)]
      (when ok
        (set budoux-parser (budoux.load_japanese_model))
        budoux-parser))))

(fn get-query-at-cursor-fallback [line chars num-chars char-idx]
  (let [current-char (. chars char-idx)]
    (if (not (japanese-char? current-char))
      (vim.fn.expand "<cword>")
      (do
        (var start char-idx)
        (var finish char-idx)
        (while (and (> start 1)
                    (japanese-char? (. chars (- start 1))))
          (set start (- start 1)))
        (while (and (< finish num-chars)
                    (japanese-char? (. chars (+ finish 1))))
          (set finish (+ finish 1)))
        (let [query []]
          (for [i start finish]
            (table.insert query (. chars i)))
          (table.concat query ""))))))

(fn get-query-at-cursor []
  (let [line (vim.api.nvim_get_current_line)
        chars (utf8-chars line)
        num-chars (length chars)]
    (if (= num-chars 0)
      (vim.fn.expand "<cword>")
      (let [cursor-pos (vim.api.nvim_win_get_cursor 0)
            byte-col (. cursor-pos 2)
            char-idx (+ 1 (math.min (vim.fn.charidx line byte-col)
                                    (- num-chars 1)))
            parser (get-budoux-parser)]
        (if (and parser (japanese-char? (. chars char-idx)))
          (let [segments (parser.parse line)]
            (var start 1)
            (var matching nil)
            (for [i 1 (length segments)]
              (let [segment (. segments i)
                    segment-len (vim.fn.strchars segment)
                    finish (+ start segment-len -1)]
                (when (and (<= start char-idx)
                           (<= char-idx finish))
                  (set matching segment)
                  (lua :break))
                (set start (+ finish 1))))
            (or (normalize-query matching)
                (get-query-at-cursor-fallback line chars num-chars char-idx)))
          (get-query-at-cursor-fallback line chars num-chars char-idx))))))

(fn get-visual-selection []
  (let [start-pos (vim.fn.getpos "v")
        end-pos (vim.fn.getpos ".")
        lines (vim.fn.getregion start-pos end-pos)]
    (vim.api.nvim_feedkeys
      (vim.api.nvim_replace_termcodes "<Esc>" true false true)
      :n
      true)
    (table.concat lines " ")))

(fn after []
  (let [jisho (require :jisho)
        dk (require :def-keymaps)
        opt {}]
    (jisho.setup opt)

    (dk :n
        {:t {:group :Toggle
             :j [#(jisho.search (normalize-query (get-query-at-cursor)))
                 "Jisho (Word under cursor)"]}}
        {:prefix :<leader>})

    (dk :v
        {:t {:group :Toggle
             :j [#(jisho.search (normalize-query (get-visual-selection)))
                 "Jisho (Selection)"]}}
        {:prefix :<leader>})))

{:src "https://github.com/Imngzx/jisho.nvim"
 :data {:cmd ["Jisho"]
        :keys [:<leader>tj]
        : after}}
