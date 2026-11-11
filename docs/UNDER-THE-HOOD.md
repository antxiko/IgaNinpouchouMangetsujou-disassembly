# Under the hood

## Rebuilding the ROM

`make verify` assembles `src/igamangetsu.asm` with pasmo and out comes the 32 KB ROM **byte for byte**. `make sanity`
checks what reassembly does not cover: that no byte declared as data is read as code, that no entry point falls in data
and that all 32,768 bytes are explained. `make test` runs the tests. The ROM is not in the repository: put it in the
root as `igamangetsu.rom` (the GoodMSX dump, `[!]`, sha1 `f52113b4...`).

| | bytes |
|---|---|
| traced code | 10,863 |
| named data | 21,905 |
| unexplained | 0 |

The listing has 2,246 comments in 4,862 instructions (46.2%), 631 routines and labels, none under 10% commented, and no
called routine without a name.

## The cartridge

32 KB at 0x4000-0xBFFF, with the header at 0x4000. INIT (0x4010) looks for the first Iga Ninpouchou in the slots, also
puts the cartridge in page 2 and jumps to 0x8000. The data comes before the code: the maps of the seven stages
(0x406B-0x4FFF), the letters (0x5000), the sprite drawings (0x5400, 0x5800), the tiles of the title and the stages with
their colours (0x6000-0x7EFF) and the demo's list of controls (0x7F00). The code goes from 0x8000 to 0xAD16, with data
inside (the texts at 0x8F56, the chest drawings at 0x982D, the gate at 0xA945). At the end, the sound
(0xB000-0xBFFF): its tables, its code and its pieces.

## The BIOS it uses

RDSLT, RSLREG and ENASLT for the slots; SETGRP for SCREEN 2, CHGCLR, WRTVDP, DISSCR and ENASCR; FILVRM, LDIRVM and
WRTVRM for the VRAM; GTSTCK and GTTRIG for the controls and SNSMAT for the space bar, GRAPH, STOP, F1 and the title
keys; WRTPSG for the sound. The letters are not the BIOS ones: they are in the cartridge.

## The interrupt and the loop

INIT puts a jump to 0x8CD2 in the H.TIMI hook. The interrupt runs the sound, counts frames (sixteen counters,
0xE010-0xE01F), reads the buttons, the stick, STOP and F1; in the demo, it is the one that presses the buttons. The
game runs in the **stage loop** (`fase_bucle`, 0x8368): once per frame, what was taken, the ninja, the jump, his
drawing, the shuriken, the points, the enemies, the moon, the ones that come out and the end of the stage; with the
ninja hit, the stage over, F1 or STOP, it leaves the loop.

**The map in RAM.** The stage map lives at 0xEA00 with three 32-column screens side by side (rows of 0x60): the
previous one, the current one and the next one (`mapa_monta`, 0x9B8E). When the ninja goes past the middle, the left
column (0xE190) moves on and 22 rows are copied to the VRAM; every 32 columns, the screens shift by one and the next
one is built (`mapa_avanza`, 0x9BC5). Each screen is described by four lists: rectangles of two alternating tiles,
rectangles of one tile, stairs and drawings (`trozo_pon`, 0x9C6B).

**The sprites flicker instead of vanishing.** Every frame it copies the sprites to the table starting from a different
one (`sprites_rota`, 0x8B3E): with more than four on a line, the one that is not seen changes.

## How it was done

The trace follows the code from INIT, the interrupt and two jump tables (the objects at 0xE400 and the enemies),
declared in `src/igamangetsu.entries`. The rest was **measured in openMSX** (`tools/omsx_cobertura.tcl`) on a Philips
VG 8020, waiting for the demo and playing: nothing that ran was left out of the trace.

The recordings for the site (`tools/guiones/*.tcl`, recorded with `tools/lanza_graba.ps1` on C-BIOS; with `-rom2`, a
second cartridge) log, on every frame, the VDP registers, the RAM from 0xE000, the PSG and the VRAM that changed.
`tools/pantallas.py` runs the title with `tools/bios.py` and checks it against the recording (**0 different points**),
`tools/gifs.py` makes the GIFs and `tools/musica.py` runs the sound engine.

## The RAM

| | |
|---|---|
| 0xE000 | playing (at start-up, the first Iga found) |
| 0xE001-0xE006 | the points, one digit per byte |
| 0xE009 / 0xE00A / 0xE00B | the round / the stage / the lives (BCD) |
| 0xE00C-0xE00E | the points, in BCD |
| 0xE010-0xE01F | the frame counters |
| 0xE020 / 0xE022 | the jump / the shuriken, just pressed |
| 0xE023 / 0xE039 | BS / 2, A, I and G on the title |
| 0xE027 / 0xE037 | the demo / its list of controls |
| 0xE02E / 0xE034 | the high score: digits / BCD |
| 0xE03A | the 10,000 life, already given |
| 0xE051 / 0xE195 | the map screen / the column |
| 0xE053 | the scoreboard marks |
| 0xE060 | the first Iga in another slot |
| 0xE100 | the sprite attributes |
| 0xE183 / 0xE186 | the ninja hit (2: even with BS) / the stage over |
| 0xE190 | the left column in the RAM map |
| 0xE1B3 / 0xE1B7 | F1 / STOP |
| 0xE1B8 | the defeated count (BCD) |
| 0xE1B9-0xE1BB | the moon: its count, its drawing, waning |
| 0xE1C5-0xE1C7 | the chest: its step, how many, the key count |
| 0xE1C9 | 0x6E taken: the exit |
| 0xE280-0xE2D5 | the sound: the three channels and the requests |
| 0xE300 | the ninja (two sprites; +0x20 the shuriken) |
| 0xE360 | the 10 enemies (16 bytes each) |
| 0xE740 | one screen in RAM |
| 0xEA00 | the map: three screens |
