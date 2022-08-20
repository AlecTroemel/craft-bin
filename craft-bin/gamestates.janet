# Global Gamestate helpers
(use jaylib)
(use junk-drawer)
(use chipmunk)

(use ./shapes)
(use ./juice)
(use ./physics)

(def GS (gamestate/init))

(defmacro def-gamestate [name & body]
  ~(def ,name @{:name ,(string (keyword name))
                :world (,create-world)

                :camera-target [0 0]
                :camera-offset [0 0]

                :physics-space (,space-new)
                :physics-gravity [0 200]

                :init (fn [{:world world
                            :physics-gravity gravity
                            :physics-space space }]
                        (,space-set-gravity space gravity)
                        (,register-shapes world)
                        (,register-physics world)
                        ,;body)

                :update (fn [self dt]
                          (clear-background white)
                          (space-step (self :physics-space) dt)
                          (:update (self :world) dt)
                          (put self :camera-offset (SHAKE :offset))
                          (,freeze-tic)
                          (,shake-tic))}))

(defmacro goto [name]
  ~(:push GS ,name))
