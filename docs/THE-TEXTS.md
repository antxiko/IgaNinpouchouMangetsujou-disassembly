# The texts

The game writes with **its own letters**: at power-on it copies 0x180 bytes (0x5000) to tiles 0x00-0x2F of the three
thirds of the screen (`letras_pon`, 0x8A95). A letter is its code - 0x30, and tile 0x10 is the space; the one that
would be ";" is drawn as a full stop. The game's name, CASIO and SOFTWARE are drawn tiles.

| address | original | translation | where it appears |
|---|---|---|---|
| 0x8F57 | CASIO | Casio | the intro, in drawn tiles |
| 0x8F72 | SOFTWARE | Software | the intro, below |
| 0x9030 | CASIO | Casio | the title, in drawn tiles |
| 0x8F79 | 伊賀忍法帖 満月城の戦い | The ninja arts of Iga: the battle of the full moon castle | the title, in drawn tiles |
| 0x905D | COPYRIGHT 1986 © CASIO | Copyright 1986 Casio | the title |
| 0x9026 | GAME START | The game starts | the title |
| 0x9049 | PUSH TRIG:1 OR SPACE | Press button 1 or the space bar | the title |
| 0x9073 | HISCORE: | High score: | the scoreboard |
| 0x9075 | SCORE: | Score: | the scoreboard: the last six letters of HISCORE: |
| 0x907B | GAME OVER | Game over | no lives left |
| 0x862E | CONTINUE PUSH TRIG1 | Continue: press button 1 | no lives left, with 2, A, I and G on the title |
| 0x8641 | END      PUSH TRIG2 | End: press button 2 | below |
| 0xAC4D | IGA2 | Iga 2 | the boss beaten, in the tower window |
| 0x9084 | STAFF | Staff | the ending |
| 0x9089 | K.ARISAWA, K.ASAHINA, T.SATHO, T.TSUJITANI, K.OHSAWA, A.HASEGAWA, M.K | (names) | the ending, one per row |
| 0x90C2 | PRODUCER T.MORIYAMA | Producer: T. Moriyama | the ending |

The scoreboard also has the stage marks, the moon, the ninja and the enemy with "=" and their digits (`marcador_pon`,
0x87A5).
