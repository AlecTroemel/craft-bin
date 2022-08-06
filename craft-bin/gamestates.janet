# Global Gamestate helpers
(use jaylib)
(use junk-drawer)

(use ./juice)

(def GS (gamestate/init))

(defmacro def-gamestate [name args & body]
  ~(def ,name @{:name ,(string (keyword name))
                :world (create-world)
                # :camera (camera-2d :zoom 1.0 :offset (SHAKE :offset))
                :init (fn ,args ,;body)
                :update (fn [self dt]
                          (let [camera (camera-2d :zoom 1.0 :offset (SHAKE :offset))]
                            (begin-mode-2d camera)
                            (:update (self :world) dt)
                            (end-mode-2d))

                          (freeze-tic)
                          (shake-tic))}))

(defmacro goto [name]
  ~(:push GS ,name))

(defmacro def-update-system [name queries & body]
  ['def-system name queries
   ~(when (not (frozen?)) ,;body)])

(defmacro def-draw-system [name queries & body]
  ['def-system name queries ;body])
