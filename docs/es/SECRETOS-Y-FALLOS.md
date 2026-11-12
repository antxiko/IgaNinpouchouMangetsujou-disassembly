# Secretos y fallos

Lo que se ha buscado en el código y lo que se ha encontrado. Un fallo solo entra aquí si está comprobado:
ejecutando la propia rutina del juego (`tools/bios.py`) o contra las grabaciones de openMSX.

## Secretos

Este es el Casio con más cosas escondidas. Todas están contadas, con su GIF, en [Curiosidades](CURIOSIDADES.html):

| qué | cuándo | lo que hace | comprobado |
|---|---|---|---|
| el primer Iga Ninpouchou en otro slot | al encender (0x4010) | la luna fija y otra salida en la fase 0 | en openMSX |
| BS | en el título (0x809C) | los enemigos no matan al ninja | en openMSX |
| 2, A, I y G a la vez | en el título | CONTINUE: dos vidas más, las veces que se quiera | en openMSX |
| STOP | jugando (0x8D0B) | pausa, con el ninja en otros sprites | en openMSX |
| C y W con STOP | en la pausa (0x83C2) | otros dibujos del ninja | en openMSX |
| F1 | jugando | el ninja cae: una vida menos | en openMSX |

Y **IGA2**, las cuatro teclas del truco, escrito en la torre al vencer al jefe de la fase 6 (0xAC4D). Fuera de eso,
los mandos se leen en la interrupción: la palanca de los cursores y del mando 1, los dos botones del mando 1, la barra
y GRAPH.

## Fallo: pasados los 9.999.990 puntos, el récord a cero

Cuando los puntos pasan de 999.999 por dentro
(9.999.990 en pantalla, con el 0 fijo), `puntos_suma` (0x8BF3) copia al récord los puntos **después de dar la vuelta**
(0x8C1D-0x8C2C). Ejecutando aquí la suma del juego:

| puntos (en pantalla) | récord | + | después: puntos | récord |
|---|---|---|---|---|
| 123.450 | 100.000 | 100 | 123.550 | 123.550 |
| 9.999.900 | 9.999.900 | 100 | **0** | **0** |
| 9.999.500 | 9.999.500 | 900 | **400** | **400** |

## Fallo: los cursores y el mando a la vez

`palanca` (0x8D6A) junta los cursores y el mando 1 con un `or` (0x8D7A) de sus números de dirección. Con los dos a la
vez, ejecutándolo aquí, derecha y abajo dan **izquierda** (7), y arriba-derecha y abajo-derecha, **abajo-izquierda**
(6).

## Restos, contados en [Curiosidades](CURIOSIDADES.html)

- Trozos de rutinas **del primer Iga** (0x9FD5, 0xBFBB) y de otra rutina de puntos con tope (0x90D4).
- Un desplazamiento vertical de la pantalla que el juego no usa (0x9A66, 0x9B02).
