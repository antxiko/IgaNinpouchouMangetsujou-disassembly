"""Los mapas de las siete fases de Iga Ninpouchou Mangetsu-jou, PINTADOS EJECUTANDO LA ROM: cada pantalla de la
lista de su fase (la tabla de 0x406D) montada por trozo_pon (0x9C6B) en la pantalla de la RAM (0xE740, 22 filas de
32 casillas, antes llena de 0x10 como hace mapa_monta), con la RAM y la VRAM de un cuadro grabado de esa fase
(work/forzada.bin: los dibujos y colores de las casillas de la fase). Una tira por fase, de izquierda a derecha, sin
marcador ni sprites.

Cotejo: en cada cuadro grabado con el mapa alineado (0xE190 = 0x20: la pantalla de la posicion 0xE051 entera en el
centro), las filas 2-23 de la tabla de nombres contra esa pantalla montada.

Uso: mapas.py docs/imagenes
"""
import os
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, AQUI)
import vdp                  # noqa: E402
from bios import Msx        # noqa: E402
from PIL import Image       # noqa: E402

RAIZ = os.path.dirname(AQUI)
ROM = open(os.path.join(RAIZ, "igamangetsu.rom"), "rb").read()


def w(a):
    return ROM[a - 0x4000] | ROM[a - 0x3FFF] << 8


def cuantas(fase):
    """Las listas van seguidas, de la fase 6 (0x407B) a la 0 (0x40AB); la de la 0 acaba donde empiezan las pantallas."""
    p = w(0x406D + 2 * fase)
    fin = w(0x406D + 2 * (fase - 1)) if fase else w(p)
    return (fin - p) // 2


def monta(ram, fase, pantalla):
    m = Msx(ROM, 0x4000)
    m.mem[0xE000:0xF000] = ram
    m.mem[0xE740:0xE740 + 22 * 32] = bytes([0x10] * (22 * 32))
    m.mem[0xE050] = fase
    m.a = pantalla
    m.llama(0x9C6B)
    return bytes(m.mem[0xE740:0xE740 + 22 * 32])


def main(salida):
    cuadro = {}
    cotejos = {}
    for c in vdp.cuadros(os.path.join(RAIZ, "work", "forzada.bin")):
        r = c["ram"]
        if not (r[0x000] and c["regs"][1] & 0x40) or r[0x00A] > 6 or r[0x050] != r[0x00A]:
            continue
        f = r[0x00A]
        cuadro.setdefault(f, c)
        if r[0x190] == 0x20:
            esperado = monta(r, f, r[0x051])
            d = sum(1 for a, b in zip(esperado, c["vram"][0x1840:0x1840 + 22 * 32]) if a != b)
            cotejos.setdefault(f, []).append(d)
    tiras = []
    for f in range(7):
        c = cuadro[f]
        n = cuantas(f)
        tira = Image.new("RGB", (256 * n, 176))
        for k in range(n):
            v = bytearray(c["vram"])
            v[0x1840:0x1840 + 22 * 32] = monta(c["ram"], f, k)
            tira.paste(vdp.imagen(bytes(v), c["regs"], 1, con_sprites=False).crop((0, 16, 256, 192)), (256 * k, 0))
        tiras.append(tira)
        ds = sorted(cotejos.get(f, []))
        print("fase %d: %d pantallas; cotejo: %d cuadros, %d iguales, mediana %s" % (
            f, n, len(ds), ds.count(0), ds[len(ds) // 2] if ds else "-"))
    ancho = max(t.size[0] for t in tiras)
    hoja = Image.new("RGB", (ancho, 7 * 176 + 6 * 8), (0, 0, 0))
    for i, t in enumerate(tiras):
        hoja.paste(t, (0, i * 184))
    hoja = hoja.resize((hoja.size[0] // 2, hoja.size[1] // 2), Image.NEAREST)
    ruta = os.path.join(salida, "mapas.png")
    hoja.save(ruta, optimize=True)
    print(ruta, hoja.size)


if __name__ == "__main__":
    main(sys.argv[1])
