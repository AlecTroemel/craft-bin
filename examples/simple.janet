(use /craft-bin)

(init)

(def RNG (math/rng (os/time)))
(def PALLETE_CHOICES [[orangey-red rouge]
                      [bubblegum-pink warm-purple]
                      [azure medium-blue]
                      [toxic-green kelley-green]
                      [blue-green dark-aqua]
                      [yellowish yellowish-orange]])

# physics Walls around the borders of the screen
(defn create-wall [space vec-a vec-b thickness]
  (let [body (space-get-static-body space)
        shape (segment-shape-new body vec-a vec-b thickness)]
    (shape-set-friction shape 1)
    (shape-set-elasticity shape 0.9)
    (space-add-shape space shape)))

(defn create-walls [space]
  (create-wall space [0 0] [GAME_SCREEN_WIDTH 0] 1)
  (create-wall space [0 0] [0 GAME_SCREEN_HEIGHT] 1)
  (create-wall space [GAME_SCREEN_WIDTH 0] [GAME_SCREEN_WIDTH GAME_SCREEN_HEIGHT] 1)
  (create-wall space [0 GAME_SCREEN_HEIGHT] [GAME_SCREEN_WIDTH GAME_SCREEN_HEIGHT] 1))

# We hace some physics components in physics.janet, lets use em
(def-draw-system draw-circle
  {circles [:physics-body :circle :color]}
  (each [{:body body :shape shape} {:radius r} {:main mc :shadow sc}] circles
    (let [[x y] (map math/floor (body-get-position body))]
      (draw-circle (+ x 1) (+ y 1) r sc) # shadow
      (draw-circle x y r mc))))

(def-draw-system draw-box
  {boxes [:physics-body :box :color]}
  (each [{:body body :shape shape} {:width w :height h} {:main mc :shadow sc}] boxes
    (let [[center-x center-y] (body-get-position body)
          x (math/floor (- center-x (/ w 2)))
          y (math/floor (- center-y (/ h 2)))]

      (draw-rectangle (+ x 1) (+ y 1) w h sc) # shadow
      (draw-rectangle x y w h mc))))

(defn create-ball [world space]
  (let [[main-col shadow-col] (random-choice PALLETE_CHOICES RNG)
        x (+ 20 (math/rng-int RNG 150))
        y (+ 20 (math/rng-int RNG 100))
        vx (-> (math/rng-uniform RNG) (- 0.5) (* 300))
        vy (-> (math/rng-uniform RNG) (- 0.5) (* 300))
        mass (+ 5 (math/rng-int RNG 5))
        radius (* mass 2)]
    (add-entity world
                (physics-body (circle-body space mass radius)
                              :position [x y]
                              :velocity [vx vy])
                (color :main main-col :shadow shadow-col)
                (circle :radius radius))))

(defn create-box [world space]
  (let [[main-col shadow-col] (random-choice PALLETE_CHOICES RNG)
        x (+ 20 (math/rng-int RNG 150))
        y (+ 20 (math/rng-int RNG 100))
        vx (-> (math/rng-uniform RNG) (- 0.5) (* 300))
        vy (-> (math/rng-uniform RNG) (- 0.5) (* 300))
        mass (+ 5 (math/rng-int RNG 5))
        width (+ 15 (math/rng-int RNG 20))
        height (+ 15 (math/rng-int RNG 20))]
    (add-entity world
                (physics-body (box-body space mass width height)
                              :position [x y]
                              :velocity [vx vy])
                (color :main main-col :shadow shadow-col)
                (box :width width :height height))))

# shake screen give physics body some force when space bar pressed
# the singleton stuff is a little odd... should find better way to do this!
(def-update-system shake-physics-bodies
  {bodies [:physics-body]}
  (when (key-pressed? :space)
    (shake! :frames 5 :intensity 15)
    (each [{:body body}] bodies
      (body-set-velocity body [(-> (math/rng-uniform RNG) (- 0.5) (* 500))
                               (-> (math/rng-uniform RNG) (- 0.5) (* 500))]))))

(crafty-gamestate :main-game
   (create-walls space)
   (for i 0 10
     (create-ball world space)
     (create-box world space))
   (register-system world draw-box)
   (register-system world draw-circle)
   (register-system world shake-physics-bodies))

(start :main-game)
