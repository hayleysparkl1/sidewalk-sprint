# Sidewalk Sprint

A compact endless-runner prototype built with Processing (Java mode). Guide a cyclist along a scrolling path, avoid incoming pedestrians, and collect zero-sugar drinks.

## Controls

| **Key** | **Action** |
| --- | --- |
| A | Move left |
| D | Move right |

## Features

- Scrolling tiled path drawn with nested loops
- Up to six pedestrians with individual speeds and randomised respawns
- Up to three drink pickups that move with the path
- Six roadside trees with randomised size and details
- Collision detection and a frozen game-over state

## Run locally

1. Install Processing and use Java mode.
2. Download or clone this repository.
3. Open the `SidewalkSprint` sketch folder in Processing.
4. Click **Run**. After a game over, run the sketch again to restart.

## Implementation highlights

- Parallel arrays store each pedestrian's position and speed, each pickup's position, and each tree's randomised properties.
- Nested loops draw the paving grid and place the roadside trees.
- The cyclist and scenery are drawn with Processing shapes.

## Status

Playable prototype. Possible next improvements include a score display, a keyboard restart, and sound.