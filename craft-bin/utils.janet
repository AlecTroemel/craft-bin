(defn round-precision [val digits]
  (let [p (math/pow 10 digits)]
    (/ (math/round (* p val)) p)))

(defn random-choice [ind &opt rng]
  (default rng (math/rng))
  (ind (math/rng-int rng (length ind))))
