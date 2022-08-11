# TODO finish defining a bunch of vector functions. steal from lua's humps lib
#      https://github.com/vrld/hump/blob/master/vector.lua

(defn- clone [self]
  (table/setproto @{:x (self :x)
                    :y (self :y)}
                  (table/getproto self)))

(defn- len [{:x x :y y}]
  (math/sqrt (+ (* x x) (* y y))))

(defn- mult [self val]
  (put self :x (* (self :x) val))
  (put self :y (* (self :y) val)))

(defn- div [self val]
  (put self :x (/ (self :x) val))
  (put self :y (/ (self :y) val)))

(defn- add-vec [self vec2]
  (put self :x (+ (self :x) (vec2 :x)))
  (put self :y (+ (self :y) (vec2 :y))))

(defn- mult-vec [self vec2]
  (put self :x (* (self :x) (vec2 :x)))
  (put self :y (* (self :y) (vec2 :y))))

(defn- normalize [self]
  (when-let [l (:len self)
             not-zero? (> l 0)]
    (put self :x (/ (self :x) l))
    (put self :x (/ (self :x) l))))

(defn vector [x y]
  (assert (= (type x) :number) ":x must be of type :number")
  (assert (= (type y) :number) ":y must be of type :number")
  (table/setproto @{:x x :y y}
                  @{:clone clone
                    :len len
                    :mult mult
                    :div div
                    :add-vec add-vec
                    :mult-vec mult-vec
                    :normalize normalize}))
