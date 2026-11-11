# Los textos

El juego escribe con **letras propias**: al encender copia 0x180 bytes (0x5000) a las casillas 0x00-0x2F de los tres
tercios de la pantalla (`letras_pon`, 0x8A95). Una letra es su código - 0x30, y la casilla 0x10 es el espacio; la que
haría de ";" se dibuja como un punto. El nombre del juego, CASIO y SOFTWARE son casillas dibujadas.

| dirección | original | traducción | dónde sale |
|---|---|---|---|
| 0x8F57 | CASIO | Casio | la presentación, en casillas dibujadas |
| 0x8F72 | SOFTWARE | Software | la presentación, debajo |
| 0x9030 | CASIO | Casio | el título, en casillas dibujadas |
| 0x8F79 | 伊賀忍法帖 満月城の戦い | Las artes ninja de Iga: la batalla del castillo de la luna llena | el título, en casillas dibujadas |
| 0x905D | COPYRIGHT 1986 © CASIO | Copyright 1986 Casio | el título |
| 0x9026 | GAME START | Empieza la partida | el título |
| 0x9049 | PUSH TRIG:1 OR SPACE | Pulsa el botón 1 o la barra | el título |
| 0x9073 | HISCORE: | Récord: | el marcador |
| 0x9075 | SCORE: | Puntos: | el marcador: las seis últimas letras de HISCORE: |
| 0x907B | GAME OVER | Fin de la partida | sin vidas |
| 0x862E | CONTINUE PUSH TRIG1 | Continuar: pulsa el botón 1 | sin vidas, con 2, A, I y G en el título |
| 0x8641 | END      PUSH TRIG2 | Acabar: pulsa el botón 2 | debajo |
| 0xAC4D | IGA2 | Iga 2 | el jefe vencido, en la ventana de la torre |
| 0x9084 | STAFF | Equipo | el final |
| 0x9089 | K.ARISAWA, K.ASAHINA, T.SATHO, T.TSUJITANI, K.OHSAWA, A.HASEGAWA, M.K | (nombres) | el final, uno por fila |
| 0x90C2 | PRODUCER T.MORIYAMA | Productor: T. Moriyama | el final |

El marcador tiene, además, las marcas de la fase, la luna, el ninja y el enemigo con "=" y sus cifras
(`marcador_pon`, 0x87A5).
