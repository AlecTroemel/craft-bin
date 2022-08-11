(use junk-drawer)

(use ./systems)
(use ./vector)

(defn position [&named x y] (vector x y))
(defn velocity [&named x y] (vector x y))
(defn acceleration [&named x y] (vector x y))
(defn gravity [&named x y] (vector x y))

(def-component mass :val :number)

(def-update-system apply-friction
  {moveables [:acceleration :velocity :mass]}
  (each [acc vel {:val mas}] moveables
    (:add-vec acc (-> vel
                      (:clone)
                      (:mult (* -1 0.01 mas))))))

(def-update-system apply-gravity
  {moveables [:acceleration :gravity]}
  (each [acc grav] moveables
    (:add-vec acc grav)))

(def-update-system apply-acceleration
  {moveables [:velocity :acceleration]}
  (each [vel acc] moveables
    (:add-vec vel (-> acc (:clone) (:mult dt)))))

(def-update-system apply-velocity
  {moveables [:position :velocity]}
  (each [pos vel] moveables
    (:add-vec pos (-> vel (:clone) (:mult dt)))))

(def-update-system reset-acceleration
  {moveables [:acceleration]}
  (each [acc] moveables
    (:mult acc 0)))

(defn register-physics [world]
  (register-system world apply-friction)
  (register-system world apply-gravity)
  (register-system world apply-acceleration)
  (register-system world apply-velocity)
  (register-system world reset-acceleration))
