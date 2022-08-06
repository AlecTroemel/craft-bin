# Global Gamestate helpers
(use jaylib)
(use junk-drawer)

(use ./physics)
(use ./juice)

(def GS (gamestate/init))

(defmacro def-gamestate [name & body]
  ~(def ,name @{:name ,(string (keyword name))
                :world (create-world)
                # :camera (camera-2d :zoom 1.0 :offset (SHAKE :offset))
                :init (fn [{:world world}]
                        (,register-physics world)
                        ,;body)
                :update (fn [self dt]
                          (let [camera (camera-2d :zoom 1.0 :offset (SHAKE :offset))]
                            (begin-mode-2d camera)
                            (:update (self :world) dt)
                            (end-mode-2d))

                          (freeze-tic)
                          (shake-tic))}))

(defmacro goto [name]
  ~(:push GS ,name))
