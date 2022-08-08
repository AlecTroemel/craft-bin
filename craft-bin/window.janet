# DONE Smooth Pixel Perfect renderer with raylib
# TODO setup raylib camera


# TODO CRT shader
# - https://www.shadertoy.com/view/XsjSzR
# - https://www.reddit.com/r/crtgaming/comments/f6rcxy/modern_pixel_art_games_on_crts_are_my_aesthetic/
# - https://babylonjs.medium.com/retro-crt-shader-a-post-processing-effect-study-1cb3f783afbc

(use jaylib)

(use ./gamestates)

(def SCREEN_WIDTH 256)
(def SCREEN_HEIGHT 144)

(def REAL_SCREEN_WIDTH 1280)
(def REAL_SCREEN_HEIGHT 720)

(def VIRTUAL_RATIO (/ REAL_SCREEN_WIDTH SCREEN_WIDTH))

(defn init []
  (init-window REAL_SCREEN_WIDTH REAL_SCREEN_HEIGHT "Test Game")
  (set-target-fps 60)
  (hide-cursor))

(defn apply-gamestate-camera-offset [world-space-camera]
  (let [gs-offset (get-in GS [:current :camera-offset] {:x 0 :y 0})
        x (gs-offset :x)
        y (gs-offset :y)]
    (set-camera-2d-offset world-space-camera [x y])))

(defn round-worldspace-coordinates [world-space-camera screen-space-camera]
  "Round worldSpace coordinates, keep decimals into screenSpace coordinates."
  (let [{:x camera-x :y camera-y} (get (:current GS) :camera-target {:x 0 :y 0})
        rounded-camera-x (math/round camera-x)
        rounded-camera-y (math/round camera-y)]
    (set-camera-2d-target world-space-camera [rounded-camera-x rounded-camera-y])
    (set-camera-2d-target screen-space-camera
                          [(* (- camera-x rounded-camera-x) VIRTUAL_RATIO)
                           (* (- camera-y rounded-camera-y) VIRTUAL_RATIO)])))

(defn start []
  (let [source-rect [0 0 SCREEN_WIDTH (- SCREEN_HEIGHT)]
        dest-rect [(- VIRTUAL_RATIO) (- VIRTUAL_RATIO)
                   (+ REAL_SCREEN_WIDTH (* VIRTUAL_RATIO 2))
                   (+ REAL_SCREEN_HEIGHT (* VIRTUAL_RATIO 2))]

        world-space-camera (camera-2d :zoom 1.0 )
        screen-space-camera (camera-2d :zoom 1.0)

        target (load-render-texture SCREEN_WIDTH SCREEN_HEIGHT)]

    (while (not (window-should-close))
      (apply-gamestate-camera-offset world-space-camera)
      (round-worldspace-coordinates world-space-camera screen-space-camera)

      (begin-texture-mode target)
      (begin-mode-2d world-space-camera)
      (clear-background :ray-white)
      (:update GS 1)
      (end-mode-2d)
      (end-texture-mode)

      (begin-drawing)
        (clear-background :red)
        (begin-mode-2d screen-space-camera)
          (draw-texture-pro (get-render-texture-texture2d target)
                            source-rect dest-rect [0 0] 0.0 :white)
        (end-mode-2d)
      (end-drawing))

    (unload-render-texture target)
    (close-window)))
