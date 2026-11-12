# Secrets and bugs

What was searched for in the code and what was found. A bug only goes here if it has been checked: by running the
game's own routine (`tools/bios.py`) or against the openMSX recordings.

## Secrets

This is the Casio with the most hidden things. All of them are told, with their GIF, in [Curiosities](CURIOSITIES.html):

| what | when | what it does | checked |
|---|---|---|---|
| the first Iga Ninpouchou in another slot | at power-on (0x4010) | the moon stays still and stage 0 starts elsewhere | in openMSX |
| BS | on the title (0x809C) | enemies do not kill the ninja | in openMSX |
| 2, A, I and G together | on the title | CONTINUE: two more lives, as many times as wanted | in openMSX |
| STOP | while playing (0x8D0B) | pause, with the ninja in other sprites | in openMSX |
| C and W with STOP | in the pause (0x83C2) | other drawings for the ninja | in openMSX |
| F1 | while playing | the ninja falls: one life less | in openMSX |

And **IGA2**, the four keys of the trick, written on the tower when the stage 6 boss is beaten (0xAC4D). Apart from
that, the controls are read in the interrupt: the stick from the cursor keys and joystick 1, the two buttons of
joystick 1, the space bar and GRAPH.

## Bug: past 9,999,990 points, the high score to zero

When the score goes past 999,999
inside (9,999,990 on screen, with the fixed 0), `puntos_suma` (0x8BF3) copies into the high score the score **after it
has wrapped** (0x8C1D-0x8C2C). Running the game's addition here:

| score (on screen) | high score | + | after: score | high score |
|---|---|---|---|---|
| 123,450 | 100,000 | 100 | 123,550 | 123,550 |
| 9,999,900 | 9,999,900 | 100 | **0** | **0** |
| 9,999,500 | 9,999,500 | 900 | **400** | **400** |

## Bug: the cursor keys and the joystick at once

`palanca` (0x8D6A) joins the cursor keys and joystick 1 with an `or` (0x8D7A) of their direction numbers. With both at
once, running it here, right and down give **left** (7), and up-right and down-right give **down-left** (6).

## Leftovers, told in [Curiosities](CURIOSITIES.html)

- Pieces of routines **from the first Iga** (0x9FD5, 0xBFBB) and from another score routine with a cap (0x90D4).
- A vertical screen scroll the game does not use (0x9A66, 0x9B02).
