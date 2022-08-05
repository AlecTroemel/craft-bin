# TODO "text mode" abstraction, think similar to tic-80's map
(use junk-drawer)

(defmacro def-font [name &named path char-width char-height]
  ['def name {:path path
              :char-width char-width
              :char-height char-height}])

# stamps are like maps, pick a font and place sprites in location
# can flip sprites vertically and horizontally
(def-macro def-pattern [{:font font} & data]
  {:font font :data data})

# Stamps are components that draw patterns
(def-component stamp :pattern :object)

# TODO
(def-system draw-stamp
  {stamps [:position :stamp]}
  nil)

# Example Here
# 1. define your font from a png
(def-font mrmo-shapes
  :path "assets/fonts/mrmo-shapes.png"
  :char-width 8
  :char-height 8)

# 2. Create patterns.
(def-pattern my-pattern-name
  :font mrmo-shapes
  [0 0] {:sprite 36 :fg 7 :bg 0 :flip-v false :flip-h false}
  [1 2] {:sprite 122 :fg 5 :bg 3 :flip-v false :flip-h true})

# 3. finally stamp the pattern to an entity.
(add-entity world
            (position :x 1 :y 20)
            (stamp :pattern my-pattern-name))
