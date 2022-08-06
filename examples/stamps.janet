(use /craft-bin)

# 1. define your font from a png
(def-font mrmo-shapes
  :path "./examples/MRMOTEXT.png"
  :char-width 8
  :char-height 8)


(unload-font mrmo-shapes)

# 2. Create patterns.
# (def-pattern my-pattern-name
#   :font mrmo-shapes
#   [0 0] {:sprite 36 :fg 7 :bg 0 :flip-v false :flip-h false}
#   [1 2] {:sprite 122 :fg 5 :bg 3 :flip-v false :flip-h true})

# # 3. finally stamp the pattern to an entity.
# (add-entity world
#             (position :x 1 :y 20)
#             (stamp :pattern my-pattern-name))
