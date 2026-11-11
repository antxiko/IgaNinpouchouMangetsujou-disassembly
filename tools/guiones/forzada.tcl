# FORZADA: un recorrido por las fases con BS pulsada en el titulo. El piloto de invencible.tcl juega cada fase
# 1800 cuadros y despues se da por acabada con un poke (0xE186 = 1); en la fase 6 juega hasta 6000 cuadros por si
# vence al jefe. En la segunda vuelta, nada mas empezar, se pone la vuelta 2 y la fase 5 (0xE009, 0xE00A) y se acaba:
# la fase 6 de la tercera vuelta, y despues el final. Hasta el titulo + 300 o 90000 cuadros.
expr {srand(7)}
proc m {a} { return [debug read memory $a] }
proc pon {a v} { debug write memory $a $v }
proc toca {fila bit} {
    keymatrixdown $fila $bit
    after time 0.05 "keymatrixup $fila $bit"
}
set ::fase -1
set ::desde 0
proc guion {n} {
    if {$n < 390} { keymatrixdown 7 0x20 } else { keymatrixup 7 0x20 }
    if {[m 0xE000] == 0} {
        keymatrixup 8 0xF0
        if {$n == 400} { toca 8 0x01 }
        if {[info exists ::empezada]} {
            if {![info exists ::fin]} { set ::fin $n }
            return [expr {$n >= $::fin + 300}]
        }
        return [expr {$n >= 90000}]
    }
    set ::empezada 1
    set f [expr {[m 0xE00A] + 10 * [m 0xE009]}]
    if {$f != $::fase} { set ::fase $f; set ::desde $n }
    set t [expr {$n - $::desde}]
    if {[m 0xE009] == 1 && $t == 200} { pon 0xE009 2; pon 0xE00A 5; pon 0xE186 1 }
    if {[m 0xE00A] == 6} { set tope 6000 } else { set tope 1800 }
    if {$t == $tope && [m 0xE009] != 1} { pon 0xE186 1 }
    keymatrixup 8 0xF0
    if {$n % 8 == 0} { toca 8 0x01 }
    if {$n % 70 == 0} { toca 6 0x04 }
    if {($n / 120) % 5 != 4} { keymatrixdown 8 0x80 } else { keymatrixdown 8 0x10 }
    if {$n % 50 < 6} { keymatrixdown 8 0x20 }
    return [expr {$n >= 90000}]
}
