# Global Gamestate helpers
(use junk-drawer)

(use ./juice)

(def GS (gamestate/init))

(defmacro def-gamestate [name args & body]
  ~(def ,name @{:name ,(string (keyword name))
                :world (create-world)
                :init (fn ,args ,;body)
                :update (fn [self dt]
                          (:update (self :world) dt)
                          (freeze-tic)
                          (shake-tic))}))

(defmacro goto [name]
  ~(:push GS ,name))

(defmacro def-update-system [name queries & body]
  ['def-system name queries
   ~(when (not (frozen?)) ,;body)])

(defmacro def-draw-system [name queries & body]
  ['def-system name queries ;body])
