(use /craft-bin)

(init)

(print "a")
# 1. Define your font from a png
(def-font mrmo-shapes
  :path "./examples/MRMOTEXT.png"
  :char-width 8
  :char-height 8)

(print "b")

# 2. Create patterns (maps).
(def-pattern my-pattern
  mrmo-shapes
  [0 0] {:x 4 :y 0 :bg navy-blue :fg white}
  # [1 1] {:x 2 :y 0 :bg burgundy :fg white}
  )

(print "c")


# 3. finally create entity with stamp component.
(def-gamestate main-game
  (add-entity world
              (position :x (/ SCREEN_WIDTH 2) :y (/ SCREEN_HEIGHT 2))
              (stamp :pattern my-pattern)))

(goto main-game)
(start)
