(use /craft-bin)

(init)

(gamestate/def-state main
   :project (load-json "./examples/cavernas.ldtk")
   :camera-target [0 0]
   :camera-offset [0 0]
   :update ,crafty-gamestate-update
   :init (fn main-init [self]
           (put self :lvl (ldtk-level (self :project) 0)))
   :update (fn main-update [self dt]
             (:clear-background (self :lvl))
             (:draw (self :lvl) (self :camera-offset))))

(:add-state *GS* main)
(start :main)
