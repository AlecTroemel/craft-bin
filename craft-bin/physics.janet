(use junk-drawer)
(use chipmunk)


(defn physics-body [{:body body :shape shape} &named friction elasticity position velocity]
  (default friction 0.7)
  (default elasticity 0.9)
  (default position [0 0])
  (default velocity [0 0])

  (shape-set-friction shape friction)
  (shape-set-elasticity shape elasticity)
  (body-set-position body position)
  (body-set-velocity body velocity)

  {:body body
   :shape shape
   :__id__ :physics-body
   :__validate__ (fn [& args] true)})

(defn circle-body [space mass radius]
  (let [moment (moment-for-circle mass 0 radius [0 0])
        body (space-add-body space (body-new mass moment))
        shape (space-add-shape space (circle-shape-new body radius [0 0]))]
    {:body body
     :shape shape
     :__id__ :physics-body
     :__validate__ (fn [& args] true)}))

(defn box-body [space mass width height]
  (let [moment (moment-for-box mass width height)
        body (space-add-body space (body-new mass moment))
        shape (space-add-shape space (box-shape-new body width height 1))]
    {:body body
     :shape shape
     :__id__ :physiscs-body
     :__validate__ (fn [& args] true)}))

(defn register-physics [world] nil)
