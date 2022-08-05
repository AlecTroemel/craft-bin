(import jaylib :prefix "" :export true)
(import junk-drawer :prefix "" :export true)

# Freeze juice
(var FREEZE 0)
(defn freeze! [&named frames] (set FREEZE frames))

# TODO Shake juice
(defn shake! [&named frames intensity] nil)

# Global Gamestate helpers
(def GS (gamestate/init))

(defmacro def-rubish-gamestate [name args & body]
  ~(def ,name @{:name ,(string (keyword name))
                :world (create-world)
                :init (fn ,args ,;body)
                :update (fn [self dt]
                          (:update (self :world) dt)
                          (when (> FREEZE 0)
                            (-= FREEZE 1)))}))

(defmacro goto [name]
  ~(:push GS ,name))

(defmacro def-update-system [name queries & body]
  ['def-system name queries ~(when (= 0 FREEZE) ,;body)])

(defmacro def-draw-system [name queries & body]
  ['def-system name queries ;body])


# TODO nice default pixel art font

# Smooth Pixel Perfect renderer with raylib
# TODO CRT shader
# - https://www.shadertoy.com/view/XsjSzR
# - https://www.reddit.com/r/crtgaming/comments/f6rcxy/modern_pixel_art_games_on_crts_are_my_aesthetic/
# - https://babylonjs.medium.com/retro-crt-shader-a-post-processing-effect-study-1cb3f783afbc
(def SCREEN_WIDTH 320)
(def SCREEN_HEIGHT 180)

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
        target (load-render-texture 320 180)]

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
