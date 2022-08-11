(use jaylib)
(use junk-drawer)
(use ./systems)

(def-component circle :color :number :radius :number)
(def-component rectangle :color :number :width :number :height :number)

(def-draw-system draw-circle
  {circles [:position :circle]}
  (each [{:x x :y y} {:color c :radius r}] circles
    (draw-circle (math/floor x) (math/floor y) r c)))

(def-draw-system draw-rectangle
  {rectangles [:position :rectangle]}
  (each [{:x x :y y} {:color c :width w :height h}] rectangles
    (draw-rectangle (math/floor x) (math/floor y) w h c)))

(defn register-shapes [world]
  (register-system world draw-circle)
  (register-system world draw-rectangle))
