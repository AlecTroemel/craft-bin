(use /craft-bin)

(init)

# 1. Define your font from a png
(def-font mrmo-shapes
  :path "./examples/MRMOTEXT.png"
  :char-width 8
  :char-height 8)

# 2. Create patterns (maps).
(def-pattern my-pattern
  mrmo-shapes
  [0 0] {:x 4 :y 0}
  [1 1] {:x 2 :y 0})

# 3. finally create entity with stamp component.
(def-gamestate main-game
  (add-entity world
              (position :x (/ SCREEN_WIDTH 2) :y (/ SCREEN_HEIGHT 2))
              (stamp :pattern my-pattern)))

(goto main-game)
(start)
