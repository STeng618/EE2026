### Character Generation and Drawing 
This folder contains the code for generating the characters and drawing them on the canvas. When the Captcha game starts, characters are randomly generated with specific draw sequences. Each draw stroke is fed into a draw machine which completed the drawing at a specific speed. Once the drawing is completed, the draw machine will then request for the next draw stroke. This process repeats until all draw strokes are completed for one character. The main state machine controls the number of characters to be drawn and provides the draw sequence for each character.

## Main Modules 
- `ANIMATION_FIRST`: Top level module for the animation state machine. It controls the number of characters to be drawn and provides an interface for communication with external modules. 
- `ANIMAZTION_MEMORY_MANAGER`: This module records pixels that have been drawn on the canvas. 
- `ANIMATION_MOVER`: This module moves pixels from one location to another to achieve the animation effect.`
- `CHARACTER_GENERATOR`: This module generates characters and their draw sequences.