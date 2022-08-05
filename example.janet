(use /craft-bin)

# Components
(def-component ball :color :keyword :radius :number)
(def-component position :x :number :y :number)
(def-component velocity :x :number :y :number)

# Systems
(defn flip-x [vel]
  (shake! :frames 8 :intensity 2)
  (freeze! :frames 4)
  (put vel :x (* -1 (vel :x))))

(defn flip-y [vel]
  (shake! :frames 8 :intensity 2)
  (freeze! :frames 4)
  (put vel :y (* -1 (vel :y))))

(def-update-system move-n-bounce
  {moveables [:position :velocity :ball]}
  (each [pos vel b] moveables
    # update position
    (put pos :x (+ (pos :x) (* dt (vel :x))))
    (put pos :y (+ (pos :y) (* dt (vel :y))))

    # Bound off of walls
    (when (and (<= (- (pos :x) (b :radius)) 0) (<= (vel :x) 0))
      (flip-x vel))
    (when (and (>= (+ (pos :x) (b :radius)) SCREEN_WIDTH) (>= (vel :x) 0))
      (flip-x vel))

    (when (and (<= (- (pos :y) (b :radius)) 0) (<= (vel :y) 0))
      (flip-y vel))
    (when (and (>= (+ (pos :y) (b :radius)) SCREEN_HEIGHT) (>= (vel :y) 0))
      (flip-y vel))))

(def-draw-system draw-ball
  {balls [:position :ball]}
  (each [{:x x :y y} {:color c :radius r}] balls
    (draw-circle (math/floor x) (math/floor y) r c)))


# Gamestate & Entity Creation
(def-rubish-gamestate main-game [{:world world}]
  (add-entity world
              (position :x 10 :y 10)
              (velocity :x 1 :y 1)
              (ball :color :red :radius 24))
  (add-entity world
              (position :x 100 :y 20)
              (velocity :x 1.5 :y -1)
              (ball :color :blue :radius 20))
  (add-entity world
              (position :x 100 :y 20)
              (velocity :x -1.75 :y 1.4)
              (ball :color :green :radius 14))
  (register-system world move-n-bounce)
  (register-system world draw-ball))

(goto main-game)
(start)
