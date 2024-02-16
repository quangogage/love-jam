# love-jam
Love2d game jam 2024

## Getting started
Install [love](https://love2d.org/)  
  
`love .`

## General Overview
This game uses a somewhat strict OOP structure for high-level stuff - But the actual
game-world behavior utlizes the Concord ECS library.

## General Coding Guidelines
* Class definition directories, files and declarations should be UpperCamelCase.
* Any class instances should be camelCase.
* Any world emissions or events should use the following format: `prefix_camelCase`
    * ie, `entity_moveTo(x,y)`


## Callgage's Coding Commandments (for this project):
* 4 space tabs.
* Use `_` to indiciate that a function is private.
* Less abstraction = better.
* Create "types" for large clusters of data that get sent around the codebase.
* Logic that mutates a lot of data should be condensed to as little area as possible (preferably one file / system / class).
* Consider where you might intuitively look for logic when debugging in order to determine the best place for it.
