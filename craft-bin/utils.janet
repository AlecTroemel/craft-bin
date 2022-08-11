(defn round-precision [val digits]
  (let [p (math/pow 10 digits)]
    (/ (math/round (* p val)) p)))
