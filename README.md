# Craft Bin

```janet
(def craft-bin
  (+ :janet # a wonderful lisp like language
     :jaylib # bindings to Raylib graphics library
     :junk-drawer # ECS + other gamedev tools
     :janet-chipmunk # 2D rigid body physics
     :elmers-glue)) # great tasting and fast drying
```

(Soon to be) A "game jam ready" environment.

- [ ] Smooth Brain Developemnt:
  - [ ] Super Quick Iteration: Handy commands to live reload on code changes
  - [ ] building web version for itch.io is one command away
- [X] Retro Aesthetic
  - [X] chunky screen pixel 16:9 resolution of 320x180
  - [X] mathematically perfect default color pallete
- [ ] Betteries Included
  - [ ] lots of ready to use ECS systems and components
     - [ ] physics built on chipmunk 2d
     - [ ] Sprite + Animations
  - [X] screenshake
  - [X] freeze frame
  - [ ] map loading using LDtk
