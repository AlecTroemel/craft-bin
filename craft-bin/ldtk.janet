(use jaylib)
(use ./pallette)

(defn- level-load-bg-color [self]
  (let  [bg-color (get self :__bgColor)]
    (put self :bg-color
       (-> (string/replace "#" "0x" bg-color)
           (string "ff")
           (scan-number)))))

(defn get-tileset [tilesets tid]
  (find |(= tid (get $ :uid)) tilesets))

(defn- level-load-tilesets [self tilesets]
  (put self :tilesets @{})
  (loop [layer :in (self :layerInstances)
         :let [tid (layer :__tilesetDefUid)
               tileset (get-tileset tilesets tid)
               {:relPath relpath :tileGridSize grid-size} tileset]]
    (put-in self [:tilesets tid]
            {:texture (load-texture (string "examples/" relpath))
             :grid-size grid-size})))

(defn flipped-tile-rect [tx ty gs flip-bits]
  (match flip-bits
    0 [tx ty gs gs]
    1 [tx ty (- 0 gs) gs]
    2 [tx ty gs (- 0 gs)]
    3 [tx ty (- 0 gs) (- 0 gs)]))

(defn- level-draw-autolayer [layer tilesets camera]
  (loop [tile :in (layer :autoLayerTiles)
         :let [{:__tilesetDefUid tid
                :parallaxScaling parallax?
                :parallaxFactorX parallax-x
                :parallaxFactory parallax-y} layer
               {:texture texture :grid-size gs} (get tilesets tid)
               {:px [px py] :src [tx ty] :f flip-bits} tile
               position [(+ px (camera 0))
                         (+ py (camera 1))]
               position (if parallax?
                          [(* (position 0) parallax-x)
                           (* (position 1) parallax-y)]
                          position)

               tile-rect (flipped-tile-rect tx ty gs flip-bits)]]
    (draw-texture-rec texture
                      tile-rect
                      position
                      white)))

(defn- level-draw [self &named camera]
  (default camera [0 0])
  (loop [layer :in (reverse (self :layerInstances))
         :let [layer-type (layer :__type)]]
    (match layer-type
      "IntGrid" (level-draw-autolayer layer
                                      (get self :tilesets)
                                      camera))))

(defn- level-clear-background [self]
  (clear-background (get self :bg-color)))

(def LdtkLevel
  @{:clear-background level-clear-background
    :draw level-draw})

(defn ldtk-level [project lvl-id]
  (let [lvl (get-in project [:levels lvl-id])
        tilesets (get-in project [:defs :tilesets])]
    (level-load-bg-color lvl)
    (level-load-tilesets lvl tilesets)
    (table/setproto lvl LdtkLevel)))
