# The music

Five tunes, in three voices. They are not recordings made by hand: `tools/musica.py` **runs the ROM's own sound
engine** with `tools/z80run.py` -the sound routine (`sonido`, 0xB078), frame by frame, with the number the game writes-
and logs what it writes to the PSG through the BIOS (WRTPSG).

**Checked against openMSX**: the tone and volume registers of the three channels match the recorded ones, **0
different** on every frame looked at, in all five. Five recordings are checked (`tools/guiones/`): the title with the
demo, a game up to GAME OVER, one with BS, the forced run through the stages and the ending. Each recorded frame is
paired with the engine frame that has the same RAM in the three channels; while an effect plays on a channel, that
channel is not looked at. The boss tune, in the forced run, does not pair (the boss asks for it again every 5 frames
while walking out); in the ending recording, it does.

## The engine

It is the same engine as other Casio cartridges of those years, somewhere else in the ROM. It runs once per frame from
the interrupt. It takes three **requests**: a tune for the three channels (0xE2BE), an effect for channel A (0xE2C0)
and another for channels B and C (0xE2C2); a request beats what is playing if its number is lower (`musica_pide`,
0xB073). Each channel has an 18-byte block that is copied to a working one, takes a step and goes back. A piece is a
list of notes and commands: 0xF0 a noise note, 0xFF the end, 0xF7 silence, 0xFE start again, and three loops. The
tables: six tunes at 0xB000 (0 is silence), eight channel A effects at 0xB024, eight B and C ones at 0xB034 and
fourteen note lengths at 0xB329. The title has no music.

| | Who asks for it | Length |
|---|---|---:|
| the CASIO intro | the CASIO logos meet (0x8E67) | 1.1 s |
| the stage | the stage starts (0x82B6) | 5.3 s |
| the stage over | the gate or the exit (0xA809, 0xA8D3) | 8.0 s |
| the boss | the boss beaten and the ending (0xAAF8, 0x870A) | 6.7 s |
| GAME OVER | no lives left (0x8619) | 8.8 s |

None starts again: they all end.

## The CASIO intro

<audio controls src="audio/musica_casio.mp3"></audio>

## The stage

<audio controls src="audio/musica_fase.mp3"></audio>

## The stage over

<audio controls src="audio/musica_fase_acabada.mp3"></audio>

## The boss

<audio controls src="audio/musica_jefe.mp3"></audio>

## GAME OVER

<audio controls src="audio/musica_game_over.mp3"></audio>
