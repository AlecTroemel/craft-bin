# Screen freeze
(var FREEZE 0)
(defn freeze! [&named frames] (set FREEZE frames))
(defn freeze-tic [] (set FREEZE (max 0 (- FREEZE 1))))
(defn frozen? [] (> FREEZE 0))

# TODO Shake juice
(defn shake! [&named frames intensity] nil)
