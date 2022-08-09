# Freeze frame
(var FREEZE 0)

(defn freeze! [&named frames] (set FREEZE frames))
(defn freeze-tic [] (set FREEZE (max 0 (- FREEZE 1))))
(defn frozen? [] (> FREEZE 0))

# Screen Shake
(var SHAKE @{:frames 0 :intensity 0 :offset [0 0]})

(defn shake! [&named frames intensity]
  (put SHAKE :frames frames)
  (put SHAKE :intensity intensity))

(defn shaking? [] (> (SHAKE :frames) 0))

(defn shake-tic []
  (put SHAKE :frames (max 0 (- (SHAKE :frames) 1)))
  (put SHAKE :offset (if (shaking?)
                       [(* (SHAKE :intensity) (- (math/random) 0.5))
                        (* (SHAKE :intensity) (- (math/random) 0.5))]
                       [0 0])))
