# Just ideas right now
# instrument have adsr attack env and a waveform type
#                            a   d  s r
(defn my-sine (waveform/sine 10 2.3 6 9))
(put my-sine :a 5)
(get my-sine :r) # -> 9




# Racks are an instruments + list of effects
(def-rack reverbed-sine-pluck
  :instrument my-sine
  :effects [(reverb :length 4.2 :mix 0.3)])
(put-in reverbed-sine-pluck [:effects 0 :length] 2.8)

# there are functions that create sequence of notes
(def melody (scale :C4 :major-pentatonic :octaves 3))
(def base (notes :G1 :C1 :A1 :F1))
(def from-midi (load-midi "song-part.midi"))

(def-player melody-verse-1
  :rack reverbed-sine-pluck
  :notes melody
  :tempo 4
  :volume 0.8)

(:tick melody-verse-1)

# songs
(def-song my-song
  :start :verse
  :verse [melody-verse-1 bass-verse-1]
  :chorus [melody-chorus-1 bass-chorus-1]
  :transition [melody-trans-1 bass-trans-1])

# play through the given song parts to the last one
(play-through my-song :transition :chorus)

(play-through my-song
              (pick-closest-beat
                 1 :transition-1-beat
                 2 :transition-2-beat
                 3 :transition-3-beat
                 4 :transition-4-beat)
              :chorus)
