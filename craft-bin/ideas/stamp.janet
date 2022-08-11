# TODO "text mode" abstraction, think similar to tic-80's map
# void ImageDrawTextEx(Image *dst, Font font, const char *text, Vector2 position, float fontSize, float spacing, Color tint);
(use jaylib)
(use junk-drawer)

(use ./systems)

(defmacro def-font [name &named path char-width char-height]
  ~(def ,name ,(table/setproto
                @{:path path
                  :image ~(,load-image-1 ,path)
                  :char-width char-width
                  :char-height char-height}
                @{})))

# stamps are like maps, pick a font and place sprites in location
# can flip sprites vertically and horizontally
(defn pattern-data-to-texture [font data]
  (pp data)
  (let [{:image font-image :char-width font-w :char-height font-h} font

        final-w 16
        final-h 16

        final-image (gen-image-color final-w final-h :white)]

    (loop [[offset t-data] :pairs data
           :let [char-rec [(* font-w (t-data :x)) (* font-h (t-data :y)) 8 8]
                 char-image (image-from-image font-image char-rec)]]

      (image-color-replace char-image :black (t-data :bg))
      (image-color-replace char-image :white (t-data :fg))

      (image-draw final-image char-image
                  [0 0 8 8]
                  [(* font-w (offset :x)) (* font-h (offset :y)) 8 8]
                  :white))

    (load-texture-from-image final-image)))

(defmacro def-pattern [name font & data]
  ~(def ,name @{:texture (,pattern-data-to-texture ,font ,data)}))

# Stamps are components that draw patterns
(def-component stamp :pattern :struct)

(def-draw-system draw-stamp
  {stamps [:position :stamp]}

  (each [pos st] stamps


    ))


(defn register-stamps [world]
  (register-system world draw-stamp))

# TODO need to set color from pallete when drawing texture rec
#      https://github.com/raysan5/raylib/blob/master/examples/shaders/shaders_palette_switch.c
#      https://github.com/raysan5/raylib/blob/master/examples/shaders/resources/shaders/glsl330/palette_switch.fs
