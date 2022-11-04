# Global Gamestate helpers
(use jaylib)
(use junk-drawer)
(use chipmunk)

(use ./pallette)
(use ./shapes)
(use ./juice)
(use ./physics)

(def *GS* (gamestate/init))

(defn- crafty-gamestate-update [self dt]
  (clear-background white)
  (space-step (self :physics-space) dt)
  (:update (self :world) dt)
  (put self :camera-offset (SHAKE :offset))
  (freeze-tic)
  (shake-tic))

# ~(->>
#   (:add-state *GS*))

(defmacro crafty-gamestate [name & body]
  ~(:add-state *GS*
               (gamestate/state ,name
                :world (,create-world)
                :camera-target [0 0]
                :camera-offset [0 0]
                :physics-space (,space-new)
                :physics-gravity [0 200]
                :update ,crafty-gamestate-update
                :init (fn [{:world world
                            :physics-gravity gravity
                            :physics-space space }]
                        (,space-set-gravity space gravity)
                        (,register-shapes world)
                        (,register-physics world)
                        ,;body))))

(defn goto [state-name]
  (:goto *GS* state-name))
