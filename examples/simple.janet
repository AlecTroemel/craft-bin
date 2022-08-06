(use /craft-bin)

(init)

# Components
(def-component ball :color :any :radius :number)

# Systems
(defn flip-x [vel]
  (shake! :frames 8 :intensity 10)
  (freeze! :frames 4)
  (put vel :x (* -1 (vel :x))))

(defn flip-y [vel]
  (shake! :frames 8 :intensity 2)
  (freeze! :frames 4)
  (put vel :y (* -1 (vel :y))))

(def-update-system bounce-ball
  {bouncies [:position :velocity :ball]}
  (each [pos vel b] bouncies

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
(def-gamestate main-game
  (add-entity world
              (position :x 100 :y 100)
              (velocity :x 1 :y 1)
              (ball :color orangey-red :radius 24))
  (add-entity world
              (position :x 100 :y 20)
              (velocity :x 1.5 :y -1)
              (ball :color medium-blue :radius 20))
  (add-entity world
              (position :x 100 :y 20)
              (velocity :x -1.75 :y 1.4)
              (ball :color kelley-green :radius 14))
  (register-system world bounce-ball)
  (register-system world draw-ball))

(goto main-game)
(start)
