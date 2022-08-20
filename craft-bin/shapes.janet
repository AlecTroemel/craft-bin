(use jaylib)
(use junk-drawer)

(use ./systems)

(def-component color :main :number :shadow :number)
(def-component circle :radius :number)
(def-component box :width :number :height :number)

# (def-draw-system draw-circle
#   {circles [:position :circle :color]}
#   (each [{:x x :y y} {:radius r} {:val c}] circles
#     (draw-circle (math/floor x) (math/floor y) r c)))

# (def-draw-system draw-rectangle
#   {rectangles [:position :rectangle :color]}
#   (each [{:x x :y y} {:width w :height h} {:val c}] rectangles
#     (draw-rectangle (math/floor x) (math/floor y) w h c)))

(defn register-shapes [world]
  # (register-system world draw-circle)
  # (register-system world draw-rectangle)
  )
