# Global Gamestate helpers
(use jaylib)
(use junk-drawer)

(use ./physics)
(use ./juice)
(use ./stamp)

(def GS (gamestate/init))

(defmacro def-gamestate [name & body]
  ~(def ,name @{:name ,(string (keyword name))
                :world (,create-world)
                :camera-target @{:x 0 :y 0}
                :camera-offset @{:x 0 :y 0}

                :init (fn [{:world world}]
                        (,register-physics world)
                        (,register-stamps world)
                        ,;body)
                :update (fn [self dt]
                          (:update (self :world) dt)
                          (,freeze-tic)
                          (,shake-tic))}))

(defmacro goto [name]
  ~(:push GS ,name))
