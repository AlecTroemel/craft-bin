(use /craft-bin)

(init)

# Components
(def-component ball :color :any :radius :number)

# Systems
(defn flip-x [vel]
  (shake! :frames 8 :intensity 2)
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
    (when (and (>= (+ (pos :x) (b :radius)) GAME_SCREEN_WIDTH) (>= (vel :x) 0))
      (flip-x vel))

    (when (and (<= (- (pos :y) (b :radius)) 0) (<= (vel :y) 0))
      (flip-y vel))
    (when (and (>= (+ (pos :y) (b :radius)) GAME_SCREEN_HEIGHT) (>= (vel :y) 0))
      (flip-y vel))))

(def-draw-system draw-ball
  {balls [:position :ball]}
  (each [{:x x :y y} {:color c :radius r}] balls
    (draw-circle (math/floor x) (math/floor y) r c)))

(def rng (math/rng (os/time)))
(defn create-ball [world col x y]
  (let [vx (- (* 20 (math/rng-uniform rng)) 10)
        vy (- (* 20 (math/rng-uniform rng)) 10)
        m (math/rng-int rng 10)]
    (add-entity world
                (position :x x :y y)
                (velocity :x vx :y vy)
                (acceleration :x 0 :y 0)
                (gravity :x 0 :y 0)
                (mass :val m)
                (ball :color col :radius (* m 2)))))

# Gamestate & Entity Creation
(def-gamestate main-game
  (for i 0 10
    (create-ball world (random-choice pallette rng) 150 100))

  (register-system world bounce-ball)
  (register-system world draw-ball))

(goto main-game)
(start)
