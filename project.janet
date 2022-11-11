(declare-project
 :name "craft-bin"
 :description "junk-drawer + jaylib + chipmunk2d + Elmers Glue = environment for game jams"
 :author "Alec Troemel"
 :license "MIT"
 :dependencies ["spork"
                "https://github.com/AlecTroemel/junk-drawer.git"
                "https://github.com/AlecTroemel/jaylib.git"
                "https://github.com/AlecTroemel/janet-chipmunk.git"])

(declare-source
 :source @["craft-bin" "craft-bin.janet"])
