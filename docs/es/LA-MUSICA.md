# La música

Cinco músicas, a tres voces. No son grabaciones hechas a mano: `tools/musica.py` **ejecuta el propio motor de sonido
de la ROM** con `tools/z80run.py` -la rutina del sonido (`sonido`, 0xB078), cuadro a cuadro, con el número que escribe
el juego- y apunta lo que escribe en el PSG por la BIOS (WRTPSG).

**Cotejadas con openMSX**: los registros de tono y volumen de los tres canales casan con los grabados, **0 distintos**
en todos los cuadros mirados, en las cinco. Se cotejan cinco grabaciones (`tools/guiones/`): el título con la
demostración, una partida hasta GAME OVER, una con BS, el recorrido forzado por las fases y el final. Cada cuadro
grabado se empareja con el cuadro del motor que tiene la misma RAM en los tres canales; mientras suena un efecto en
un canal, ese canal no se mira. La del jefe, en el recorrido forzado, no se empareja (el jefe la vuelve a pedir cada
5 cuadros mientras sale); en la grabación del final, sí.

## El motor

Es el mismo motor que otros cartuchos de Casio de esos años, en otro sitio de la ROM. Va una vez por cuadro desde la
interrupción. Recibe tres **pedidos**: una música para los tres canales (0xE2BE), un efecto para el canal A (0xE2C0) y
otro para los canales B y C (0xE2C2); un pedido gana a lo que suena si su número es menor (`musica_pide`, 0xB073).
Cada canal tiene un bloque de 18 bytes que se copia a uno de trabajo, da un paso y vuelve. Una pieza es una lista de
notas y órdenes: 0xF0 una nota de ruido, 0xFF el final, 0xF7 callar, 0xFE volver a empezar, y tres bucles. Las tablas:
seis músicas en 0xB000 (la 0 es el silencio), ocho efectos del canal A en 0xB024, ocho de B y C en 0xB034 y catorce
duraciones en 0xB329. El título no tiene música.

| | Quién la pide | Dura |
|---|---|---:|
| la presentación de CASIO | los CASIO se juntan (0x8E67) | 1,1 s |
| la fase | al empezar la fase (0x82B6) | 5,3 s |
| la fase acabada | la puerta o la salida (0xA809, 0xA8D3) | 8,0 s |
| el jefe | el jefe vencido y el final (0xAAF8, 0x870A) | 6,7 s |
| GAME OVER | sin vidas (0x8619) | 8,8 s |

Ninguna vuelve a empezar: todas acaban.

## La presentación de CASIO

<audio controls src="../audio/musica_casio.mp3"></audio>

## La fase

<audio controls src="../audio/musica_fase.mp3"></audio>

## La fase acabada

<audio controls src="../audio/musica_fase_acabada.mp3"></audio>

## El jefe

<audio controls src="../audio/musica_jefe.mp3"></audio>

## GAME OVER

<audio controls src="../audio/musica_game_over.mp3"></audio>
