# Global Gamestate helpers
(use jaylib)
(use junk-drawer)

(use ./physics)
(use ./juice)


(def GS (gamestate/init))

(defmacro def-gamestate [name & body]
  ~(def ,name @{:name ,(string (keyword name))
                :world (,create-world)
                :camera-target [0 0]
                :camera-offset [0 0]

                :init (fn [{:world world}]
                        (,register-physics world)
                        ,;body)

                :update (fn [self dt]
                          (:update (self :world) dt)
                          (put self :camera-offset (SHAKE :offset))
                          (,freeze-tic)
                          (,shake-tic))}))

(defmacro goto [name]
  ~(:push GS ,name))
