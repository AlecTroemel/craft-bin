(use junk-drawer)

(use ./systems)

(def-component position :x :number :y :number)
(def-component velocity :x :number :y :number)

(def-update-system apply-velocity
  {moveables [:position :velocity]}
  (each [pos vel b] moveables
    (put pos :x (+ (pos :x) (* dt (vel :x))))
    (put pos :y (+ (pos :y) (* dt (vel :y))))))


(defn register-physics [world]
  (register-system world apply-velocity))
