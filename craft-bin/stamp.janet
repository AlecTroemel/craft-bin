# TODO "text mode" abstraction, think similar to tic-80's map
(use jaylib)
(use junk-drawer)

(defmacro def-font [name &named path char-width char-height]
  ['def name {:path path
              :texture ~(load-texture ,path)
              :char-width char-width
              :char-height char-height}])

(defn unload-font [{:texture texture}]
  (unload-texture texture))

# # stamps are like maps, pick a font and place sprites in location
# # can flip sprites vertically and horizontally
# (def-macro def-pattern [{:font font} & data]
#   {:font font :data data})

# # Stamps are components that draw patterns
# (def-component stamp :pattern :object)

# # TODO
# (def-system draw-stamp
#   {stamps [:position :stamp]}
#   nil)
