(use spork)

(defn round-precision [val digits]
  (let [p (math/pow 10 digits)]
    (/ (math/round (* p val)) p)))

(defn random-choice [ind &opt rng]
  (default rng (math/rng))
  (ind (math/rng-int rng (length ind))))

(defn load-json [ldtk-file]
  (let [f (file/open ldtk-file :r)
        content  (file/read f :all)]
    (file/close f)
    (json/decode content :keywords)))
