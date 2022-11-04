(use jaylib)

# function to hot-reload
(varfn draw []
  (begin-drawing)
  (clear-background [1 1 1])
  (end-drawing))

(def thread-channel (ev/thread-chan 10))

(defn game []
  (init-window 500 500 "Test Game")
  (while (not (window-should-close))
    (let [thread-msg (try (ev/take thread-channel)
                          ([err] nil))]
      (cond (= thread-msg :heart-beat) nil
            (try (eval-string thread-msg)
                 ([err] (print err)))))
    (draw))
  (close-window))

# like getline but waits for matching count of parenthesis
(defn getform [&opt prompt]
  (if prompt (file/write stdout prompt))
  (var s "")
  (var n 0)
  (while (or (and (empty? s) (zero? n))
             (and (not (empty? s)) (not (zero? n))))
    (let [l (file/read stdin :line)]
      (set n (+ n (length (string/find-all "(" l))))
      (set n (- n (length (string/find-all ")" l))))
      (set s (string/join @[s l] "\n"))))
  s)

(ev/spawn-thread
 (while true
   (os/sleep 0.2)
   (ev/give thread-channel (getform "game-repl>"))))

(ev/spawn-thread
 (while true
   (os/sleep 0.1)
   (ev/give thread-channel :heart-beat)))

(game)
