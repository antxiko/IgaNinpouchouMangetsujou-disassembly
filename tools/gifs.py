"""Los GIF de la web: tramos de las grabaciones de openMSX (tools/guiones/*.tcl, grabados con
tools/lanza_graba.ps1 en C-BIOS_MSX1_JP, -bp 0x8CD2 -ram "0xE000 0x1000"), pintados con tools/vdp.py; cada imagen
dura el tiempo emulado que dura en la grabacion.

Los tramos salen de la RAM grabada: 0xE000 jugando, 0xE027 la demostracion, 0xE00A la fase, 0xE009 la vuelta,
0xE00B las vidas, 0xE183 el ninja tocado, 0xE186 la fase acabada, 0xE1C5 el cofre, 0xE1B7 STOP, 0xE1B3 F1,
0xE060 el primer Iga en otro slot, 0xE2BD la musica.

  atraccion   sin tocar nada: la presentacion de CASIO, el titulo y la demostracion
  partida     un piloto sencillo (tools/guiones/partida.tcl): pierde las cinco vidas en la fase 0; GAME OVER
  invencible  otro piloto con BS pulsada en el titulo: la fase 0 entera y el foso de la fase 1
  forzada     el mismo piloto con BS; cada fase se da por acabada con un poke (FORZADA): las siete fases y el jefe
  final       FORZADA: la fase 6 de la tercera vuelta y el final
  dos         con el primer Iga Ninpouchou en el segundo slot
  teclas      STOP, C y W, y F1
  continuar   2, A, I y G pulsadas en el titulo: sin vidas, CONTINUE PUSH TRIG1 y dos vidas mas

Las grabaciones son grandes: cada una se lee UNA vez.

Uso: gifs.py docs/imagenes
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vdp          # noqa: E402

# (fichero, grabacion, desde, hasta, cada)
TRAMOS = [
    ("presentacion.gif", "atraccion", 1, 200, 2),       # la presentacion de CASIO
    ("titulo.gif", "atraccion", 200, 440, 2),           # el titulo: los colores del nombre cambian
    ("demostracion.gif", "atraccion", 440, 1450, 3),    # la demostracion: los dos botones, sin palanca
    ("salida.gif", "partida", 401, 900, 2),             # la fase 0 empieza: el puente
    ("tocada.gif", "partida", 1080, 1330, 2),           # tocado: sube, cae y la fase otra vez
    ("game_over.gif", "partida", 4700, 5186, 3),        # la ultima vida y GAME OVER
    ("puerta.gif", "invencible", 2600, 3140, 3),        # diez derrotados: la puerta del castillo
    ("foso.gif", "invencible", 4650, 4930, 2),          # la fase 1: al foso de pinchos (0x3D)
    ("fase1.gif", "forzada", 2500, 2900, 2),            # la fase 1
    ("fase2.gif", "forzada", 4600, 5000, 2),            # la fase 2: dentro del castillo
    ("fase3.gif", "forzada", 6400, 6800, 2),            # la fase 3
    ("cofre.gif", "forzada", 8530, 8700, 2),            # la fase 4: un cofre se abre
    ("fase5.gif", "forzada", 10000, 10400, 2),          # la fase 5: el tejado
    ("jefe.gif", "forzada", 11900, 12470, 3),           # la fase 6: el jefe
    ("iga2.gif", "forzada", 12480, 13200, 3),           # el jefe vencido: IGA2
    ("final.gif", "final", 9770, 10098, 3),             # el final: los creditos
    ("dos.gif", "dos", 400, 900, 2),                    # con el primer Iga: la luna no cambia
    ("pausa.gif", "teclas", 990, 1650, 3),              # STOP; C y W
    ("f1.gif", "teclas", 2190, 2450, 2),                # F1: una vida menos
    ("continuar.gif", "continuar", 4560, 4900, 2),      # 2, A, I y G en el titulo: CONTINUE PUSH TRIG1
]


def main(salida):
    raiz = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    for grab in dict.fromkeys(t[1] for t in TRAMOS):
        mios = [t for t in TRAMOS if t[1] == grab]
        gifs = {t[0]: vdp.Gif() for t in mios}
        tope = max(t[3] for t in mios) + max(t[4] for t in mios)
        espera = {}                                    # fichero -> (imagen, t) pendiente de su duracion
        for n, c in enumerate(vdp.cuadros(os.path.join(raiz, "work", grab + ".bin"))):
            if n > tope:
                break
            for fichero, _, desde, hasta, cada in mios:
                if desde <= n <= hasta + cada and (n - desde) % cada == 0:
                    if fichero in espera:
                        im, t = espera.pop(fichero)
                        gifs[fichero].pon(im, (c["t"] - t) * 1000.0 / gifs[fichero].ms)
                    if n <= hasta:
                        espera[fichero] = (vdp.imagen(c["vram"], c["regs"], 1), c["t"])
        for fichero, _, desde, hasta, cada in mios:
            if fichero in espera:                       # la grabacion acaba antes: la ultima, un paso
                im, _t = espera.pop(fichero)
                gifs[fichero].pon(im, cada)
            ruta = os.path.join(salida, fichero)
            gifs[fichero].guarda(ruta, 4000)
            print("%-24s %4d imagenes, %8d bytes" % (fichero, len(gifs[fichero]), os.path.getsize(ruta)))


if __name__ == "__main__":
    main(sys.argv[1])
