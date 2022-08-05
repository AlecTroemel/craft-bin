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

(defn start []
  (init-window REAL_SCREEN_WIDTH REAL_SCREEN_HEIGHT "Test Game")
  (set-target-fps 60)
  (hide-cursor)

  (let [virtual-ratio (/ REAL_SCREEN_WIDTH SCREEN_WIDTH)
        source-rect [0 0 SCREEN_WIDTH SCREEN_HEIGHT]
        dest-rect [(- virtual-ratio) (- virtual-ratio)
                   (+ REAL_SCREEN_WIDTH (* virtual-ratio 2))
                   (+ REAL_SCREEN_HEIGHT (* virtual-ratio 2))]
        world-space-camera (camera-2d :zoom 1.0)
        screen-space-camera (camera-2d :zoom 1.0)
        target (load-render-texture SCREEN_WIDTH SCREEN_HEIGHT)]

    (while (not (window-should-close))
      (begin-texture-mode target)
      (clear-background :ray-white)
      (:update GS 1)
      (end-texture-mode)

      (begin-drawing)
      (clear-background :red)
      (draw-texture-pro (get-render-texture-texture2d target)
                        source-rect dest-rect [0 0] 0.0 :white)
      (end-drawing))

    (unload-render-texture target)
    (close-window)))
