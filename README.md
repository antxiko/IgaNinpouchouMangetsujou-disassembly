# Iga Ninpouchou Mangetsu-jou no Tatakai - commented disassembly

*(También [en castellano](README.es.md).)*

The commented disassembly of **Iga Ninpouchou Mangetsu-jou no Tatakai** (Casio, 1986) for the MSX: a 32 KB cartridge with its header at 0x4000.

- **100%** of the binary explained: 10,863 bytes of code and 21,905 of named data, not one byte unassigned.
- **46.2%** of the listing commented, 631 routines and labels, none below 10% of comments.
- The listing reassembles into the original ROM **byte for byte**.
- The title comes from running the ROM, checked against openMSX point by point; the CASIO intro, the demo, the seven stages, a chest, the boss and IGA2, the ending, the two cartridges, STOP, F1 and the continue trick, played in GIF in openMSX; the five tunes, from its own sound engine, identical to openMSX frame by frame.

The site: <https://antxiko.github.io/IgaNinpouchouMangetsujou-disassembly/>
(in Spanish: <https://antxiko.github.io/IgaNinpouchouMangetsujou-disassembly/es/>).

## Reproducing it

The ROM image is not distributed. Put yours in the root as `igamangetsu.rom` (sha256 `7040f9b9...`) and run `make`. The details, in [UNDER THE HOOD](docs/UNDER-THE-HOOD.md).

## Legal

The game belongs to Casio and its rights holders. The licence in `LICENSE` covers only the tools, the comments, the analysis and the documentation here. See [LEGAL-NOTICE.md](LEGAL-NOTICE.md).
