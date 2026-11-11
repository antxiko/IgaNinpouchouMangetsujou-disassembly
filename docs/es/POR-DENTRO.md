# Por dentro

## Rehacer la ROM

`make verify` ensambla `src/igamangetsu.asm` con pasmo y sale la ROM de 32 KB **byte a byte**. `make sanity` comprueba
lo que el reensamblado no cubre: que ningún byte declarado como datos se lea como código, que ningún punto de entrada
caiga en datos y que estén explicados los 32.768 bytes. `make test` pasa los tests. La ROM no está en el repositorio:
hay que ponerla en la raíz como `igamangetsu.rom` (el volcado de GoodMSX, `[!]`, sha1 `f52113b4...`).

| | bytes |
|---|---|
| código trazado | 10.863 |
| datos con nombre | 21.905 |
| sin explicar | 0 |

El listado tiene 2.246 comentarios en 4.862 instrucciones (46,2 %), 631 rutinas y etiquetas, ninguna por debajo del
10 % comentada, y ninguna rutina llamada sin nombre.

## El cartucho

32 KB en 0x4000-0xBFFF, con la cabecera en 0x4000. INIT (0x4010) busca el primer Iga Ninpouchou en los slots, pone
el cartucho también en la página 2 y salta a 0x8000. Antes del código van los datos: los mapas de las siete fases
(0x406B-0x4FFF), las letras (0x5000), los dibujos de los sprites (0x5400, 0x5800), las casillas del título y de las
fases con sus colores (0x6000-0x7EFF) y la lista de mandos de la demostración (0x7F00). El código va de 0x8000 a
0xAD16, con datos dentro (los textos en 0x8F56, los dibujos de los cofres en 0x982D, la puerta en 0xA945). Al final,
el sonido (0xB000-0xBFFF): sus tablas, su código y sus piezas.

## La BIOS que usa

RDSLT, RSLREG y ENASLT para los slots; SETGRP para SCREEN 2, CHGCLR, WRTVDP, DISSCR y ENASCR; FILVRM, LDIRVM y WRTVRM
para la VRAM; GTSTCK y GTTRIG para los mandos y SNSMAT para la barra, GRAPH, STOP, F1 y las teclas del título; WRTPSG
para el sonido. Las letras no son las de la BIOS: van en el cartucho.

## La interrupción y el bucle

INIT pone un salto a 0x8CD2 en el gancho H.TIMI. La interrupción hace el sonido, cuenta cuadros (dieciséis cuentas,
0xE010-0xE01F), lee los botones, la palanca, STOP y F1; en la demostración mueve ella los botones. El juego va en el
**bucle de la fase** (`fase_bucle`, 0x8368): una vez por cuadro, lo cogido, el ninja, el salto, su dibujo, el
shuriken, los puntos, los enemigos, la luna, los que salen y el final de la fase; con el ninja tocado, la fase acabada,
F1 o STOP, sale del bucle.

**El mapa en la RAM.** El mapa de la fase vive en 0xEA00 con tres pantallas de 32 columnas una al lado de otra (filas
de 0x60): la de antes, la de ahora y la siguiente (`mapa_monta`, 0x9B8E). Cuando el ninja pasa de la mitad, la columna
de la izquierda (0xE190) avanza y se copian 22 filas a la VRAM; cada 32 columnas, las pantallas se corren una y se
monta la siguiente (`mapa_avanza`, 0x9BC5). Cada pantalla se describe con cuatro listas: rectángulos de dos casillas
alternas, rectángulos de una casilla, escaleras y dibujos (`trozo_pon`, 0x9C6B).

**Los sprites parpadean en vez de desaparecer.** Cada cuadro copia los sprites a la tabla empezando por uno distinto
(`sprites_rota`, 0x8B3E): con más de cuatro en una línea, el que no se ve cambia.

## Cómo se ha hecho

El trazado sigue el código desde INIT, la interrupción y dos tablas de saltos (los objetos de 0xE400 y los enemigos),
declaradas en `src/igamangetsu.entries`. Lo demás se **midió en openMSX** (`tools/omsx_cobertura.tcl`) en un Philips
VG 8020, esperando a la demostración y jugando: nada de lo que se ejecutó quedó fuera del trazado.

Las grabaciones de la web (`tools/guiones/*.tcl`, grabadas con `tools/lanza_graba.ps1` en C-BIOS; con `-rom2`, un
segundo cartucho) apuntan, en cada cuadro, los registros del VDP, la RAM desde 0xE000, el PSG y la VRAM que ha
cambiado. `tools/pantallas.py` ejecuta el título con `tools/bios.py` y lo coteja con la grabación (**0 puntos
distintos**), `tools/gifs.py` hace los GIF y `tools/musica.py` ejecuta el motor de sonido.

## La RAM

| | |
|---|---|
| 0xE000 | jugando (en el arranque, el primer Iga encontrado) |
| 0xE001-0xE006 | los puntos, una cifra por byte |
| 0xE009 / 0xE00A / 0xE00B | la vuelta / la fase / las vidas (BCD) |
| 0xE00C-0xE00E | los puntos, en BCD |
| 0xE010-0xE01F | las cuentas de cuadros |
| 0xE020 / 0xE022 | el salto / el shuriken, recién pulsados |
| 0xE023 / 0xE039 | BS / 2, A, I y G en el título |
| 0xE027 / 0xE037 | la demostración / su lista de mandos |
| 0xE02E / 0xE034 | el récord: cifras / BCD |
| 0xE03A | la vida de los 10.000, ya dada |
| 0xE051 / 0xE195 | la pantalla del mapa / la columna |
| 0xE053 | las marcas del marcador |
| 0xE060 | el primer Iga en otro slot |
| 0xE100 | los atributos de los sprites |
| 0xE183 / 0xE186 | el ninja tocado (2: aunque haya BS) / la fase acabada |
| 0xE190 | la columna de la izquierda en el mapa de la RAM |
| 0xE1B3 / 0xE1B7 | F1 / STOP |
| 0xE1B8 | los derrotados (BCD) |
| 0xE1B9-0xE1BB | la luna: su cuenta, su dibujo, menguando |
| 0xE1C5-0xE1C7 | el cofre: su paso, cuántos, la cuenta de la llave |
| 0xE1C9 | el 0x6E cogido: la salida |
| 0xE280-0xE2D5 | el sonido: los tres canales y los pedidos |
| 0xE300 | el ninja (dos sprites; +0x20 el shuriken) |
| 0xE360 | los 10 enemigos (16 bytes cada uno) |
| 0xE740 | una pantalla en la RAM |
| 0xEA00 | el mapa: tres pantallas |
