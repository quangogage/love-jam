# Fortune's Favor
Made over the course of ~a week for [LOVEJAM 2024](https://itch.io/jam/love2d-jam-2024)



![Gameplay preview](https://github.com/quangogage/love-jam/blob/main/assets/screenshots/preview-gif-large.gif?raw=true)

## Getting started
Install [love](https://love2d.org/)  
  
`love .`

## General Overview
This game uses a somewhat strict OOP structure for high-level stuff - But the actual
game-world behavior utlizes the Concord ECS library.

## General Coding Guidelines
* Class definition directories, files and declarations should be UpperCamelCase.
* Any class instance references should be camelCase.
* Any world emissions or events should use the following format: `prefix_camelCase`
    * ie, `entity_moveTo(e,x,y)`, `physics_applyForce(e,x,y)`


## Callgage's Coding Commandments (for this project):
* 4 space tabs.
* Use `_` to indiciate that a function is private.
* Less abstraction = better.
* ALL_CAPS_PRIVATE_CONSTS
* Create "types" for large clusters of data that get sent around the codebase.
* Logic that mutates a lot of data should be condensed to as little area as possible (preferably one file / system / class).
* Consider where you might intuitively look for logic when debugging in order to determine the best place for it.

## Notes on GUI stuff:
Not using any GUI libraries or anything for this project. Everything will just
pretty much be hardcoded bespoke to each menu (save for some simple abstractions.) Not a great solution, but, for me it's the most straightforward and fastest
short-term.

## Credits:
#### Gage Henderson - [Twitter](https://twitter.com/gage_69_420)
- Programming
- Music
- Sound Effects
- Design

#### Keaton - [Twitter](https://twitter.com/keatonf)
- Artwork
- Design

#### Derek Riggs
- Design
- Writing
- Testing
- Knob Tweaking
like a button class, dropdown, etc).


