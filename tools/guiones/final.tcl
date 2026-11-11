# FORZADA: el final. Con BS pulsada en el titulo; nada mas empezar, la vuelta 2, la fase 5, 9 vidas y la fase
# acabada (0xE009, 0xE00A, 0xE00B, 0xE186): se juega la fase 6 de la tercera vuelta con el piloto de invencible.tcl
# hasta vencer al jefe (o, a los 9000 cuadros, otro poke a 0xE186), y despues el final. Hasta el titulo + 300.
expr {srand(3)}
proc m {a} { return [debug read memory $a] }
proc pon {a v} { debug write memory $a $v }
proc toca {fila bit} {
    keymatrixdown $fila $bit
    after time 0.05 "keymatrixup $fila $bit"
}
set ::desde -1
proc guion {n} {
    if {$n < 390} { keymatrixdown 7 0x20 } else { keymatrixup 7 0x20 }
    if {[m 0xE000] == 0} {
        keymatrixup 8 0xF0
        if {$n == 400} { toca 8 0x01 }
        if {[info exists ::empezada]} {
            if {![info exists ::fin]} { set ::fin $n }
            return [expr {$n >= $::fin + 300}]
        }
        return [expr {$n >= 30000}]
    }
    if {![info exists ::empezada]} { set ::empezada $n }
    if {$n == $::empezada + 200} { pon 0xE009 2; pon 0xE00A 5; pon 0xE00B 9; pon 0xE186 1 }
    if {[m 0xE00A] == 6 && $::desde < 0} { set ::desde $n }
    if {$::desde > 0 && $n == $::desde + 9000} { pon 0xE186 1 }
    keymatrixup 8 0xF0
    if {$n % 8 == 0} { toca 8 0x01 }
    if {$n % 70 == 0} { toca 6 0x04 }
    if {($n / 120) % 5 != 4} { keymatrixdown 8 0x80 } else { keymatrixdown 8 0x10 }
    if {$n % 50 < 6} { keymatrixdown 8 0x20 }
    return [expr {$n >= 30000}]
}
