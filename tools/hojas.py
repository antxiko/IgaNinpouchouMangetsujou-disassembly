#!/usr/bin/env python3
"""Los sprites de Iga Ninpouchou: Mangetsu-jou no Tatakai MONTADOS DESDE LA ROM (ninguna imagen es una captura).

Los dibujos son los 0x800 bytes de 0x5800 que `sprites_dibujos` pone tal cual en 0x3800; sprites de 16 x 16. Cada
cosa son sprites de 16 bytes en 0xE300 (los 4 primeros, sus atributos): el ninja en 0xE300 y 0xE310, su shuriken en
0xE320, y los demas desde 0xE330.

  ninja.png          el ninja: dos sprites en el mismo sitio, el dibujo en azul claro (5) y el + 4 en amarillo claro
                     (11) (`fase_empieza`, 0x829E). Mirando a la derecha 0x28 o 0x30 (de pie, segun la columna del
                     mapa; andando, el paso), a la izquierda 0x00 o 0x08 (`ninja_dibujo`, 0x973F); saltando 0x38 y
                     0x10, cayendo 0x40 y 0x18 (0x9701); agachado (0x48 y 0x20) y tocado (0x88 y 0x90, 0x8570); su
                     shuriken (0xA4 y 0xA8, blanco)
  enemigos.png       los ninja enemigos, dos sprites: 0x50 a la izquierda o 0x60 a la derecha (`ninja_enemigo_dibujo`,
                     0xA215; el 6, 0xC0 y 0xD0), + 8 con el paso, en su color, y el + 4 en amarillo claro
                     (`ninja_enemigo_color`, 0xA151: el tipo 1 en 12 en la fase 0 y en 13 despues; los otros, 7 en la
                     fase 1 y 14 despues; el 6, en 9); derribados, 0x88 y 0x90 (blanco y
                     rojo claro); lo que tiran (los tipos 2 y 7: 0xA4 y 0xA8 en cian, 0x78 y 0x7C en blanco,
                     `tiro_enemigo`), el tipo 4 (0x70, magenta), lo que cae (los tipos 5 y 10: 0x9C en cian) y el jefe de
                     la fase 6 (`jefe`, 0xA99D: la cabeza 0xAC, 0xB8 o 0xBC en blanco y el cuerpo, 2 x 2, en el color de
                     la vuelta: 0xF0-0xFC o 0xE0-0xEC cada 8 cuadros, `jefe_dibujo` 0xAC0F)
  andar_cuadros.gif  el ninja andando (el paso cada 8 cuadros) y el jefe moviendose

Uso: hojas.py docs/imagenes | hojas.py cotejo
"""
import os
import sys

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(RAIZ, "tools"))
import vdp          # noqa: E402

ORG = 0x4000
ROM = open(os.path.join(RAIZ, "igamangetsu.rom"), "rb").read()
FONDO = (24, 24, 48)
POSES = [0x28, 0x30, 0x38, 0x40, 0x00, 0x08, 0x10, 0x18, 0x48, 0x20, 0x88, 0x90]
NINJAS = [(1, 12), (1, 13), (3, 7), (3, 14), (6, 9)]


def patrones():
    return ROM[0x5800 - ORG:0x5800 - ORG + 0x800]


def pinta(im, pat, n, x, y, color, escala=1):
    if color & 15 == 0:
        return
    n &= 0xFC
    d = pat[n * 8:n * 8 + 32]
    c = vdp.PALETA[color & 15]
    for fila in range(16):
        for col in range(16):
            if (d[fila + (16 if col >= 8 else 0)] >> (7 - (col & 7))) & 1:
                for ey in range(escala):
                    for ex in range(escala):
                        px, py = (x + col) * escala + ex, (y + fila) * escala + ey
                        if 0 <= px < im.width and 0 <= py < im.height:
                            im.putpixel((px, py), c)


def dos(im, pat, d, c1, c2, x, y, E):
    pinta(im, pat, d + 4, x, y, c2, E)
    pinta(im, pat, d, x, y, c1, E)


def jefe(vuelta, otro):
    """Los cinco sprites del jefe (dy, dx, dibujo, color): la cabeza (+0) 4 a la derecha del cuerpo, y el cuerpo."""
    cabeza, color = ((0xAC, 9), (0xB8, 5), (0xBC, 13))[vuelta]
    b = 0xE0 if otro else 0xF0
    return [(0, 4, cabeza, 15), (0, 0, b, color), (0, 16, b + 4, color), (16, 0, b + 8, color), (16, 16, b + 12, color)]


def grupo(im, pat, sprites, x, y, E):
    for dy, dx, d, c in reversed(sprites):
        pinta(im, pat, d, x + dx, y + dy, c, E)


def hoja(Image):
    pat, E = patrones(), 4
    im = Image.new("RGB", (8 * 20 * E, 3 * 20 * E), FONDO)
    for k, d in enumerate(POSES):
        dos(im, pat, d, 5, 11, 2 + 20 * (k % 8), 2 + 20 * (k // 8), E)
    for k, d in enumerate((0xA4, 0xA8)):
        pinta(im, pat, d, 2 + 20 * (4 + k), 22, 15, E)
    return im


def hoja_enemigos(Image):
    pat, E = patrones(), 3
    im = Image.new("RGB", (10 * 20 * E, 6 * 20 * E + 40 * E), FONDO)
    for fila, (tipo, c) in enumerate(NINJAS):
        base = 0xC0 if tipo == 6 else 0x50       # ninja_enemigo_dibujo (0xA215): + 0x10 a la derecha, + 8 el paso
        for k in range(4):
            dos(im, pat, base + 8 * k, c, 11, 2 + 20 * k, 2 + 20 * fila, E)
    for k, (d, c) in enumerate(((0x88, 15), (0x90, 9))):
        pinta(im, pat, d, 2 + 20 * (5 + k), 2, c, E)
    for k, (d, c) in enumerate(((0xA4, 7), (0xA8, 7), (0x78, 15), (0x7C, 15), (0x70, 13), (0x9C, 7))):
        pinta(im, pat, d, 2 + 20 * k, 2 + 20 * 5, c, E)
    for v in range(3):
        grupo(im, pat, jefe(v, 0), 2 + 40 * v, 2 + 20 * 6, E)
    return im


def anima(Image):
    pat, E, cuadros = patrones(), 4, []
    for n in range(64):
        im = Image.new("RGB", (3 * 20 * E + 20 * E, 36 * E), FONDO)
        dos(im, pat, 0x28 + (n & 8), 5, 11, 2, 10, E)
        grupo(im, pat, jefe(0, n & 8), 30, 2, E)
        cuadros.append(im)
    return cuadros


def guarda_gif(cuadros, ruta, ms=1000 / 60):
    imgs, durs = [], []
    for im in cuadros:
        if imgs and list(im.getdata()) == list(imgs[-1].getdata()):
            durs[-1] += ms
        else:
            imgs.append(im)
            durs.append(ms)
    imgs[0].save(ruta, save_all=True, append_images=imgs[1:], duration=[max(20, int(round(d))) for d in durs],
                 loop=0, disposal=1)


def cotejo():
    """Contra las grabaciones de openMSX (work/*.bin, la RAM 0xE000-0xEFFF):
    1) la tabla de dibujos de los sprites (VRAM 0x3800-0x3FFF) contra los 0x800 bytes de 0x5800 (aparte, los cuadros
       con los otros dibujos de 0x5400, el modo de 0xE1B7);
    2) el ninja (0xE300 y 0xE310): en el mismo sitio, uno de sus dibujos en 5 y el + 4 en 11;
    3) los ninja enemigos (los tipos 1, 3 y 6 en marcha y el hueco siguiente, el tipo 15): en el mismo sitio, 0x50 +
       el paso (o 0xC0 + el paso el 6) en el color de su tipo y su fase, y el + 4 en 11;
    4) el jefe (el tipo 9): la cabeza 4 a la derecha del cuerpo y los cuatro del cuerpo en cuadrado."""
    pat = patrones()
    otros = ROM[0x5400 - ORG:0x5400 - ORG + 0x180]
    tot = dict(patrones=0, otros_dibujos=0, pat_carga=0, pat_mal=0, ninja=0, ninja_sin_poner=0, ninja_mal=0,
               enemigos=0, enemigos_mal=0, jefe=0, jefe_tiembla=0, jefe_mal=0)
    for grab in ("atraccion", "partida", "dos", "final", "continuar", "forzada", "invencible"):
        ruta = os.path.join(RAIZ, "work", grab + ".bin")
        if not os.path.exists(ruta):
            continue
        try:
            cuadros = list(vdp.cuadros(ruta))
        except AssertionError:
            continue
        for c in cuadros:
            v, ram = c["vram"], c["ram"]
            t = v[0x3800:0x4000]
            if any(t):
                n = len(t.rstrip(bytes(1)))
                if t == pat:
                    tot["patrones"] += 1
                elif t[:0x180] == otros and t[0x180:] == pat[0x180:]:
                    tot["otros_dibujos"] += 1
                elif t[:n] == pat[:n]:
                    tot["pat_carga"] += 1
                else:
                    tot["pat_mal"] += 1
            a, b = ram[0x300:0x304], ram[0x310:0x314]
            if a[0] < 0xC0:
                if a == bytes(4):
                    tot["ninja_sin_poner"] += 1
                elif a[:2] == b[:2] and a[2] in POSES and b[2] == a[2] + 4 and (a[3] & 15, b[3] & 15) == (5, 11):
                    tot["ninja"] += 1
                else:
                    tot["ninja_mal"] += 1
            for k in range(13):
                e = ram[0x330 + 16 * k:0x350 + 16 * k]
                if e[0] >= 0xC0 or e[5] != 1:
                    continue
                if e[4] in (1, 3, 6) and e[0x14] == 15:
                    colores = {c for tt, c in NINJAS if tt == e[4]}
                    bases = {0x50 + 8 * j for j in range(4)} | ({0xC0 + 8 * j for j in range(4)} if e[4] == 6 else set())
                    ok = (e[0x10:0x12] == e[0:2] and e[2] in bases and e[3] & 15 in colores and e[0x12] == e[2] + 4
                          and e[0x13] & 15 == 11)
                    tot["enemigos"] += ok
                    tot["enemigos_mal"] += not ok
                elif e[4] == 9:
                    j = ram[0x330 + 16 * k:0x380 + 16 * k]
                    cuerpo = [j[16 * m:16 * m + 4] for m in range(1, 5)]
                    ok = (all(cc[2] in range(0xE0, 0x100) for cc in cuerpo) and cuerpo[1][1] == (cuerpo[0][1] + 16) & 0xFF
                          and cuerpo[2][1] == cuerpo[0][1] and (cuerpo[2][0] - cuerpo[0][0]) & 0xFF == 16
                          and (j[1] - cuerpo[0][1]) & 0xFF == 4)
                    if ok:
                        tot["jefe"] += 1
                    elif all(cc[2] in range(0xE0, 0x100) for cc in cuerpo) or all(cc[2] == 0 for cc in cuerpo):
                        tot["jefe_tiembla"] += 1        # aturdido, tiembla (`jefe_tiembla`), o sale sin dibujo aun
                    else:
                        tot["jefe_mal"] += 1
    return tot


def main(argv):
    if argv and argv[0] == "cotejo":
        print(cotejo())
        return 0
    from PIL import Image
    salida = argv[0]
    os.makedirs(salida, exist_ok=True)
    hoja(Image).save(os.path.join(salida, "ninja.png"))
    hoja_enemigos(Image).save(os.path.join(salida, "enemigos.png"))
    guarda_gif(anima(Image), os.path.join(salida, "andar_cuadros.gif"))
    for f in ("ninja.png", "enemigos.png", "andar_cuadros.gif"):
        print(f, os.path.getsize(os.path.join(salida, f)))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
