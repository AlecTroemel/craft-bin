# DONE Smooth Pixel Perfect renderer with raylib
# TODO setup raylib camera


# TODO CRT shader
# - https://www.shadertoy.com/view/XsjSzR
# - https://www.reddit.com/r/crtgaming/comments/f6rcxy/modern_pixel_art_games_on_crts_are_my_aesthetic/
# - https://babylonjs.medium.com/retro-crt-shader-a-post-processing-effect-study-1cb3f783afbc

(use jaylib)

(use ./gamestates)

(def GAME_SCREEN_WIDTH 256)
(def GAME_SCREEN_HEIGHT 144)

(var START_SCREEN_WIDTH 1280)
(var START_SCREEN_HEIGHT 720)

(defn init []
  (set-config-flags :window-resizable :vsync-hint)
  (init-window START_SCREEN_WIDTH START_SCREEN_HEIGHT "Test Game")
  (set-window-min-size GAME_SCREEN_WIDTH GAME_SCREEN_HEIGHT)
  (set-target-fps 60)
  (hide-cursor))

(defn apply-gamestate-camera-offset [world-space-camera]
  (put world-space-camera :offset
     (get (:current GS) :camera-offset [0 0])))

(defn round-worldspace-coordinates [world-space-camera screen-space-camera scale]
  "Round worldSpace coordinates, keep decimals into screenSpace coordinates."
  (let [[camera-x camera-y] (get (:current GS) :camera-target [0 0])
        rounded-camera-x (math/round camera-x)
        rounded-camera-y (math/round camera-y)]
    (put world-space-camera :target
       [rounded-camera-x rounded-camera-y])
    (put screen-space-camera :target
       [(* (- camera-x rounded-camera-x) scale)
        (* (- camera-y rounded-camera-y) scale)])))

(defn start []
  (let [world-space-camera (camera-2d :zoom 1.0 )
        screen-space-camera (camera-2d :zoom 1.0)
        target (load-render-texture GAME_SCREEN_WIDTH GAME_SCREEN_HEIGHT)]

    (while (not (window-should-close))
      (let [screen-width (get-screen-width)
            screen-height (get-screen-height)
            scale (min (math/floor (/ screen-width GAME_SCREEN_WIDTH))
                       (math/floor (/ screen-height GAME_SCREEN_HEIGHT)))
            source-rect [0 0 GAME_SCREEN_WIDTH (- GAME_SCREEN_HEIGHT)]
            dest-rect [(/ (- screen-width (* GAME_SCREEN_WIDTH scale)) 2)
                       (/ (- screen-height (* GAME_SCREEN_HEIGHT scale)) 2)
                       (* GAME_SCREEN_WIDTH scale)
                       (* GAME_SCREEN_HEIGHT scale)]]
        (apply-gamestate-camera-offset world-space-camera)
        (round-worldspace-coordinates world-space-camera screen-space-camera scale)

        (begin-texture-mode target)
          (begin-mode-2d world-space-camera)
            (clear-background :ray-white)
            (:update GS 1)
          (end-mode-2d)
        (end-texture-mode)

        (begin-drawing)
          (clear-background :black)
          (begin-mode-2d screen-space-camera)
            (draw-texture-pro (get-render-texture-texture2d target)
                              source-rect dest-rect [0 0] 0.0 :white)
          (end-mode-2d)
        (end-drawing)))

    (unload-render-texture target)
    (close-window)))
