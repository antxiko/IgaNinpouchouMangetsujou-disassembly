#!/usr/bin/env python3
"""EL CONTENIDO de la web de esta ROM: lo unico que es de este juego.

jekyll.py y make_web.py son la maquinaria y no llevan dentro el nombre de
ningun juego: lo leen de aqui.

Todas las cifras de aqui estan medidas sobre esta ROM, con las herramientas
de tools/: CODIGO y DATOS los imprime tools/presupuesto.py (make sanity),
INSTRUCCIONES, COMENTARIOS y RUTINAS los da tools/densidad.py (make densidad:
"de N" rutinas, "N instrucciones, M comentarios").
"""

NOMBRE = "Iga Ninpouchou Mangetsu-jou no Tatakai"
EDITOR = "Casio"
ANIO = 1986
REPOSITORIO = "https://github.com/antxiko/IgaNinpouchouMangetsujou-disassembly"
SHA1 = "f52113b45062adc75cf7a0ed0538b3a07696cc24"

CODIGO = 10863
DATOS = 21905
RUTINAS = 631
INSTRUCCIONES = 4862
COMENTARIOS = 2246


def densidad(idioma):
    """El porcentaje comentado, con la coma o el punto de cada idioma."""
    d = "%.1f" % (100.0 * COMENTARIOS / INSTRUCCIONES)
    return d.replace(".", ",") if idioma == "es" else d


PIE_LEGAL = {
    "es": "<em>Iga Ninpouchou Mangetsu-jou no Tatakai</em> es un juego de Casio para MSX, de 1986, en un cartucho "
          "de 32 KB. Todos los derechos sobre el juego siguen siendo de sus titulares. Este trabajo es de "
          "preservaci&oacute;n, estudio y documentaci&oacute;n, y la imagen de la ROM no se distribuye.",
    "en": "<em>Iga Ninpouchou Mangetsu-jou no Tatakai</em> is a 1986 Casio game for the MSX, on a 32 KB cartridge. "
          "All rights in the game remain with their holders. This is preservation, study and documentation work, "
          "and the ROM image is not distributed.",
}

PORTADA = {
    "es": dict(
        titulo="Iga Ninpouchou Mangetsu-jou no Tatakai - desensamblado comentado",
        claim="Un ninja de Iga cruza el puente, entra en el castillo y sube hasta su torre: siete fases, tres "
              "vueltas y una luna que hace de reloj. Con el primer Iga Ninpouchou puesto en el otro slot, la luna "
              "se para. El t&iacute;tulo sale de ejecutar la ROM, cotejado con openMSX punto a punto; la partida "
              "en GIF, jugada en openMSX; las cinco m&uacute;sicas, de su propio motor, id&eacute;nticas a openMSX "
              "cuadro a cuadro.",
        ficha=["Casio - <b>(c) 1986</b>",
               "Cartucho de <b>32 KB</b> (cabecera en 0x4000)",
               "<b>MSX</b>", "Volcado <b>f52113b4...</b>"],
        aviso="<b>Aqu&iacute; no hay capturas del juego.</b> El t&iacute;tulo sale de ejecutar la ROM (cotejado "
              "con openMSX) y los GIF son la ROM <b>funcionando en openMSX</b>: en cada cuadro se apuntan la VRAM, "
              "la RAM y los registros del VDP, y <b>c&oacute;digo nuestro los pinta</b>.",
    ),
    "en": dict(
        titulo="Iga Ninpouchou Mangetsu-jou no Tatakai - commented disassembly",
        claim="An Iga ninja crosses the bridge, gets into the castle and climbs to its tower: seven stages, three "
              "rounds and a moon that works as a clock. With the first Iga Ninpouchou in the other slot, the moon "
              "stops. The title comes from running the ROM, checked against openMSX point by point; the game in "
              "GIF, played in openMSX; the five tunes, from its own engine, identical to openMSX frame by frame.",
        ficha=["Casio - <b>(c) 1986</b>",
               "<b>32 KB</b> cartridge (header at 0x4000)",
               "<b>MSX</b>", "Dump <b>f52113b4...</b>"],
        aviso="<b>There are no screenshots of the game here.</b> The title comes from running the ROM (checked "
              "against openMSX) and the GIFs are the ROM <b>running in openMSX</b>: on every frame the VRAM, the "
              "RAM and the VDP registers are logged, and <b>our own code paints them</b>.",
    ),
}

PAGINAS = [
    [("THE-GAME.html", "LA-PARTIDA.html", "The game", "La partida",
      "the CASIO intro, the title, the controls, the shuriken and the jump, the moon, the lives and the points",
      "la presentaci&oacute;n de CASIO, el t&iacute;tulo, los mandos, el shuriken y el salto, la luna, las vidas "
      "y los puntos"),
     ("THE-STAGES.html", "LAS-FASES.html", "The stages", "Las fases",
      "the seven stages, the enemies, the chests and what is inside, the exits and the boss",
      "las siete fases, los enemigos, los cofres y lo que llevan, las salidas y el jefe"),
     ("THE-SPRITES.html", "LOS-SPRITES.html", "The sprites", "Los sprites",
      "the ninja, the enemy ninja, what they throw and the boss put together from the ROM tables",
      "el ninja, los ninja enemigos, lo que tiran y el jefe montados desde las tablas de la ROM"),
     ("THE-TEXTS.html", "LOS-TEXTOS.html", "The texts", "Los textos",
      "every text in the ROM, with its translation",
      "todos los textos de la ROM, con su traducci&oacute;n"),
     ("THE-MUSIC.html", "LA-MUSICA.html", "The music", "La m&uacute;sica",
      "the five tunes, from its own sound engine and checked against openMSX",
      "las cinco m&uacute;sicas, de su propio motor de sonido y cotejadas con openMSX")],
    [("CURIOSITIES.html", "CURIOSIDADES.html", "Curiosities", "Curiosidades",
      "two cartridges at once, the keys on the title, IGA2, STOP and F1, colours read from the BIOS",
      "dos cartuchos a la vez, las teclas del t&iacute;tulo, IGA2, STOP y F1, colores le&iacute;dos de la BIOS"),
     ("SECRETS-AND-BUGS.html", "SECRETOS-Y-FALLOS.html", "Secrets and bugs", "Secretos y fallos",
      "what was searched for: six hidden tricks in one table, the high score set to zero past 9,999,990, and the cursor keys and joystick mixed",
      "lo que se ha buscado: seis trucos escondidos en una tabla, el r&eacute;cord a cero pasados los 9.999.990, y los cursores y el mando que se mezclan")],
    [("UNDER-THE-HOOD.html", "POR-DENTRO.html", "Under the hood", "Por dentro",
      "rebuilding the ROM, the cartridge, the BIOS it uses, the main loop, the map, the RAM and the tools",
      "rehacer la ROM, el cartucho, la BIOS que usa, el bucle, el mapa, la RAM y las herramientas")],
]

# Repositorio nuevo: no hay paginas viejas que redirigir.
VIEJAS = {}

LOGOTIPO = "logotipo.png"
