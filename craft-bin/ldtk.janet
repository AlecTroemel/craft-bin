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

(defn- level-draw [self [camera-offset-x camera-offset-y]]
  (loop [layer :in (self :layerInstances)
         tile :in (layer :autoLayerTiles)
         :let [tid (layer :__tilesetDefUid)
               {:texture texture :grid-size gs} (get-in self [:tilesets tid])
               {:px [px py] :src [tx ty]} tile
               position [(+ px camera-offset-x)
                         (+ py camera-offset-y)]
               tile-rec [tx ty gs gs]]]
    (draw-texture-rec texture
                      tile-rec
                      position
                      white)))

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
