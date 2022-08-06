(use junk-drawer)

(use ./juice)

(defmacro def-update-system [name queries & body]
  ['def-system name queries
   ~(when (not (,frozen?)) ,;body)])

(defmacro def-draw-system [name queries & body]
  ['def-system name queries ;body])
