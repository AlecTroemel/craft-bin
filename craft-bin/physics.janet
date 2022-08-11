(use junk-drawer)

(use ./systems)


# TODO define a bunch of vector functions. steal from lua's humps lib
#      https://github.com/vrld/hump/blob/master/vector.lua

(defn clone [self]
  (table/setproto @{:x (self :x)
                    :y (self :y)}
                  (table/getproto self)))

(defn len [{:x x :y y}]
  (math/sqrt (+ (* x x) (* y y))))

(defn mult [self val]
  (put self :x (* (self :x) val))
  (put self :y (* (self :y) val)))

(defn div [self val]
  (put self :x (/ (self :x) val))
  (put self :y (/ (self :y) val)))

(defn add-vec [self vec2]
  (put self :x (+ (self :x) (vec2 :x)))
  (put self :y (+ (self :y) (vec2 :y))))

(defn mult-vec [self vec2]
  (put self :x (* (self :x) (vec2 :x)))
  (put self :y (* (self :y) (vec2 :y))))

(defn normalize [self]
  (when-let [l (:len self)
             not-zero? (> l 0)]
    (put self :x (/ (self :x) l))
    (put self :x (/ (self :x) l))))

(def vector-proto @{:clone clone
                    :len len
                    :mult mult
                    :div div
                    :add-vec add-vec
                    :mult-vec mult-vec
                    :normalize normalize})

(defn vector [x y]
  (assert (= (type x) :number) ":x must be of type :number")
  (assert (= (type y) :number) ":y must be of type :number")
  (table/setproto @{:x x :y y} vector-proto))

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
