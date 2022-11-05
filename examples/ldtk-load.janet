(use /craft-bin)

(init)

(var t 0)

(gamestate/def-state main
   :project (load-json "./examples/cavernas.ldtk")
   :camera-target [0 0]
   :camera-offset @[0 0]
   :update ,crafty-gamestate-update
   :init (fn main-init [self]
           (put self :lvl (ldtk-level (self :project) 0)))
   :update (fn main-update [self dt]
             (put-in self [:camera-offset 0]
                     (- (* (math/sin t) 10)
                        32))
             (put-in self [:camera-offset 1]
                     (- (* (math/sin (* t 2)) 8)
                        32))
             (+= t 0.01)
             (:clear-background (self :lvl))
             (:draw (self :lvl)
                    :camera (self :camera-offset))))

(:add-state *GS* main)
(start :main)
