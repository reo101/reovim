(fn config []
  (let [fidget (require :fidget)
        opt {:text
               {;; animation shown when tasks are ongoing
                :spinner :arc
                ;; character shown when all tasks are complete
                :done "✔"
                ;; message shown when task starts
                :commenced :Started
                ;; message shown when task completes
                :completed :Completed}
             :align
               {;; align fidgets along bottom edge of buffer
                :bottom true
                ;; align fidgets along right edge of buffer
                :right true}
             :timer
               {;; frame rate of spinner animation, in ms
                :spinner_rate 125
                ;; how long to keep around empty fidget, in ms
                :fidget_decay 2000
                ;; how long to keep around completed task, in ms
                :task_decay 1000}
             :window
               {;; where to anchor, either "win" or "editor"
                :relative :win
                ;; &winblend for the window
                :blend 100
                ;; the zindex value for the window
                :zindex nil}
             :fmt
               {;; right-justify text in fidget box
                :leftpad true
                ;; list of tasks grows upwards
                :stack_upwards true
                ;; maximum width of the fidget box
                :max_width 0
                ;; function to format fidget title
                :fidget (fn [fidget-name spinner]
                          (string.format
                            "%s %s"
                            spinner
                            fidget-name))
                ;; function to format each task line
                :task (fn [task-name message percentage]
                        (string.format
                          "%s%s [%s]"
                          message
                          (if percentage
                              (string.format
                                " (%s%%)"
                                percentage)
                              "")
                          task-name))}
             ;; Sources to configure
             :sources
               {;; Name of source
                :*
                  {;; Ignore notifications from this source
                   :ignore false}}
             :debug
               {;; whether to enable logging, for debugging
                :logging false}}]

    (fidget.setup opt)))

{: config}
