# Con BS pulsada en el titulo (0xE023: los enemigos no lo matan): la barra en el cuadro 400; jugando, la derecha
# casi siempre (un rato a la izquierda cada 600 cuadros), la barra cada 8 cuadros, arriba unos cuadros cada 50 y
# GRAPH (el salto) cada 70. 40000 cuadros.
expr {srand(7)}
proc m {a} { return [debug read memory $a] }
proc toca {fila bit} {
    keymatrixdown $fila $bit
    after time 0.05 "keymatrixup $fila $bit"
}
proc guion {n} {
    if {$n < 390} { keymatrixdown 7 0x20 } else { keymatrixup 7 0x20 }
    if {[m 0xE000] == 0} {
        keymatrixup 8 0xF0
        if {$n == 400} { toca 8 0x01 }
        return [expr {$n >= 40000}]
    }
    keymatrixup 8 0xF0
    if {$n % 8 == 0} { toca 8 0x01 }
    if {$n % 70 == 0} { toca 6 0x04 }
    if {($n / 120) % 5 != 4} { keymatrixdown 8 0x80 } else { keymatrixdown 8 0x10 }
    if {$n % 50 < 6} { keymatrixdown 8 0x20 }
    return [expr {$n >= 40000}]
}
