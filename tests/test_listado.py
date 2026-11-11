"""Lo que se afirma de la ROM, comprobado contra sus bytes.

Corre con la ROM delante y sin ella: cuando no esta, la imagen se rehace desde
las filas defb/defw del listado, que si viaja con el repositorio. Sin la ROM
solo se comprueba lo que cae en datos.
"""

import os
import re
import subprocess
import sys
import unittest

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(RAIZ, "tools"))

ROM = os.path.join(RAIZ, "igamangetsu.rom")
ASM = os.path.join(RAIZ, "src", "igamangetsu.asm")
NOTAS = os.path.join(RAIZ, "src", "igamangetsu.notes")
ORG = 0x4000
TAM = 32768

FILA = re.compile(r"^\s+def(b|w)\s+([0-9a-fA-F,h ]+)\s*;\s*([0-9a-f]{4})")


def imagen_desde_el_listado():
    img = bytearray(TAM)
    with open(ASM, encoding="utf-8") as f:
        for ln in f:
            m = FILA.match(ln)
            if not m:
                continue
            ancho, cuerpo, dirr = m.group(1), m.group(2), int(m.group(3), 16)
            p = dirr - ORG
            for tok in cuerpo.split(","):
                tok = tok.strip().rstrip("h")
                if not tok:
                    continue
                v = int(tok, 16)
                if ancho == "b":
                    img[p] = v
                    p += 1
                else:
                    img[p] = v & 0xFF
                    img[p + 1] = v >> 8
                    p += 2
    return bytes(img)


def lee():
    if os.path.exists(ROM):
        with open(ROM, "rb") as f:
            return f.read()
    return imagen_desde_el_listado()


def b(a):
    return lee()[a - ORG]


def w(a):
    rom = lee()
    return rom[a - ORG] | (rom[a - ORG + 1] << 8)


def instruccion(dirr):
    """La instruccion del listado en esa direccion (sin el comentario)."""
    with open(ASM, encoding="utf-8") as f:
        for ln in f:
            m = re.match(r"^	(\S.*?)\s*;([0-9a-f]{4})", ln)
            if m and int(m.group(2), 16) == dirr:
                return m.group(1).replace("	", " ").strip()


class Cabecera(unittest.TestCase):
    def test_ab_e_init_en_0x4010(self):
        rom = lee()
        self.assertEqual(rom[:2], b"AB")
        self.assertEqual(w(0x4002), 0x4010)

    def test_init_busca_el_primer_iga_en_0x81b9(self):
        self.assertEqual([instruccion(a) for a in (0x4014, 0x401C, 0x401F, 0x403C, 0x403E)],
                         ["ld hl,081b9h", "call 0000ch", "cp 021h", "ld a,001h", "ld (0e000h),a"])

    def test_init_pone_la_pagina_2_y_salta(self):
        self.assertEqual([instruccion(a) for a in (0x4063, 0x4065, 0x4068)],
                         ["ld h,080h", "call 00024h", "jp arranque"])

    def test_son_32_kb(self):
        self.assertEqual(len(lee()), TAM)


class LaInterrupcion(unittest.TestCase):
    def test_va_por_h_timi(self):
        self.assertEqual([instruccion(a) for a in (0x8032, 0x8035, 0x8038, 0x803A)],
                         ["ld hl,08cd2h", "ld (0fda0h),hl", "ld a,0c3h", "ld (0fd9fh),a"])


def texto(a, n):
    """Casilla = letra - 0x30; 0x10 es el espacio."""
    return "".join(" " if c == 0x10 else chr(c + 0x30) for c in lee()[a - ORG:a - ORG + n])


class LosTextos(unittest.TestCase):
    def test_el_titulo(self):
        self.assertEqual(texto(0x9049, 20), "PUSH TRIG:1 OR SPACE")
        self.assertEqual(texto(0x9026, 10), "GAME START")
        self.assertEqual(texto(0x907B, 9), "GAME OVER")

    def test_continuar(self):
        self.assertEqual(texto(0x862E, 19), "CONTINUE PUSH TRIG1")
        self.assertEqual(texto(0x8641, 19), "END      PUSH TRIG2")

    def test_el_jefe_escribe_iga2(self):
        self.assertEqual(texto(0xAC4D, 4), "IGA2")
        self.assertEqual(instruccion(0xAAFD), "ld hl,0ac4dh")

    def test_score_dentro_de_hiscore(self):
        self.assertEqual(texto(0x9073, 8), "HISCORE:")
        self.assertEqual([instruccion(a) for a in (0x87A8, 0x87B4)], ["ld hl,09073h", "ld hl,09075h"])


class LasTeclasDelTitulo(unittest.TestCase):
    def test_bs_el_ninja_no_cae(self):
        self.assertEqual([instruccion(a) for a in (0x809C, 0x80A1, 0x80A7)],
                         ["ld a,007h", "bit 5,a", "ld (0e023h),a"])
        self.assertEqual([instruccion(a) for a in (0x8513, 0x851A)], ["ld a,(0e023h)", "ld (0e183h),a"])

    def test_2_a_i_g_continuar(self):
        self.assertEqual([instruccion(a) for a in (0x80AE, 0x80B7, 0x80C0, 0x80C4, 0x80CA)],
                         ["bit 2,a", "bit 6,a", "bit 6,a", "bit 4,a", "ld (0e039h),a"])
        self.assertEqual(instruccion(0x85B7), "ld a,(0e039h)")


class LaPartida(unittest.TestCase):
    def test_cuatro_vidas(self):
        self.assertEqual([instruccion(a) for a in (0x81E4, 0x81E6)], ["ld a,004h", "ld (0e00bh),a"])

    def test_siete_fases_y_tres_vueltas(self):
        self.assertEqual([instruccion(a) for a in (0x866C, 0x8680)], ["cp 007h", "cp 003h"])

    def test_la_luna_mata_al_acabarse(self):
        self.assertEqual([instruccion(a) for a in (0x88A9, 0x88AB)], ["ld a,002h", "ld (0e183h),a"])

    def test_con_el_primer_iga_la_luna_no_cambia(self):
        self.assertEqual([instruccion(a) for a in (0x8862, 0x8868)], ["ld a,(0e060h)", "ld de,0890ah"])

    def test_una_vida_mas_a_los_10000(self):
        self.assertEqual([instruccion(a) for a in (0x8C32, 0x8C43)], ["cp 010h", "inc a"])


class Sonido(unittest.TestCase):
    def test_seis_musicas(self):
        for k in range(6):
            for j in range(3):
                self.assertTrue(0xB432 <= w(0xB000 + 6 * k + 2 * j) < 0xC000)


class ElListado(unittest.TestCase):
    def test_densidad_y_flojas(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "densidad.py"), ASM],
            capture_output=True, text=True, check=True).stdout
        m = re.search(r"(\d+) instrucciones, (\d+) comentarios", salida)
        self.assertGreaterEqual(int(m.group(2)) * 100, 40 * int(m.group(1)))
        self.assertIn("---- 0 rutinas por debajo del 10 %", salida)

    def test_ningun_call_sin_nombre(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "sin_bautizar.py"), ASM],
            capture_output=True, text=True, check=True).stdout
        self.assertTrue(salida.startswith("0 rutinas sin bautizar"), salida[:200])

    def test_cada_comentario_en_su_instruccion(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "valida_c.py"), ASM, NOTAS],
            capture_output=True, text=True, check=True).stdout
        self.assertIn("0 fuera de sitio, 0 repetidos", salida)


if __name__ == "__main__":
    unittest.main()
