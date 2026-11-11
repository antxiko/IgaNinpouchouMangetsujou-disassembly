# CON EL PRIMER IGA NINPOUCHOU en el segundo slot (lanza_graba.ps1 -rom2): la misma partida que prueba.tcl, sin
# trucos. La barra en el cuadro 400; jugando, la derecha casi siempre, la barra cada 8 cuadros, arriba cada 50 y
# GRAPH cada 300. 12000 cuadros o GAME OVER + 300.
expr {srand(7)}
proc m {a} { return [debug read memory $a] }
proc toca {fila bit} {
    keymatrixdown $fila $bit
    after time 0.05 "keymatrixup $fila $bit"
}
proc guion {n} {
    if {[m 0xE000] == 0} {
        keymatrixup 8 0xF0
        if {$n == 400} { toca 8 0x01 }
        if {[info exists ::empezada]} {
            if {![info exists ::fin]} { set ::fin $n }
            return [expr {$n >= $::fin + 300}]
        }
        return [expr {$n >= 12000}]
    }
    set ::empezada 1
    keymatrixup 8 0xF0
    if {$n % 8 == 0} { toca 8 0x01 }
    if {$n % 300 == 0} { toca 6 0x04 }
    if {($n / 120) % 5 != 4} { keymatrixdown 8 0x80 } else { keymatrixdown 8 0x10 }
    if {$n % 50 < 6} { keymatrixdown 8 0x20 }
    return [expr {$n >= 12000}]
}
