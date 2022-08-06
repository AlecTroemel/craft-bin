# TODO "text mode" abstraction, think similar to tic-80's map
(use jaylib)
(use junk-drawer)

(use ./systems)

(defmacro def-font [name &named path char-width char-height]
  ~(def ,name ,(table/setproto
                @{:path path
                  :texture ~(load-texture ,path)
                  :char-width char-width
                  :char-height char-height}
                @{})))

(defn unload-font [{:texture texture}]
  (unload-texture texture))

# stamps are like maps, pick a font and place sprites in location
# can flip sprites vertically and horizontally
(def pattern-proto {})

(defmacro def-pattern [name font & data]
  ~(def ,name (struct/with-proto pattern-proto
                                 :font ,font
                                 :data ,(struct ;data))))

# Stamps are components that draw patterns
(def-component stamp :pattern :struct)

(def-draw-system draw-stamp
  {stamps [:position :stamp]}

  (each [pos st] stamps
    (let [pattern-data (get-in st [:pattern :data])
          font-texture (get-in st [:pattern :font :texture])
          font-w (get-in st [:pattern :font :char-width])
          font-h (get-in st [:pattern :font :char-height])
          frame-rec [0 0 font-w font-h]]

      (loop [[offset t-coord] :pairs pattern-data]
        (draw-texture-rec font-texture
                          [(* (t-coord :x) font-w)
                           (* (t-coord :y) font-h)
                           font-w font-h]
                          [(+ (pos :x) (* (offset 0) font-w))
                           (+ (pos :y) (* (offset 1) font-h))]
                          :white))))
  )


(defn register-stamps [world]
  (register-system world draw-stamp))
