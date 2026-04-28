;;; Parse the last terminal command's output with 'errorformat' into quickfix.

(local group (vim.api.nvim_create_augroup
               :reovim-term-make
               {:clear true}))
(local prompt-ns (vim.api.nvim_create_namespace :reovim.term-make.prompts))

(fn buf-valid? [buf]
  (and buf
       (> buf 0)
       (vim.api.nvim_buf_is_valid buf)
       (vim.api.nvim_buf_is_loaded buf)))

(fn buf-option [buf opt]
  (vim.api.nvim_get_option_value opt {:buf buf}))

(fn buftype [buf]
  (buf-option buf :buftype))

(fn effective-errorformat [buf]
  (let [local-efm (buf-option buf :errorformat)]
    (if (not= local-efm "")
      local-efm
      vim.o.errorformat)))

(fn terminal-buf? [buf]
  (and (buf-valid? buf)
       (= (buftype buf) :terminal)))

(fn efm-source-buf? [buf term-buf]
  (and (buf-valid? buf)
       (not= buf term-buf)
       (not (vim.tbl_contains [:terminal :quickfix :help :prompt :nofile]
                              (buftype buf)))))

(fn find-window-buf [pred]
  (var found nil)
  (each [_ win (ipairs (vim.api.nvim_tabpage_list_wins 0))]
    (let [buf (vim.api.nvim_win_get_buf win)]
      (when (and (not found) (pred buf))
        (set found buf))))
  found)

(fn find-window-for-buf [target-buf]
  (var found nil)
  (each [_ win (ipairs (vim.api.nvim_tabpage_list_wins 0))]
    (when (and (not found)
               (= (vim.api.nvim_win_get_buf win) target-buf))
      (set found win)))
  found)

(fn target-terminal-buf []
  (let [cur (vim.api.nvim_get_current_buf)
        alt (vim.fn.bufnr "#")]
    (if (terminal-buf? cur) cur
        (terminal-buf? alt) alt
        (find-window-buf terminal-buf?))))

(fn source-buffer-for-efm [term-buf]
  (let [cur (vim.api.nvim_get_current_buf)
        alt (vim.fn.bufnr "#")]
    (or (when (efm-source-buf? cur term-buf) cur)
        (when (efm-source-buf? alt term-buf) alt)
        (find-window-buf #(efm-source-buf? $1 term-buf))
        term-buf)))

(fn record-prompt-mark! [buf kind cursor]
  (let [lnum (or (. cursor 1) 1)
        row (math.max 0 (- lnum 1))
        line (or (. (vim.api.nvim_buf_get_lines buf row (+ row 1) false) 1) "")
        col (math.min (# line) (math.max 0 (or (. cursor 2) 0)))
        id (vim.api.nvim_buf_set_extmark
             buf
             prompt-ns
             row
             col
             {:right_gravity false})
        key (if (= kind :start)
              :rv_term_prompt_starts
              :rv_term_prompt_ends)
        bvars (. vim :b buf)
        ids (or (. bvars key) [])]
    (table.insert ids id)
    (while (> (# ids) 200)
      (table.remove ids 1))
    (tset bvars key ids)))

(vim.api.nvim_create_autocmd
  :TermRequest
  {:desc "Tracks OSC 133 shell prompts for :TermMake"
   :group group
   :callback
    (fn [ev]
      (let [sequence (or (. ev :data :sequence) "")
            cursor (or (. ev :data :cursor) [1 0])]
        (if (sequence:match "^\027]133;A")
            (record-prompt-mark! ev.buf :start cursor)
            (sequence:match "^\027]133;B")
            (record-prompt-mark! ev.buf :end cursor))))})

(fn extmark-pos [buf id]
  (let [pos (vim.api.nvim_buf_get_extmark_by_id buf prompt-ns id {})]
    (when (> (# pos) 0)
      {:row (. pos 1)
       :col (. pos 2)})))

(fn pos< [a b]
  (or (< a.row b.row)
      (and (= a.row b.row)
           (< a.col b.col))))

(fn prompt-positions [buf key]
  (let [bvars (. vim :b buf)
        ids (or (. bvars key) [])
        positions []]
    (each [_ id (ipairs ids)]
      (let [pos (extmark-pos buf id)]
        (when pos
          (table.insert positions pos))))
    (table.sort positions pos<)
    positions))

(fn last-pos-before [positions target]
  (var found nil)
  (each [_ pos (ipairs positions)]
    (when (pos< pos target)
      (set found pos)))
  found)

(fn last-pos [positions]
  (. positions (# positions)))

(fn range-from-prompt-marks [buf]
  (let [starts (prompt-positions buf :rv_term_prompt_starts)
        ends (prompt-positions buf :rv_term_prompt_ends)
        line-count (vim.api.nvim_buf_line_count buf)]
    (if (>= (# starts) 2)
        (let [current-start (last-pos starts)
              previous-start (. starts (- (# starts) 1))
              previous-end (last-pos-before ends current-start)
              start-row (if previous-end
                          (+ previous-end.row 1)
                          (+ previous-start.row 1))
              end-row (- current-start.row 1)]
          (when (<= start-row end-row)
            {:start-row start-row
             :end-row end-row}))
        (= (# starts) 1)
        (let [start (last-pos starts)
              end (or (last-pos ends) start)
              start-row (+ end.row 1)
              end-row (- line-count 1)]
          (when (<= start-row end-row)
            {:start-row start-row
             :end-row end-row})))))

(fn range-from-terminal-motions [buf]
  (let [win (find-window-for-buf buf)]
    (when win
      (let [(ok range)
            (pcall
              vim.api.nvim_win_call
              win
              (fn []
                (let [view (vim.fn.winsaveview)
                      line-count (vim.api.nvim_buf_line_count buf)
                      last-line (or (. (vim.api.nvim_buf_get_lines
                                          buf
                                          (- line-count 1)
                                          line-count
                                          false)
                                       1)
                                    "")]
                  (vim.api.nvim_win_set_cursor win [line-count (# last-line)])
                  (vim.cmd "normal! [[")
                  (let [current-prompt-line (. (vim.api.nvim_win_get_cursor win) 1)]
                    (vim.cmd "normal! [[")
                    (let [previous-prompt-line (. (vim.api.nvim_win_get_cursor win) 1)
                          start-row previous-prompt-line
                          end-row (- current-prompt-line 2)]
                      (vim.fn.winrestview view)
                      (when (and (< previous-prompt-line current-prompt-line)
                                 (<= start-row end-row))
                        {:start-row start-row
                         :end-row end-row}))))))]
        (when ok range)))))

(fn fallback-range [buf]
  (let [line-count (vim.api.nvim_buf_line_count buf)]
    (when (> line-count 0)
      {:start-row 0
       :end-row (- line-count 1)})))

(fn last-output-range [buf]
  (or (range-from-prompt-marks buf)
      (range-from-terminal-motions buf)
      (fallback-range buf)))

(fn trim-edge-blank-lines [lines]
  (while (and (> (# lines) 0)
              (: (. lines 1) :match "^%s*$"))
    (table.remove lines 1))
  (while (and (> (# lines) 0)
              (: (. lines (# lines)) :match "^%s*$"))
    (table.remove lines (# lines)))
  lines)

(fn buffer-lines-in-range [buf range]
  (let [line-count (vim.api.nvim_buf_line_count buf)
        start-row (math.max 0 range.start-row)
        end-row (math.min (- line-count 1) range.end-row)]
    (if (<= start-row end-row)
      (trim-edge-blank-lines
        (vim.api.nvim_buf_get_lines buf start-row (+ end-row 1) false))
      [])))

(fn valid-qf-count [items]
  (var count 0)
  (each [_ item (ipairs items)]
    (when (not= item.valid 0)
      (set count (+ count 1))))
  count)

(fn qf-title [term-buf efm-buf]
  (string.format
    "TermMake: %s using %s 'errorformat'"
    (vim.fn.bufname term-buf)
    (vim.fn.bufname efm-buf)))

(fn setqflist-from-terminal-context! [term-buf what]
  (let [win (find-window-for-buf term-buf)]
    (if win
      (vim.api.nvim_win_call
        win
        (fn []
          (vim.fn.setqflist [] :r what)))
      (vim.fn.setqflist [] :r what))))

(fn term-make [opts]
  (let [term-buf (target-terminal-buf)]
    (if (not term-buf)
      (vim.notify "TermMake: no terminal buffer found" vim.log.levels.WARN)
      (let [efm-buf (source-buffer-for-efm term-buf)
            efm (effective-errorformat efm-buf)
            range (last-output-range term-buf)
            lines (buffer-lines-in-range term-buf range)
            title (qf-title term-buf efm-buf)]
        (setqflist-from-terminal-context!
          term-buf
          {: title
           : lines
           : efm
           :context {: term-buf
                     : efm-buf
                     : range}})
        (let [info (vim.fn.getqflist {:size 0 :items 0})
              valid-count (valid-qf-count info.items)]
          (pcall vim.cmd.cwindow)
          (when (and (not opts.bang) (> valid-count 0))
            (pcall vim.cmd.cfirst))
          (vim.notify
            (string.format
              "TermMake: parsed %d terminal lines into %d quickfix items (%d valid)"
              (# lines)
              info.size
              valid-count)
            vim.log.levels.INFO))))))

(vim.api.nvim_create_user_command
  :TermMake
  term-make
  {:bang true
   :desc "Parse the last terminal command output into quickfix using 'errorformat'"})

{}
