# LAS TECLAS de la partida: la barra en el cuadro 400; jugando, quieto; STOP en el cuadro 1000; C y W pulsadas de
# 1150 a 1400; STOP otra vez en 1600; F1 en 2200. 3200 cuadros.
proc m {a} { return [debug read memory $a] }
proc toca {fila bit} {
    keymatrixdown $fila $bit
    after time 0.05 "keymatrixup $fila $bit"
}
proc guion {n} {
    if {$n == 400} { toca 8 0x01 }
    if {$n == 1000 || $n == 1600} { toca 7 0x10 }
    if {$n == 1150} { keymatrixdown 3 0x01; keymatrixdown 5 0x10 }
    if {$n == 1400} { keymatrixup 3 0x01; keymatrixup 5 0x10 }
    if {$n == 2200} { toca 6 0x20 }
    return [expr {$n >= 3200}]
}
