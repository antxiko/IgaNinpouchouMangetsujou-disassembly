# UNA PARTIDA con un piloto sencillo, nada forzado. La barra en el cuadro 400. Jugando (0xE000 = 1): anda a la
# derecha; si hay un enemigo (0xE360, 16 bytes: +0 Y, +1 X, +4 tipo) a su altura (0xE300 Y, 0xE301 X), se vuelve
# hacia el y tira el shuriken (la barra) cada 8 cuadros; si algo esta a menos de 0x18 en X, salta hacia el lado
# contrario (GRAPH); y cada 90 cuadros salta. Hasta GAME OVER + 300 o 30000 cuadros.
expr {srand(11)}
proc m {a} { return [debug read memory $a] }
proc toca {fila bit} {
    keymatrixdown $fila $bit
    after time 0.05 "keymatrixup $fila $bit"
}
set ::lado 0x80
proc guion {n} {
    if {[m 0xE000] == 0} {
        keymatrixup 8 0xF0
        if {$n == 400} { toca 8 0x01 }
        if {[info exists ::empezada]} {
            if {![info exists ::fin]} { set ::fin $n }
            return [expr {$n >= $::fin + 300}]
        }
        return [expr {$n >= 30000}]
    }
    set ::empezada 1
    keymatrixup 8 0xF0
    set y [m 0xE300]
    set x [m 0xE301]
    set ::lado 0x80
    set cerca 0
    set mejor 999
    for {set a 0xE360} {$a < 0xE400} {incr a 16} {
        if {[m [expr {$a + 4}]] == 0} continue
        set ey [m $a]
        set ex [m [expr {$a + 1}]]
        if {$ey >= 0xC0} continue
        set dx [expr {$ex - $x}]
        set dy [expr {abs($ey - $y)}]
        if {$dy < 0x10 && abs($dx) < $mejor} {
            set mejor [expr {abs($dx)}]
            if {$dx < 0} { set ::lado 0x10 } else { set ::lado 0x80 }
        }
        if {abs($dx) < 0x18 && $dy < 0x18} { set cerca 1 }
    }
    keymatrixdown 8 $::lado
    if {$n % 8 == 0} { toca 8 0x01 }
    if {$cerca || $n % 90 == 0} { toca 6 0x04 }
    return [expr {$n >= 30000}]
}
