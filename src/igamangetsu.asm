; ==========================================================================
; IGA NINPOUCHOU MANGETSU-JOU NO TATAKAI - ROM de 32 KB en 0x4000
; ==========================================================================
; Generado por tools/mkasm.py a partir del trazado de flujo real.
; Los comentarios provienen de tools/../src/*.notes y estan anclados a
; direccion, de modo que sobreviven a un retrazado.
; ==========================================================================

	org 0x04000


; ----------------------------------------------------------------------
; DATOS cabecera: La cabecera del cartucho: "AB" e INIT 0x4010
;   0x4000..0x4010  (16 bytes)
DATA_cabecera:
	defb 041h,042h,010h,040h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 4000  AB.@............

; ======================================================================
; CODIGO 0x4010..0x406b  (91 bytes)
; ======================================================================


init:		; INIT: busca en los slots (RDSLT, 0x00-0x03 y los expandidos 0x80-0x8F) un 0x21 en 0x81B9, el byte que tiene ahi el primer Iga Ninpouchou: si esta, 0xE000 = 1; pone el cartucho tambien en la pagina 2 (RSLREG, ENASLT con H = 0x80) y salta a 0x8000
	di			;4010   ; sin interrupciones
	call 00041h		;4011   ; DISSCR
	ld hl,081b9h		;4014   ; la direccion que se mira
	ld bc,00400h		;4017   ; los slots 0-3
L_401A:
	ld a,c			;401a
	push bc			;401b
	call 0000ch		;401c   ; RDSLT
	cp 021h		;401f   ; 0x21?
	jp z,L_403B		;4021
	pop bc			;4024
	inc c			;4025
	djnz L_401A		;4026
	ld bc,01080h		;4028   ; los expandidos 0x80-0x8F
L_402B:
	ld a,c			;402b   ; el slot
	push bc			;402c
	call 0000ch		;402d   ; RDSLT
	cp 021h		;4030   ; 0x21?
	jp z,L_403B		;4032   ; esta
	pop bc			;4035
	inc c			;4036   ; el siguiente
	djnz L_402B		;4037
	jr L_4043		;4039   ; no esta
L_403B:
	pop bc			;403b
	ld a,001h		;403c   ; esta: 0xE000 = 1
	ld (0e000h),a		;403e   ; 0xE000 = 1
	jr L_4047		;4041
L_4043:
	xor a			;4043   ; no esta: 0xE000 = 0
	ld (0e000h),a		;4044   ; 0xE000 = 0
L_4047:
	call 00138h		;4047   ; RSLREG: el slot de la pagina 1...
	rrca			;404a   ; el de la pagina 1 (bits 2-3)...
	rrca			;404b
	and 003h		;404c   ; ...sus dos bits
	ld c,a			;404e
	ld b,000h		;404f
	ld hl,0fcc1h		;4051   ; EXPTBL: expandido?
	add hl,bc			;4054
	ld c,a			;4055
	ld a,(hl)			;4056
	and 080h		;4057   ; el bit de expandido
	or c			;4059
	ld c,a			;405a
	inc hl			;405b
	inc hl			;405c
	inc hl			;405d
	inc hl			;405e
	ld a,(hl)			;405f   ; el subslot
	and 00ch		;4060
	or c			;4062
	ld h,080h		;4063   ; la pagina 2
	call 00024h		;4065   ; ENASLT
	jp arranque		;4068   ; al codigo

; ----------------------------------------------------------------------
; DATOS mapas: Los mapas: un puntero a la tabla (0x406B); la tabla de las
;   siete fases (0x406D, la fase x 2: la 0 en 0x40AB, la 1 en 0x4099... la 6
;   en 0x407B), con la lista de las pantallas de cada fase; las pantallas
;   (cuatro listas hasta 0xFF: rectangulos de dos casillas, de una, escaleras
;   y dibujos); los dibujos que ponen; y las tres de la salida (0x477E,
;   0x4790, 0x47A2)
;   0x406b..0x5000  (3989 bytes)
DATA_mapas:
	defb 06dh,040h,0abh,040h,099h,040h,093h,040h,08dh,040h,087h,040h,081h,040h,07bh,040h	; 406b  m@.@.@.@.@.@.@{@
	defb 033h,047h,05ch,047h,033h,047h,016h,046h,07ch,046h,0dfh,046h,0d1h,044h,04dh,045h	; 407b  3G\G3G.F|F.F.DME
	defb 0b0h,045h,0abh,043h,01ah,044h,076h,044h,09ah,042h,0e9h,042h,048h,043h,03ah,041h	; 408b  .E.C.DvD.B.BHC:A
	defb 07fh,041h,09ah,041h,0c5h,041h,0f1h,041h,019h,042h,04ch,042h,075h,042h,0d7h,040h	; 409b  .A.A.A.A.BLBuB.@
	defb 0b7h,040h,0d7h,040h,00dh,041h,03ah,041h,07fh,041h,09ah,041h,00eh,010h,010h,006h	; 40ab  .@.@.A:A.A.A....
	defb 040h,014h,000h,020h,002h,044h,0ffh,0ffh,0ffh,00ah,014h,0fdh,047h,00ah,018h,0fdh	; 40bb  @.. .D......G...
	defb 047h,00ah,01ch,0fdh,047h,006h,00fh,079h,048h,0ffh,0ffh,0ffh,00eh,000h,011h,006h	; 40cb  G...G..yH.......
	defb 040h,014h,000h,020h,002h,044h,0ffh,00eh,010h,010h,001h,03bh,00fh,010h,010h,001h	; 40db  @.. .D.....;....
	defb 09ah,0ffh,0ffh,00ah,000h,0fdh,047h,00ah,004h,0fdh,047h,00ah,008h,0fdh,047h,00ah	; 40eb  ......G...G...G.
	defb 00ch,0fdh,047h,00ch,010h,01fh,048h,010h,010h,041h,048h,010h,01bh,057h,048h,0ffh	; 40fb  ..G...H..AH..WH.
	defb 0ffh,0ffh,014h,000h,020h,002h,044h,0ffh,00eh,000h,020h,001h,03bh,00fh,000h,020h	; 410b  .... .D... .;.. 
	defb 001h,09ah,0ffh,0ffh,00ch,000h,01fh,048h,00ch,010h,01fh,048h,010h,000h,041h,048h	; 411b  .......H...H..AH
	defb 010h,00bh,057h,048h,010h,010h,041h,048h,010h,01bh,057h,048h,0ffh,0ffh,0ffh,014h	; 412b  ..WH..AH..WH....
	defb 000h,020h,002h,044h,00eh,019h,007h,002h,040h,010h,017h,009h,002h,040h,012h,015h	; 413b  . .D....@....@..
	defb 00bh,002h,040h,014h,013h,00dh,002h,040h,0ffh,00eh,000h,019h,001h,03bh,00fh,000h	; 414b  ..@....@.....;..
	defb 019h,001h,09ah,0ffh,0ffh,00ch,000h,01fh,048h,00ch,010h,01fh,048h,010h,000h,041h	; 415b  ........H...H..A
	defb 048h,010h,00bh,057h,048h,010h,010h,041h,048h,006h,018h,079h,048h,006h,019h,083h	; 416b  H..WH..AH..yH...
	defb 048h,0ffh,0ffh,0ffh,00eh,000h,020h,008h,040h,0ffh,0ffh,0ffh,007h,000h,0ffh,048h	; 417b  H..... .@......H
	defb 007h,004h,0ffh,048h,007h,008h,0ffh,048h,006h,00ch,083h,048h,0ffh,0ffh,0ffh,00eh	; 418b  ...H...H...H....
	defb 000h,020h,008h,040h,0ffh,0ffh,0ffh,00ch,004h,00fh,048h,00ah,008h,0fdh,047h,00ch	; 419b  . .@......H...G.
	defb 010h,00fh,048h,00ch,013h,00fh,048h,007h,01eh,01dh,049h,00ch,016h,015h,048h,00ch	; 41ab  ..H...H...I...H.
	defb 01ah,015h,048h,00ah,018h,015h,048h,0ffh,0ffh,0ffh,00eh,000h,012h,008h,040h,014h	; 41bb  ..H...H.......@.
	defb 014h,002h,002h,040h,012h,016h,002h,004h,040h,010h,018h,002h,006h,040h,00eh,01ah	; 41cb  ...@....@....@..
	defb 006h,008h,040h,0ffh,015h,012h,002h,001h,03dh,0ffh,0ffh,00ch,007h,015h,048h,006h	; 41db  ..@.....=.....H.
	defb 018h,0bdh,048h,0ffh,0ffh,0ffh,00eh,000h,00eh,008h,040h,00eh,00eh,004h,002h,040h	; 41eb  ..H.......@....@
	defb 00eh,014h,002h,002h,040h,00eh,018h,002h,002h,040h,00eh,01ch,002h,002h,040h,0ffh	; 41fb  ....@....@....@.
	defb 015h,00eh,012h,001h,03dh,0ffh,0ffh,006h,006h,0bdh,048h,0ffh,0ffh,0ffh,00eh,000h	; 420b  ....=.....H.....
	defb 004h,008h,040h,010h,004h,002h,006h,040h,012h,006h,002h,004h,040h,012h,00ah,002h	; 421b  ..@....@....@...
	defb 004h,040h,010h,00ch,002h,006h,040h,00eh,00eh,012h,008h,040h,0ffh,015h,008h,002h	; 422b  .@....@....@....
	defb 001h,03dh,0ffh,0ffh,006h,010h,0bdh,048h,00ch,018h,015h,048h,00ch,01ch,015h,048h	; 423b  .=.....H...H...H
	defb 0ffh,00eh,000h,020h,008h,040h,0ffh,0ffh,0ffh,007h,004h,01dh,049h,007h,01eh,01dh	; 424b  ... .@......I...
	defb 049h,00ch,007h,00fh,048h,00ch,00bh,00fh,048h,00ch,012h,00fh,048h,00ch,016h,015h	; 425b  I...H...H...H...
	defb 048h,00ch,01ah,015h,048h,00ah,018h,015h,048h,0ffh,00eh,000h,020h,008h,040h,0ffh	; 426b  H...H...H... .@.
	defb 0ffh,0ffh,00ch,002h,00fh,048h,00ch,005h,00fh,048h,00ch,008h,00fh,048h,006h,010h	; 427b  .....H...H...H..
	defb 079h,048h,006h,011h,083h,048h,007h,018h,0ffh,048h,007h,01ch,0ffh,048h,0ffh,014h	; 428b  yH...H...H...H..
	defb 000h,010h,002h,040h,000h,010h,010h,001h,0b2h,0ffh,001h,010h,010h,001h,0b7h,007h	; 429b  ...@............
	defb 010h,010h,001h,03ah,00eh,010h,010h,001h,03ah,015h,010h,010h,001h,03ah,0ffh,00eh	; 42ab  ...:....:....:..
	defb 01ch,000h,007h,000h,0ffh,008h,014h,0b4h,047h,002h,014h,0cah,047h,002h,010h,0eeh	; 42bb  ........G...G...
	defb 047h,008h,010h,0dch,047h,00fh,010h,0e5h,047h,00eh,000h,0ffh,048h,00eh,004h,0ffh	; 42cb  G...G...G...H...
	defb 048h,00eh,008h,0ffh,048h,00eh,00ch,0ffh,048h,001h,019h,068h,047h,0ffh,000h,000h	; 42db  H...H...H..hG...
	defb 020h,001h,0b2h,0ffh,001h,000h,020h,001h,0b7h,007h,000h,020h,001h,03ah,00eh,000h	; 42eb   ..... .... .:..
	defb 020h,001h,03ah,015h,000h,020h,001h,03ah,0ffh,007h,003h,001h,007h,000h,00eh,018h	; 42fb   .:.. .:........
	defb 000h,007h,000h,0ffh,002h,00eh,073h,047h,002h,015h,073h,047h,00ah,00dh,07eh,047h	; 430b  ......sG..sG..~G
	defb 002h,008h,0cah,047h,002h,01ah,0cah,047h,008h,01bh,0b4h,047h,00fh,01ah,0b4h,047h	; 431b  ...G...G...G...G
	defb 014h,005h,06dh,047h,013h,005h,06dh,047h,012h,005h,06dh,047h,00fh,01fh,0eeh,047h	; 432b  ..mG..mG..mG...G
	defb 001h,005h,068h,047h,001h,011h,068h,047h,001h,01dh,068h,047h,0ffh,000h,000h,020h	; 433b  ..hG..hG..hG... 
	defb 001h,0b2h,0ffh,001h,000h,020h,001h,0b7h,007h,000h,020h,001h,03ah,00eh,000h,020h	; 434b  ..... .... .:.. 
	defb 001h,03ah,015h,000h,020h,001h,03ah,0ffh,007h,003h,001h,007h,000h,00eh,00bh,000h	; 435b  .:.. .:.........
	defb 007h,000h,0ffh,002h,006h,0cah,047h,002h,017h,0cah,047h,009h,00bh,073h,047h,009h	; 436b  ......G...G..sG.
	defb 00fh,073h,047h,009h,013h,073h,047h,009h,017h,073h,047h,006h,00bh,06dh,047h,006h	; 437b  .sG..sG..sG..mG.
	defb 011h,06dh,047h,00fh,010h,0b4h,047h,00fh,017h,0b4h,047h,002h,01eh,0e5h,047h,008h	; 438b  .mG...G...G...G.
	defb 01eh,0e5h,047h,00fh,01eh,0e5h,047h,001h,009h,068h,047h,001h,015h,068h,047h,0ffh	; 439b  ..G...G..hG..hG.
	defb 000h,000h,020h,001h,0b2h,0ffh,001h,000h,020h,001h,0b7h,007h,000h,020h,001h,03ah	; 43ab  .. ..... .... .:
	defb 00eh,000h,020h,001h,03ah,015h,000h,020h,001h,03ah,0ffh,007h,013h,001h,007h,000h	; 43bb  .. .:.. .:......
	defb 00eh,013h,001h,007h,000h,0ffh,002h,005h,0cah,047h,002h,01ch,0cah,047h,002h,00ah	; 43cb  .........G...G..
	defb 073h,047h,002h,00eh,073h,047h,004h,015h,06dh,047h,005h,015h,06dh,047h,006h,015h	; 43db  sG..sG..mG..mG..
	defb 06dh,047h,008h,005h,0b4h,047h,009h,00ah,073h,047h,009h,00eh,073h,047h,00bh,01ch	; 43eb  mG...G..sG..sG..
	defb 06dh,047h,00ch,01ch,06dh,047h,00dh,01ch,06dh,047h,00fh,005h,0b4h,047h,010h,00ah	; 43fb  mG..mG..mG...G..
	defb 073h,047h,010h,00eh,073h,047h,010h,01ch,073h,047h,002h,019h,0f6h,047h,0ffh,000h	; 440b  sG..sG..sG...G..
	defb 000h,020h,001h,0b2h,0ffh,001h,000h,020h,001h,0b7h,007h,000h,020h,001h,03ah,00eh	; 441b  . ..... .... .:.
	defb 000h,020h,001h,03ah,015h,000h,020h,001h,03ah,0ffh,007h,00dh,000h,007h,000h,007h	; 442b  . .:.. .:.......
	defb 01bh,000h,007h,000h,00eh,00fh,000h,007h,000h,0ffh,002h,004h,0cah,047h,002h,00bh	; 443b  .............G..
	defb 0cah,047h,002h,010h,0f6h,047h,002h,012h,0cah,047h,002h,018h,0cah,047h,008h,002h	; 444b  .G...G...G...G..
	defb 0b4h,047h,00ah,00dh,07eh,047h,008h,01dh,0eeh,047h,00fh,001h,0eeh,047h,00fh,011h	; 445b  .G..~G...G...G..
	defb 0b4h,047h,00fh,017h,0eeh,047h,00fh,019h,0b4h,047h,0ffh,000h,000h,020h,001h,0b2h	; 446b  .G...G...G... ..
	defb 0ffh,001h,000h,020h,001h,0b7h,007h,000h,020h,001h,03ah,00eh,000h,020h,001h,03ah	; 447b  ... .... .:.. .:
	defb 015h,000h,020h,001h,03ah,0ffh,007h,003h,001h,007h,000h,00eh,003h,001h,007h,000h	; 448b  .. .:...........
	defb 0ffh,002h,002h,0cah,047h,004h,00ah,06dh,047h,005h,00ah,06dh,047h,006h,00ah,06dh	; 449b  ....G..mG..mG..m
	defb 047h,004h,012h,06dh,047h,005h,012h,06dh,047h,006h,012h,06dh,047h,002h,018h,0cah	; 44ab  G..mG..mG..mG...
	defb 047h,008h,010h,0b4h,047h,009h,016h,073h,047h,009h,01bh,073h,047h,00fh,010h,0b4h	; 44bb  G...G..sG..sG...
	defb 047h,00fh,016h,0b4h,047h,0ffh,000h,000h,020h,001h,0b2h,0ffh,001h,000h,020h,001h	; 44cb  G...G... ..... .
	defb 0b7h,007h,000h,014h,001h,03ah,007h,017h,004h,001h,03ah,007h,01eh,002h,001h,03ah	; 44db  .....:....:....:
	defb 00eh,000h,018h,001h,03ah,00eh,01ah,006h,001h,03ah,015h,000h,020h,001h,03ah,0ffh	; 44eb  ....:....:.. .:.
	defb 0ffh,002h,000h,0eeh,047h,008h,000h,0e5h,047h,00fh,000h,0e5h,047h,002h,005h,0cah	; 44fb  ....G...G...G...
	defb 047h,004h,00bh,06dh,047h,005h,00bh,06dh,047h,006h,00bh,06dh,047h,002h,011h,073h	; 450b  G..mG..mG..mG..s
	defb 047h,002h,017h,0cah,047h,008h,005h,0b4h,047h,011h,00bh,06dh,047h,00ch,011h,06dh	; 451b  G...G...G..mG..m
	defb 047h,00dh,011h,06dh,047h,009h,00bh,073h,047h,00fh,005h,0b4h,047h,012h,00bh,06dh	; 452b  G..mG..sG...G..m
	defb 047h,013h,00bh,06dh,047h,014h,00bh,06dh,047h,00fh,013h,0b4h,047h,00fh,01bh,0b4h	; 453b  G..mG..mG...G...
	defb 047h,0ffh,000h,000h,020h,001h,0b2h,0ffh,001h,000h,020h,001h,0b7h,007h,000h,005h	; 454b  G... ..... .....
	defb 001h,03ah,007h,007h,010h,001h,03ah,007h,01ah,006h,001h,03ah,00eh,000h,00ah,001h	; 455b  .:....:....:....
	defb 03ah,00eh,00dh,00ch,001h,03ah,00eh,01ch,004h,001h,03ah,015h,000h,020h,001h,03ah	; 456b  :....:....:.. .:
	defb 0ffh,007h,00ah,000h,007h,000h,00eh,014h,000h,007h,000h,0ffh,002h,00dh,0cah,047h	; 457b  ...............G
	defb 002h,002h,073h,047h,002h,007h,073h,047h,002h,014h,073h,047h,002h,019h,073h,047h	; 458b  ..sG..sG..sG..sG
	defb 00ah,00dh,07eh,047h,009h,014h,073h,047h,009h,019h,073h,047h,00fh,005h,0b4h,047h	; 459b  ..~G..sG..sG...G
	defb 00fh,01ch,0b4h,047h,0ffh,000h,000h,020h,001h,0b2h,0ffh,001h,000h,020h,001h,0b7h	; 45ab  ...G... ..... ..
	defb 007h,000h,020h,001h,03ah,00eh,000h,014h,001h,03ah,00eh,017h,009h,001h,03ah,015h	; 45bb  .. .:....:....:.
	defb 000h,020h,001h,03ah,0ffh,0ffh,002h,004h,0cah,047h,002h,00bh,0cah,047h,002h,011h	; 45cb  . .:.....G...G..
	defb 073h,047h,002h,015h,073h,047h,002h,019h,0cah,047h,00dh,006h,06dh,047h,00ch,008h	; 45db  sG..sG...G..mG..
	defb 06dh,047h,00bh,008h,06dh,047h,00dh,00ah,06dh,047h,009h,011h,073h,047h,009h,015h	; 45eb  mG..mG..mG..sG..
	defb 073h,047h,008h,019h,0b4h,047h,00fh,004h,0b4h,047h,00fh,00ch,0b4h,047h,010h,011h	; 45fb  sG...G...G...G..
	defb 073h,047h,010h,015h,073h,047h,00fh,019h,0b4h,047h,0ffh,000h,000h,020h,001h,0b2h	; 460b  sG..sG...G... ..
	defb 0ffh,001h,000h,020h,001h,0b7h,007h,000h,004h,001h,03ah,007h,006h,012h,001h,03ah	; 461b  ... ......:....:
	defb 007h,01ch,004h,001h,03ah,00eh,000h,006h,001h,03ah,00eh,008h,011h,001h,03ah,00eh	; 462b  ....:....:....:.
	defb 01ch,004h,001h,03ah,015h,000h,020h,001h,03ah,0ffh,00eh,015h,001h,007h,000h,0ffh	; 463b  ...:.. .:.......
	defb 002h,008h,0cah,047h,002h,010h,0cah,047h,002h,01ch,0cah,047h,008h,008h,0b4h,047h	; 464b  ...G...G...G...G
	defb 008h,00dh,0e5h,047h,008h,010h,0b4h,047h,008h,01ch,0b4h,047h,00fh,008h,0b4h,047h	; 465b  ...G...G...G...G
	defb 00fh,010h,0b4h,047h,010h,003h,073h,047h,009h,016h,073h,047h,002h,003h,073h,047h	; 466b  ...G..sG..sG..sG
	defb 0ffh,000h,000h,020h,001h,0b2h,0ffh,001h,000h,020h,001h,0b7h,007h,003h,01dh,001h	; 467b  ... ..... ......
	defb 03ah,00eh,003h,003h,001h,03ah,00eh,008h,018h,001h,03ah,015h,000h,020h,001h,03ah	; 468b  :....:....:.. .:
	defb 0ffh,007h,01bh,000h,007h,000h,0ffh,002h,006h,0cah,047h,002h,00bh,073h,047h,002h	; 469b  ..........G..sG.
	defb 00fh,0cah,047h,002h,014h,073h,047h,002h,018h,0cah,047h,002h,01eh,0f6h,047h,009h	; 46ab  ..G..sG...G...G.
	defb 004h,073h,047h,008h,009h,0b4h,047h,00ah,00dh,07eh,047h,013h,002h,06dh,047h,014h	; 46bb  .sG...G..~G..mG.
	defb 002h,06dh,047h,00fh,00ah,0b4h,047h,00fh,011h,0b4h,047h,00fh,017h,0eeh,047h,00fh	; 46cb  .mG...G...G...G.
	defb 019h,0b4h,047h,0ffh,015h,010h,010h,001h,040h,000h,000h,010h,001h,0b2h,0ffh,001h	; 46db  ..G.....@.......
	defb 000h,010h,001h,0b7h,007h,000h,010h,001h,03ah,00eh,000h,010h,001h,03ah,015h,000h	; 46eb  ........:....:..
	defb 010h,001h,03ah,0ffh,007h,003h,001h,007h,000h,00eh,003h,001h,007h,000h,0ffh,002h	; 46fb  ..:.............
	defb 004h,0cah,047h,002h,00ah,0cah,047h,008h,00ah,0b4h,047h,002h,00fh,0eeh,047h,008h	; 470b  ..G...G...G...G.
	defb 00fh,0dch,047h,00fh,00fh,0e5h,047h,00eh,010h,0ffh,048h,00eh,014h,0ffh,048h,00eh	; 471b  ..G...G...H...H.
	defb 018h,0ffh,048h,00eh,01ch,0ffh,048h,0ffh,015h,000h,020h,001h,040h,0ffh,0ffh,0ffh	; 472b  ..H...H... .@...
	defb 00eh,000h,0ffh,048h,00eh,004h,0ffh,048h,00eh,008h,0ffh,048h,00eh,00ch,0ffh,048h	; 473b  ...H...H...H...H
	defb 00eh,010h,0ffh,048h,00eh,014h,0ffh,048h,00eh,018h,0ffh,048h,00eh,01ch,0ffh,048h	; 474b  ...H...H...H...H
	defb 0ffh,0ffh,0ffh,0ffh,000h,002h,02dh,049h,011h,000h,00bh,04bh,0ffh,003h,001h,0b7h	; 475b  ......-I...K....
	defb 0b8h,0b9h,004h,001h,063h,052h,053h,067h,003h,003h,060h,061h,062h,064h,065h,066h	; 476b  ....cRSg..`abdef
	defb 068h,069h,06ah,004h,004h,070h,071h,070h,071h,074h,075h,074h,075h,078h,079h,07ah	; 477b  hij..pqpqtutuxyz
	defb 07bh,07ch,07dh,07ch,07dh,004h,004h,070h,071h,071h,010h,074h,075h,075h,010h,078h	; 478b  {|}|}..pqq.tuu.x
	defb 079h,07bh,010h,07ch,07dh,07dh,010h,004h,004h,070h,071h,010h,010h,074h,075h,010h	; 479b  y{.|}}...pq..tu.
	defb 010h,078h,079h,010h,010h,07ch,07dh,010h,010h,004h,005h,0d3h,010h,0d7h,010h,0d4h	; 47ab  .xy..|}.........
	defb 0c1h,0c2h,0c3h,010h,0c5h,0c6h,0c7h,010h,0c5h,0cah,0c7h,010h,0cdh,0ceh,0cfh,004h	; 47bb  ................
	defb 004h,0d4h,0c1h,0c2h,0c3h,010h,0c5h,0c6h,0c7h,010h,0c5h,0cah,0c7h,010h,0cdh,0ceh	; 47cb  ................
	defb 0cfh,001h,007h,05ch,05ch,0b0h,0b0h,05ch,05ch,05ch,001h,007h,05ch,05ch,05ch,05ch	; 47db  ...\\..\\\..\\\\
	defb 05ch,05ch,05ch,001h,006h,05ch,05ch,05ch,05ch,05ch,05ch,001h,005h,05ch,05ch,05ch	; 47eb  \\\..\\\\\\..\\\
	defb 05ch,05ch,004h,004h,010h,083h,096h,010h,0b4h,097h,098h,099h,010h,0a0h,0a1h,010h	; 47fb  \\..............
	defb 0f9h,0f8h,0a9h,010h,002h,002h,050h,051h,054h,055h,004h,002h,010h,056h,057h,010h	; 480b  ......PQTU...VW.
	defb 056h,057h,056h,057h,010h,002h,03fh,010h,010h,010h,03fh,010h,010h,010h,03fh,010h	; 481b  VWVW..?...?...?.
	defb 010h,010h,03fh,010h,010h,010h,09dh,09ch,09ch,09ch,09dh,09ch,09ch,09ch,09dh,09ch	; 482b  ..?.............
	defb 09ch,09ch,09dh,09ch,09ch,09ch,005h,004h,09ah,09ah,09ah,09ah,09eh,09ah,09ah,09ah	; 483b  ................
	defb 09eh,010h,09ah,09ah,09eh,010h,010h,09ah,09ah,010h,010h,010h,005h,004h,09fh,09ah	; 484b  ................
	defb 09ah,09ah,09ah,010h,09fh,09ah,09ah,09ah,010h,010h,09fh,09ah,09ah,010h,010h,010h	; 485b  ................
	defb 09ah,09ah,03fh,010h,010h,03fh,010h,010h,09dh,09ch,09ch,09dh,09ch,09ch,001h,008h	; 486b  ..?..?..........
	defb 03ch,03ch,03ch,03ch,03ch,03ch,03ch,03ch,007h,008h,0bbh,0bbh,0bbh,0bbh,0bbh,0bbh	; 487b  <<<<<<<<........
	defb 0bbh,0b3h,0b3h,0b3h,0b3h,0b3h,0b3h,0b3h,08fh,0b7h,0b7h,0b7h,0b7h,0b7h,08fh,08fh	; 488b  ................
	defb 08dh,08dh,08ch,08dh,08dh,08fh,08fh,08dh,08dh,08ch,08dh,08dh,08fh,08fh,08dh,084h	; 489b  ................
	defb 08ch,084h,08dh,08fh,08fh,08dh,08dh,08ch,08dh,08dh,08fh,08fh,08eh,08eh,08eh,08eh	; 48ab  ................
	defb 08eh,08fh,008h,008h,010h,010h,010h,010h,083h,096h,010h,010h,010h,010h,010h,0b4h	; 48bb  ................
	defb 097h,098h,099h,09bh,010h,010h,0b5h,010h,0a0h,0a1h,010h,010h,010h,0b6h,0bch,0bdh	; 48cb  ................
	defb 0a2h,0a3h,0a4h,0a5h,0beh,0bfh,010h,0dch,0a6h,0a7h,010h,010h,0ddh,0deh,0dfh,0f7h	; 48db  ................
	defb 0a8h,0a9h,0aah,0abh,010h,010h,010h,0f8h,0ach,010h,010h,0adh,010h,0f9h,0fah,0fbh	; 48eb  ................
	defb 0aeh,0afh,010h,010h,004h,007h,05dh,05dh,05dh,05dh,0b3h,0b3h,0b3h,0b3h,05bh,05bh	; 48fb  ......]]]]....[[
	defb 05bh,05bh,058h,058h,058h,058h,058h,058h,058h,058h,058h,058h,058h,058h,059h,05ah	; 490b  [[XXXXXXXXXXXXYZ
	defb 059h,05ah,002h,007h,080h,081h,088h,089h,082h,082h,086h,087h,08ah,08bh,086h,087h	; 491b  YZ..............
	defb 08ah,08bh,01ch,011h,010h,010h,010h,010h,010h,059h,05ah,010h,010h,010h,010h,010h	; 492b  .........YZ.....
	defb 010h,010h,010h,010h,010h,010h,010h,010h,010h,085h,087h,010h,010h,010h,010h,010h	; 493b  ................
	defb 010h,010h,010h,056h,057h,055h,05bh,058h,058h,058h,058h,058h,058h,058h,058h,058h	; 494b  ...VWU[XXXXXXXXX
	defb 058h,058h,058h,058h,058h,084h,086h,05fh,05eh,010h,010h,010h,010h,010h,010h,050h	; 495b  XXXXX.._^......P
	defb 051h,052h,053h,054h,052h,053h,054h,052h,053h,054h,052h,053h,054h,052h,053h,054h	; 496b  QRSTRSTRSTRSTRST
	defb 052h,053h,054h,08bh,08ah,010h,010h,010h,010h,010h,010h,010h,080h,081h,081h,081h	; 497b  RST.............
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,08ch	; 498b  ................
	defb 010h,010h,010h,010h,010h,010h,010h,010h,082h,081h,081h,081h,081h,081h,081h,081h	; 499b  ................
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,08dh,010h,010h,010h,010h	; 49ab  ................
	defb 010h,010h,010h,010h,082h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h	; 49bb  ................
	defb 081h,081h,081h,081h,081h,081h,081h,08dh,010h,010h,010h,010h,010h,010h,010h,010h	; 49cb  ................
	defb 082h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h	; 49db  ................
	defb 081h,081h,081h,08dh,010h,010h,010h,010h,010h,010h,010h,010h,05ch,081h,081h,081h	; 49eb  ............\...
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,08eh	; 49fb  ................
	defb 010h,010h,010h,010h,010h,010h,089h,05dh,081h,081h,081h,081h,081h,081h,081h,081h	; 4a0b  .......]........
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,08fh,0bch,010h,010h	; 4a1b  ................
	defb 061h,060h,088h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h	; 4a2b  a`..............
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,091h,092h,093h,062h,063h,064h,065h	; 4a3b  ............bcde
	defb 066h,067h,068h,066h,067h,068h,066h,067h,068h,066h,067h,068h,066h,067h,068h,066h	; 4a4b  fghfghfghfghfghf
	defb 067h,068h,066h,067h,097h,096h,095h,094h,010h,010h,069h,06ah,06bh,06ch,06ch,06ch	; 4a5b  ghfg......ijklll
	defb 06ch,06ch,06ch,06ch,06ch,06ch,09eh,09eh,09eh,09eh,09eh,09eh,09eh,09eh,09eh,090h	; 4a6b  llllll..........
	defb 09ch,09bh,010h,010h,010h,010h,010h,010h,06dh,06eh,06fh,0bah,070h,070h,070h,070h	; 4a7b  ........mno.pppp
	defb 070h,070h,070h,070h,070h,070h,070h,070h,0bbh,0a2h,09fh,098h,010h,010h,010h,010h	; 4a8b  pppppppp........
	defb 010h,010h,010h,010h,071h,0b8h,073h,078h,079h,079h,07ah,07bh,079h,0a7h,083h,079h	; 4a9b  ....q.sxyyz{y..y
	defb 07ah,07bh,079h,079h,0a6h,0a3h,0a0h,099h,010h,010h,010h,010h,010h,010h,010h,010h	; 4aab  z{yy............
	defb 071h,0b8h,073h,078h,079h,079h,07ch,07dh,079h,0a7h,083h,079h,07ch,07dh,079h,079h	; 4abb  q.sxyy|}y..y|}yy
	defb 0a6h,0a3h,0a0h,099h,010h,010h,010h,010h,010h,010h,010h,010h,071h,0b8h,073h,077h	; 4acb  ............q.sw
	defb 07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,0a5h,0a3h,0a0h,099h	; 4adb  ~~~~~~~~~~~~....
	defb 010h,010h,010h,010h,010h,010h,010h,010h,075h,0b9h,074h,07fh,07fh,07fh,07fh,07fh	; 4aeb  ........u.t.....
	defb 07fh,07fh,07fh,07fh,07fh,07fh,07fh,07fh,07fh,0a4h,0a1h,09ah,010h,010h,010h,010h	; 4afb  ................
	defb 020h,005h,052h,053h,054h,052h,053h,054h,052h,053h,054h,052h,053h,054h,052h,053h	; 4b0b   .RSTRSTRSTRSTRS
	defb 054h,052h,053h,054h,052h,053h,054h,052h,053h,054h,052h,053h,054h,052h,053h,054h	; 4b1b  TRSTRSTRSTRSTRST
	defb 052h,053h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h	; 4b2b  RS..............
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h	; 4b3b  ................
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h	; 4b4b  ................
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h	; 4b5b  ................
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h	; 4b6b  ................
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h	; 4b7b  ................
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h	; 4b8b  ................
	defb 081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h,081h	; 4b9b  ................
	defb 081h,081h,07fh,000h,07fh,06fh,000h,0efh,000h,0bfh,000h,06fh,000h,02fh,000h,03fh	; 4bab  .....o.....o./.?
	defb 000h,07fh,000h,03fh,000h,0c9h,02fh,000h,06fh,000h,06fh,000h,06bh,000h,0efh,000h	; 4bbb  ...?../.o.o.k...
	defb 02fh,000h,0efh,000h,0afh,0cbh,001h,06fh,000h,06fh,000h,0efh,000h,0efh,000h,0afh	; 4bcb  /......o.o......
	defb 000h,0afh,000h,06bh,000h,000h,0afh,000h,03bh,000h,0efh,000h,02bh,000h,06fh,000h	; 4bdb  ...k....;...+.o.
	defb 02fh,000h,06fh,000h,06fh,06fh,000h,0bfh,000h,06bh,000h,06fh,000h,02fh,000h,0ebh	; 4beb  /.o.oo...k.o./..
	defb 000h,06fh,000h,0efh,000h,041h,0ffh,010h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; 4bfb  .o...A..........
	defb 0ffh,010h,0ffh,000h,0ffh,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh	; 4c0b  ................
	defb 000h,0ffh,000h,0ffh,010h,000h,0ffh,000h,0ffh,014h,0ffh,000h,0ffh,000h,0ffh,000h	; 4c1b  ................
	defb 0efh,000h,0ffh,010h,0ffh,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh	; 4c2b  ................
	defb 000h,0ffh,000h,0ffh,000h,0a1h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; 4c3b  ................
	defb 0ffh,004h,0ffh,000h,0ffh,0ffh,000h,0ffh,048h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 4c4b  ........H.......
	defb 000h,0ffh,000h,0ffh,000h,000h,0ffh,010h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,010h	; 4c5b  ................
	defb 0ffh,010h,0ffh,000h,0ffh,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh	; 4c6b  ................
	defb 000h,0ffh,000h,0ffh,000h,08ch,06fh,000h,02fh,000h,03fh,000h,06bh,000h,06fh,000h	; 4c7b  ......o./.?.k.o.
	defb 0afh,000h,07fh,000h,0efh,0e3h,000h,0afh,00ch,06fh,000h,07fh,000h,0efh,000h,0efh	; 4c8b  .........o......
	defb 000h,06fh,000h,06fh,000h,000h,02fh,000h,02fh,000h,06fh,000h,02fh,000h,02fh,000h	; 4c9b  .o.o.././.o././.
	defb 02fh,000h,0afh,000h,0afh,02fh,000h,03fh,000h,06fh,000h,03fh,000h,0efh,000h,02fh	; 4cab  /..../.?.o.?.../
	defb 000h,0efh,000h,06fh,000h,0a2h,06fh,000h,02fh,000h,06fh,000h,02fh,000h,06fh,000h	; 4cbb  ...o..o./.o./.o.
	defb 0efh,000h,02fh,000h,02fh,066h,000h,06fh,002h,06fh,000h,0afh,000h,02bh,000h,06fh	; 4ccb  .././f.o.o...+.o
	defb 000h,06fh,000h,07fh,000h,000h,0afh,000h,06fh,000h,0efh,000h,0afh,000h,0efh,000h	; 4cdb  .o......o.......
	defb 02fh,000h,06fh,000h,02bh,0efh,000h,06bh,000h,03fh,000h,06fh,000h,06bh,000h,06fh	; 4ceb  /.o.+..k.?.o.k.o
	defb 000h,06fh,000h,0efh,000h,06dh,0ffh,010h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,000h	; 4cfb  .o...m..........
	defb 0ffh,010h,0ffh,000h,0ffh,0ffh,000h,0ffh,050h,0ffh,010h,0ffh,000h,0ffh,000h,0ffh	; 4d0b  ........P.......
	defb 010h,0ffh,010h,0ffh,000h,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; 4d1b  ................
	defb 0ffh,010h,0ffh,010h,0ffh,0ffh,000h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,000h,0ffh	; 4d2b  ................
	defb 000h,0ffh,010h,0ffh,000h,00dh,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,010h,0ffh,010h	; 4d3b  ................
	defb 0efh,010h,0ffh,010h,0ffh,0ffh,083h,0ffh,084h,0efh,000h,0ffh,010h,0ffh,014h,0efh	; 4d4b  ................
	defb 000h,0ffh,000h,0ffh,000h,010h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh,090h,0ffh,000h	; 4d5b  ................
	defb 0ffh,000h,0ffh,010h,0ffh,0ffh,010h,0ffh,001h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh	; 4d6b  ................
	defb 010h,0ffh,000h,0ffh,010h,0a1h,0efh,000h,06bh,000h,06fh,000h,00fh,000h,06fh,000h	; 4d7b  ........k.o...o.
	defb 03fh,000h,06fh,000h,06fh,0ffh,004h,06fh,000h,0efh,000h,02fh,000h,06fh,000h,06fh	; 4d8b  ?.o.o..o.../.o.o
	defb 000h,06fh,000h,02fh,000h,000h,06fh,000h,0afh,000h,0afh,000h,06bh,000h,0efh,000h	; 4d9b  .o./..o.....k...
	defb 02fh,000h,07fh,000h,03fh,06fh,000h,0efh,000h,0efh,000h,03fh,000h,0afh,000h,02fh	; 4dab  /...?o.....?.../
	defb 000h,07fh,000h,0afh,000h,019h,0afh,000h,0afh,000h,0efh,000h,03fh,000h,06fh,000h	; 4dbb  ............?.o.
	defb 06fh,000h,02fh,000h,06fh,0c7h,000h,02fh,000h,06fh,000h,06fh,000h,06fh,000h,06fh	; 4dcb  o./.o../.o.o.o.o
	defb 000h,0efh,000h,07fh,000h,000h,0ffh,000h,06fh,000h,06fh,000h,02fh,000h,06fh,000h	; 4ddb  ........o.o./.o.
	defb 06fh,000h,0afh,000h,0abh,0efh,000h,06fh,000h,0efh,000h,02fh,000h,0afh,000h,0efh	; 4deb  o......o.../....
	defb 000h,0efh,000h,0efh,000h,079h,0ffh,010h,0ffh,010h,0ffh,010h,0efh,000h,0ffh,010h	; 4dfb  .....y..........
	defb 0ffh,000h,0ffh,010h,0ffh,0ffh,004h,0ffh,070h,0ffh,010h,0ffh,000h,0ffh,000h,0ffh	; 4e0b  ........p.......
	defb 010h,0ffh,000h,0ffh,010h,000h,0ffh,010h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,010h	; 4e1b  ................
	defb 0ffh,080h,0ffh,000h,0ffh,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,010h,0ffh,000h,0ffh	; 4e2b  ................
	defb 000h,0ffh,000h,0ffh,010h,0f8h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,000h	; 4e3b  ................
	defb 0ffh,000h,0ffh,004h,0ffh,0ffh,000h,0ffh,015h,0ffh,010h,0ffh,010h,0ffh,000h,0ffh	; 4e4b  ................
	defb 000h,0ffh,000h,0ffh,000h,010h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,010h,0ffh,010h	; 4e5b  ................
	defb 0ffh,010h,0ffh,014h,0ffh,0ffh,010h,0ffh,090h,0ffh,010h,0ffh,010h,0efh,000h,0ffh	; 4e6b  ................
	defb 010h,0ffh,010h,0ffh,010h,084h,06fh,000h,07fh,000h,0afh,000h,0efh,000h,02fh,000h	; 4e7b  ......o......./.
	defb 06fh,000h,0ffh,000h,02fh,0b7h,000h,06fh,000h,0ffh,000h,0efh,000h,07fh,000h,07fh	; 4e8b  o.../..o........
	defb 000h,07fh,000h,06fh,000h,000h,02fh,000h,0efh,000h,06fh,000h,02bh,000h,06fh,000h	; 4e9b  ...o../...o.+.o.
	defb 06fh,000h,0efh,000h,02fh,07fh,000h,06fh,000h,07fh,000h,0ffh,000h,06fh,000h,0efh	; 4eab  o.../..o.....o..
	defb 000h,0efh,000h,07fh,000h,082h,06fh,000h,02fh,000h,06fh,000h,02bh,000h,02fh,000h	; 4ebb  ......o./.o.+./.
	defb 02fh,000h,0efh,000h,0afh,0f7h,000h,07bh,088h,02fh,000h,0efh,000h,0ffh,000h,06fh	; 4ecb  /......{./.....o
	defb 000h,07fh,000h,06fh,000h,000h,06fh,000h,0ebh,000h,03bh,000h,06fh,000h,04bh,000h	; 4edb  ...o..o...;.o.K.
	defb 06fh,000h,06fh,000h,02fh,0efh,000h,06fh,000h,08fh,000h,02fh,000h,0bfh,000h,06fh	; 4eeb  o.o./..o.../...o
	defb 000h,06fh,000h,03fh,000h,039h,0ffh,010h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,000h	; 4efb  .o.?.9..........
	defb 0ffh,000h,0ffh,000h,0ffh,07fh,038h,0ffh,078h,0ffh,010h,0ffh,000h,0ffh,000h,0ffh	; 4f0b  ......8.x.......
	defb 000h,0ffh,000h,0ffh,004h,010h,0ffh,090h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,010h	; 4f1b  ................
	defb 0ffh,010h,0ffh,000h,0ffh,0ffh,010h,0ffh,010h,0ffh,010h,0ffh,010h,0ffh,000h,0ffh	; 4f2b  ................
	defb 010h,0ffh,000h,0ffh,000h,0ech,0ffh,010h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,004h	; 4f3b  ................
	defb 0ffh,000h,0ffh,000h,0ffh,0fbh,008h,0ffh,010h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 4f4b  ................
	defb 010h,0ffh,000h,0ffh,000h,010h,0ffh,010h,0efh,000h,0ffh,010h,0ffh,000h,0ffh,010h	; 4f5b  ................
	defb 0ffh,000h,0ffh,010h,0ffh,0ffh,010h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,000h,0ffh	; 4f6b  ................
	defb 000h,0ffh,010h,0ffh,010h,045h,06fh,000h,02fh,000h,06fh,000h,06fh,000h,02fh,000h	; 4f7b  .....Eo./.o.o./.
	defb 06fh,000h,02bh,000h,0afh,017h,040h,0efh,020h,06fh,000h,06fh,000h,06fh,000h,06fh	; 4f8b  o.+...@. o.o.o.o
	defb 000h,0efh,000h,06bh,000h,000h,06fh,000h,0afh,000h,06fh,000h,02fh,000h,07fh,000h	; 4f9b  ...k..o...o./...
	defb 06fh,000h,0efh,000h,0efh,0bfh,000h,06fh,000h,0efh,000h,0efh,000h,0efh,000h,02fh	; 4fab  o......o......./
	defb 000h,06fh,000h,0efh,000h,011h,06fh,000h,07fh,000h,0afh,000h,02fh,000h,02fh,000h	; 4fbb  .o....o....././.
	defb 02fh,000h,06fh,000h,03fh,06fh,040h,07fh,001h,0efh,000h,02fh,000h,06fh,000h,02fh	; 4fcb  /.o.?o@..../.o./
	defb 000h,07fh,000h,06fh,000h,000h,06fh,000h,02fh,000h,0efh,000h,02bh,000h,0efh,000h	; 4fdb  ...o..o./...+...
	defb 02bh,000h,06fh,000h,0efh,06fh,000h,02fh,001h,0efh,000h,02fh,000h,0efh,000h,06fh	; 4feb  +.o..o./.../...o
	defb 000h,0ffh,000h,06fh,000h	; 4ffb

; ----------------------------------------------------------------------
; DATOS dibujos_casillas: Los dibujos: las letras (0x5000, 0x180 bytes), los
;   otros dibujos de los sprites (0x5400), los de siempre (0x5800, 0x800), las
;   casillas del titulo (0x6000, 0x6800) y sus colores (0x7000, 0x7800), las
;   de las fases (0x6180) y sus colores (0x7180), las de la fase 6 (0x6980) y
;   sus colores (0x7980), y la lista de mandos de la demostracion (0x7F00:
;   toda 0xF0, los dos botones y sin palanca); 0x5180-0x53FF, 0x5580-0x57FF,
;   0x6D00-0x6FFF y 0x7D00-0x7EFF no los lee ninguna copia
;   0x5000..0x8000  (12288 bytes)
DATA_dibujos_casillas:
	defb 000h,01eh,023h,027h,02bh,033h,023h,01eh,000h,00ch,01ch,00ch,00ch,00ch,00ch,01eh	; 5000  ..#'+3#.........
	defb 000h,01eh,023h,023h,006h,008h,010h,03fh,000h,01eh,023h,003h,01eh,003h,023h,01eh	; 5010  ..##...?..#...#.
	defb 000h,006h,00eh,016h,026h,026h,03fh,006h,000h,03fh,020h,020h,03eh,003h,023h,01eh	; 5020  ....&&?..?  >.#.
	defb 000h,01eh,031h,030h,03eh,031h,031h,01eh,000h,03fh,023h,023h,006h,00ch,00ch,00ch	; 5030  ..10>11..?##....
	defb 000h,01eh,023h,023h,01eh,023h,023h,01eh,000h,01eh,023h,023h,01fh,003h,023h,01eh	; 5040  ..##.##...##..#.
	defb 000h,000h,00ch,00ch,000h,00ch,00ch,000h,000h,000h,000h,000h,000h,000h,018h,018h	; 5050  ................
	defb 000h,003h,006h,00ch,018h,00ch,006h,003h,000h,000h,03fh,03fh,000h,03fh,03fh,000h	; 5060  ..........??.??.
	defb 000h,018h,00ch,006h,003h,006h,00ch,018h,000h,01eh,023h,003h,00eh,00ch,000h,00ch	; 5070  ..........#.....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,01eh,023h,023h,023h,03fh,023h,023h	; 5080  ..........###?##
	defb 000h,03eh,031h,031h,03eh,031h,031h,03eh,000h,01eh,031h,030h,030h,030h,031h,01eh	; 5090  .>11>11>..10001.
	defb 000h,03eh,031h,031h,031h,031h,031h,03eh,000h,03fh,030h,030h,03eh,030h,030h,03fh	; 50a0  .>11111>.?00>00?
	defb 000h,03fh,030h,030h,03fh,030h,030h,030h,000h,01eh,031h,030h,030h,037h,031h,01eh	; 50b0  .?00?000..10071.
	defb 000h,023h,023h,023h,03fh,023h,023h,023h,000h,01eh,00ch,00ch,00ch,00ch,00ch,01eh	; 50c0  .###?###........
	defb 000h,03fh,006h,006h,006h,026h,026h,01ch,000h,031h,033h,036h,03ch,03ah,032h,033h	; 50d0  .?...&&..136<:23
	defb 000h,030h,030h,030h,030h,030h,030h,03fh,000h,023h,037h,02bh,023h,023h,023h,023h	; 50e0  .000000?.#7+####
	defb 000h,031h,031h,039h,035h,033h,031h,031h,000h,01eh,023h,023h,023h,023h,023h,01eh	; 50f0  .1195311..#####.
	defb 000h,01eh,031h,031h,031h,03eh,030h,030h,000h,01eh,023h,023h,023h,02bh,027h,01eh	; 5100  ..111>00..###+'.
	defb 000h,01eh,031h,031h,03eh,038h,036h,031h,000h,01eh,031h,030h,01eh,003h,023h,01eh	; 5110  ..11>861..10..#.
	defb 000h,03fh,00ch,00ch,00ch,00ch,00ch,00ch,000h,023h,023h,023h,023h,023h,023h,01eh	; 5120  .?.......######.
	defb 000h,023h,023h,023h,023h,023h,012h,00ch,000h,023h,023h,023h,023h,02bh,02bh,016h	; 5130  .#####...####++.
	defb 000h,039h,03ah,01ch,00ch,00eh,017h,027h,000h,023h,023h,023h,01eh,00ch,00ch,00ch	; 5140  .9:....'.###....
	defb 000h,03fh,033h,007h,00ch,018h,033h,03fh,000h,01eh,023h,027h,02bh,033h,023h,01eh	; 5150  .?3...3?..#'+3#.
	defb 000h,00ch,01ch,00ch,00ch,00ch,00ch,01eh,000h,01eh,023h,023h,006h,008h,010h,03fh	; 5160  ..........##...?
	defb 000h,01eh,023h,003h,01eh,003h,023h,01eh,000h,006h,00eh,016h,026h,026h,03fh,006h	; 5170  ..#...#.....&&?.
	defb 000h,03fh,020h,020h,03eh,003h,023h,01eh,000h,01eh,031h,030h,03eh,031h,031h,01eh	; 5180  .?  >.#...10>11.
	defb 000h,03fh,023h,023h,006h,00ch,00ch,00ch,000h,01eh,023h,023h,01eh,023h,023h,01eh	; 5190  .?##......##.##.
	defb 000h,01eh,023h,023h,01fh,003h,023h,01eh,081h,0c3h,0ffh,0bdh,0e7h,0bdh,081h,0ffh	; 51a0  ..##..#.........
	defb 0ffh,081h,0bdh,0e7h,0bdh,0ffh,0c3h,081h,0ffh,069h,03dh,035h,035h,03dh,069h,0ffh	; 51b0  .........i=55=i.
	defb 0ffh,096h,0bch,0ach,0ach,0bch,096h,0ffh,001h,00fh,039h,021h,061h,041h,041h,0ffh	; 51c0  ..........9!aAA.
	defb 080h,0f0h,09ch,084h,086h,082h,082h,0ffh,0ffh,041h,041h,061h,021h,039h,00fh,001h	; 51d0  .........AAa!9..
	defb 0ffh,082h,082h,086h,084h,09ch,0f0h,080h,000h,000h,000h,000h,000h,000h,000h,000h	; 51e0  ................
	defb 000h,011h,011h,015h,055h,055h,055h,0ffh,000h,000h,000h,000h,000h,000h,000h,000h	; 51f0  ....UUU.........
	defb 010h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,014h,0ffh	; 5200  ................
	defb 0ffh,000h,0ffh,010h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,014h,0ffh,000h,0ffh,000h	; 5210  ................
	defb 000h,0ffh,010h,0ffh,004h,0ffh,080h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,000h,0ffh	; 5220  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,000h,0ffh,010h	; 5230  ................
	defb 010h,0ffh,000h,0ffh,000h,0ffh,014h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,020h,0ffh	; 5240  .............. .
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,000h,0ffh,000h,0ffh,010h	; 5250  ................
	defb 010h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,010h,0ffh	; 5260  ................
	defb 0ffh,010h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,000h	; 5270  ................
	defb 000h,0afh,000h,0afh,000h,0efh,000h,06fh,000h,02fh,000h,06fh,000h,06fh,000h,02fh	; 5280  .......o./.o.o./
	defb 06fh,000h,07fh,000h,02fh,000h,06fh,000h,02fh,000h,02bh,000h,0ffh,000h,06fh,000h	; 5290  o.../.o./.+...o.
	defb 000h,02fh,000h,02bh,000h,06fh,000h,07fh,000h,0afh,000h,06fh,000h,02fh,000h,02bh	; 52a0  ./.+.o.....o./.+
	defb 06fh,000h,06fh,000h,0efh,000h,07fh,000h,03bh,000h,02bh,000h,06fh,000h,02fh,000h	; 52b0  o.o.....;.+.o./.
	defb 000h,02fh,000h,02bh,000h,07fh,000h,03fh,000h,0efh,000h,0afh,000h,0afh,000h,02fh	; 52c0  ./.+...?......./
	defb 02fh,000h,06fh,000h,06fh,000h,02fh,000h,06fh,000h,0efh,000h,0efh,000h,06fh,000h	; 52d0  /.o.o./.o.....o.
	defb 000h,0ebh,000h,02bh,000h,06fh,000h,0afh,000h,0ffh,000h,02fh,000h,02fh,000h,06fh	; 52e0  ...+.o....././.o
	defb 0efh,000h,06fh,000h,06fh,000h,06fh,000h,06fh,000h,06fh,000h,0bfh,000h,06fh,000h	; 52f0  ..o.o.o.o.o...o.
	defb 000h,0ffh,010h,0ffh,000h,0ffh,014h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,010h,0ffh	; 5300  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,004h,0ffh,000h,0ffh,010h	; 5310  ................
	defb 010h,0ffh,080h,0ffh,000h,0ffh,010h,0ffh,090h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh	; 5320  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,010h,0ffh,000h,0ffh,010h	; 5330  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,010h,0ffh	; 5340  ................
	defb 0ffh,010h,0ffh,000h,0ffh,000h,0ffh,014h,0ffh,010h,0ffh,010h,0ffh,000h,0ffh,010h	; 5350  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh,014h,0ffh,010h,0ffh,000h,0ffh	; 5360  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh,010h,0ffh,010h,0ffh,010h,0ffh,010h	; 5370  ................
	defb 000h,0efh,000h,06fh,000h,07fh,000h,06fh,000h,0efh,000h,06fh,000h,0afh,000h,02fh	; 5380  ...o...o...o.../
	defb 06fh,000h,0efh,000h,0efh,000h,02fh,000h,0efh,000h,03fh,000h,06fh,000h,06fh,000h	; 5390  o...../...?.o.o.
	defb 000h,0efh,000h,02fh,000h,0efh,000h,06fh,000h,06fh,000h,007h,000h,0bfh,000h,06fh	; 53a0  .../...o.o.....o
	defb 06fh,000h,06fh,000h,0ffh,000h,06fh,000h,06fh,000h,00fh,000h,06fh,000h,02fh,000h	; 53b0  o.o...o.o...o./.
	defb 000h,0bfh,000h,06fh,000h,06fh,000h,02fh,000h,05fh,000h,0abh,000h,02fh,000h,06bh	; 53c0  ...o.o./._.../.k
	defb 06fh,000h,06fh,000h,07fh,000h,06fh,000h,02fh,000h,06fh,000h,03fh,000h,0afh,000h	; 53d0  o.o...o./.o.?...
	defb 000h,02fh,000h,06bh,000h,0bfh,000h,02bh,000h,06fh,000h,0afh,000h,02fh,000h,0efh	; 53e0  ./.k...+.o.../..
	defb 06fh,000h,06fh,000h,06fh,000h,06bh,000h,0efh,000h,0ebh,000h,0efh,000h,02fh,000h	; 53f0  o.o.o.k......./.
	defb 0ffh,0ffh,055h,06ah,055h,06ah,055h,07fh,040h,040h,051h,051h,055h,04ah,040h,040h	; 5400  ..UjUjU.@@QQUJ@@
	defb 0ffh,0ffh,056h,0aah,056h,0aah,056h,0feh,002h,002h,07ah,042h,042h,07ah,002h,002h	; 5410  ..V.V.V...zBBz..
	defb 05ch,054h,05ch,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,0ffh,0ffh	; 5420  \T\@@@@@@@@@@@..
	defb 002h,002h,002h,002h,002h,002h,002h,002h,002h,002h,002h,002h,002h,002h,0ffh,0ffh	; 5430  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,03fh,03fh,02ah,02ah,02ah,035h,03fh,03fh	; 5440  ........??***5??
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0fch,0fch,084h,0bch,0bch,084h,0fch,0fch	; 5450  ................
	defb 023h,023h,023h,03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,000h,000h	; 5460  ###???????????..
	defb 0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,000h,000h	; 5470  ................
	defb 0ffh,0ffh,055h,06ah,055h,06ah,055h,07fh,040h,040h,040h,040h,040h,040h,040h,040h	; 5480  ..UjUjU.@@@@@@@@
	defb 0ffh,0ffh,056h,0aah,056h,0aah,056h,0feh,003h,003h,003h,003h,003h,003h,003h,003h	; 5490  ..V.V.V.........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0e0h,0fch,0fch,0fch,0fch,0fch,0fch,0fch	; 54a0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 54b0  ................
	defb 047h,045h,047h,040h,040h,048h,05bh,05ah,058h,058h,05ch,043h,040h,040h,0ffh,0ffh	; 54c0  GEG@@H[ZXX\C@@..
	defb 0e3h,063h,0e3h,003h,003h,003h,003h,003h,003h,003h,00bh,003h,003h,003h,0ffh,0ffh	; 54d0  .c..............
	defb 0fch,0ech,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,01ch,000h	; 54e0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 54f0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,003h,007h	; 5500  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0e0h,0f0h,0f8h	; 5510  ................
	defb 000h,000h,000h,007h,003h,001h,000h,001h,001h,000h,001h,000h,000h,000h,000h,000h	; 5520  ................
	defb 018h,018h,018h,0f8h,0e0h,0f0h,0f0h,0f8h,078h,0f8h,0f0h,0c0h,000h,000h,000h,000h	; 5530  ........x.......
	defb 004h,002h,003h,001h,003h,004h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5540  ................
	defb 020h,0c0h,080h,0c0h,040h,020h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5550   ...@ ..........
	defb 000h,002h,00fh,01eh,037h,078h,0b7h,06eh,0deh,073h,03ch,037h,01dh,00fh,002h,000h	; 5560  ....7x.n.s<7....
	defb 000h,0e0h,0f0h,0d8h,0eeh,01ch,0e6h,03bh,03dh,0e6h,01eh,0ech,0b8h,0f0h,0c0h,000h	; 5570  .......;=.......
	defb 000h,000h,020h,000h,000h,004h,000h,040h,000h,000h,000h,004h,000h,040h,000h,000h	; 5580  .. ....@.....@..
	defb 000h,040h,000h,000h,004h,000h,000h,000h,080h,010h,000h,001h,000h,040h,004h,000h	; 5590  .@...........@..
	defb 000h,000h,001h,001h,000h,010h,000h,000h,005h,000h,020h,001h,000h,000h,004h,000h	; 55a0  .......... .....
	defb 000h,000h,000h,022h,000h,000h,000h,010h,000h,042h,000h,000h,020h,004h,000h,020h	; 55b0  ...".....B.. .. 
	defb 01ch,033h,039h,01fh,00dh,007h,01fh,07bh,07eh,0ffh,0ddh,0eah,07dh,02fh,057h,0aah	; 55c0  .39....{~...}/W.
	defb 038h,0cch,09ch,0f8h,0b0h,0e0h,0f8h,0eeh,0beh,0ffh,0bbh,057h,0beh,0f4h,0eah,055h	; 55d0  8..........W...U
	defb 000h,00ch,006h,000h,000h,008h,020h,004h,081h,010h,00ah,004h,006h,010h,028h,07ch	; 55e0  ...... .......(|
	defb 000h,030h,060h,000h,000h,010h,004h,010h,041h,008h,050h,020h,060h,008h,014h,03eh	; 55f0  .0`.....A.P `..>
	defb 0cbh,03fh,0cbh,03fh,0cbh,03fh,0a7h,0c8h,0c3h,0b5h,094h,000h,000h,000h,000h,000h	; 5600  .?.?.?..........
	defb 01fh,03fh,07fh,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,07fh,07fh,03fh,03fh,01fh,007h	; 5610  .?..........??..
	defb 0f0h,0fch,0feh,0ffh,0ffh,0ffh,0fch,0fch,0fch,0fch,0feh,0feh,0feh,0fch,0f8h,0fch	; 5620  ................
	defb 000h,000h,000h,000h,080h,082h,082h,002h,007h,007h,00eh,00ch,018h,038h,070h,0e0h	; 5630  .............8p.
	defb 000h,03fh,07fh,006h,00eh,00ch,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5640  .?..............
	defb 000h,001h,0f3h,0ffh,03fh,00fh,00fh,00fh,007h,007h,00fh,00fh,01fh,000h,000h,001h	; 5650  ....?...........
	defb 07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,03ch,0feh,0feh	; 5660  .............<..
	defb 0c0h,0c0h,080h,080h,080h,0c0h,0c0h,0e0h,0f0h,0f0h,0f8h,0f8h,0f0h,000h,000h,000h	; 5670  ................
	defb 000h,000h,000h,001h,001h,003h,003h,003h,003h,003h,003h,003h,001h,001h,000h,000h	; 5680  ................
	defb 03fh,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,03fh	; 5690  ?..............?
	defb 000h,0c0h,0f0h,0f8h,0fch,0f2h,0f0h,0f0h,0e0h,0e0h,0e0h,0e0h,0c0h,0fdh,0ffh,0ffh	; 56a0  ................
	defb 000h,080h,040h,020h,0a0h,0e0h,060h,070h,030h,038h,038h,070h,0f0h,0e0h,0e0h,0e0h	; 56b0  ..@ ..`p088p....
	defb 000h,000h,000h,000h,000h,041h,0ffh,00fh,01eh,038h,000h,000h,000h,000h,001h,001h	; 56c0  .....A...8......
	defb 001h,001h,007h,01fh,07fh,0ffh,0efh,00fh,00fh,00fh,00fh,00fh,01fh,0ffh,0fch,07ch	; 56d0  ...............|
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,080h,000h,001h,003h	; 56e0  ................
	defb 0c0h,0c0h,0e0h,0e0h,0e0h,0e0h,0f0h,0f0h,0f8h,0f8h,0f8h,0f8h,0f0h,078h,0f8h,0f8h	; 56f0  .............x..
	defb 0cbh,03fh,0cbh,03fh,0cbh,03fh,0a7h,0c8h,0c3h,0cdh,094h,03fh,01fh,015h,015h,015h	; 5700  .?.?.?.....?....
	defb 0e0h,0f0h,0f8h,0f8h,03ch,01eh,00eh,01eh,03ch,0fch,0fch,0f8h,0f8h,058h,050h,070h	; 5710  ....<...<....XPp
	defb 008h,008h,010h,037h,03fh,077h,073h,0bbh,03fh,03fh,03fh,038h,030h,015h,010h,008h	; 5720  ...7?ws.???80...
	defb 008h,008h,010h,0d0h,0fch,0deh,09fh,03bh,0f9h,0f8h,0f8h,078h,030h,030h,030h,0e0h	; 5730  .......;...x000.
	defb 006h,004h,00ch,01fh,013h,09bh,0c0h,0ffh,078h,003h,01fh,010h,018h,00ch,00fh,007h	; 5740  ........x.......
	defb 070h,038h,07ch,0ech,08eh,03eh,0feh,07eh,0f6h,0ech,09ch,03ch,078h,0f8h,0f0h,0e0h	; 5750  p8|..>.~...<x...
	defb 000h,000h,000h,000h,000h,000h,000h,000h,007h,007h,00fh,00fh,01fh,000h,000h,001h	; 5760  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,03ch,0feh,0feh,0f0h,0f0h,0f8h,0f8h,0f0h,000h,000h,000h	; 5770  .....<..........
	defb 000h,000h,000h,001h,001h,003h,003h,003h,03fh,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 5780  ........?.......
	defb 000h,0c0h,0f0h,0f8h,0fch,0f2h,0f0h,0f0h,000h,080h,040h,020h,0a0h,0e0h,060h,070h	; 5790  ..........@ ..`p
	defb 003h,003h,003h,003h,001h,001h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,03fh	; 57a0  ...............?
	defb 0e0h,0e0h,0e0h,0e0h,0c0h,0fdh,0ffh,0ffh,030h,038h,038h,070h,0f0h,0e0h,0e0h,0e0h	; 57b0  ........088p....
	defb 000h,000h,000h,000h,000h,041h,0ffh,00fh,001h,001h,007h,01fh,07fh,0ffh,0efh,00fh	; 57c0  .....A..........
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0c0h,0c0h,0e0h,0e0h,0e0h,0e0h,0f0h,0f0h	; 57d0  ................
	defb 01eh,038h,000h,000h,000h,000h,001h,001h,00fh,00fh,00fh,00fh,01fh,0ffh,0fch,07ch	; 57e0  .8.............|
	defb 0ffh,0ffh,0ffh,0ffh,080h,000h,001h,003h,0f8h,0f8h,0f8h,0f8h,0f0h,078h,0f8h,0f8h	; 57f0  .............x..
	defb 007h,00fh,01fh,01fh,001h,001h,001h,01fh,03ah,03dh,03fh,00fh,00fh,01ch,03ch,000h	; 5800  ........:=?...<.
	defb 000h,080h,0c0h,0c0h,0e0h,0e0h,0e0h,0c0h,0f0h,0f0h,0e0h,0e0h,0f8h,078h,000h,000h	; 5810  .............x..
	defb 000h,000h,000h,000h,01eh,00ah,01eh,000h,000h,0c0h,0c0h,000h,000h,000h,000h,078h	; 5820  ...............x
	defb 000h,000h,000h,000h,000h,000h,000h,000h,00eh,00ch,000h,000h,000h,000h,018h,030h	; 5830  ...............0
	defb 003h,007h,00fh,000h,000h,000h,00fh,01ah,01dh,01fh,00fh,00fh,00fh,00eh,00eh,000h	; 5840  ................
	defb 080h,0c0h,0e0h,0f0h,0f0h,0e0h,0e0h,0c0h,0f0h,0f8h,0f8h,0e8h,0e0h,0e0h,0e0h,000h	; 5850  ................
	defb 000h,000h,000h,00fh,005h,00fh,000h,060h,060h,000h,000h,000h,000h,000h,000h,006h	; 5860  .......``.......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,004h,006h,000h,000h,000h,0c0h	; 5870  ................
	defb 000h,000h,000h,001h,000h,000h,000h,01fh,01fh,00fh,003h,01fh,01fh,01fh,000h,000h	; 5880  ................
	defb 000h,070h,0f8h,0fch,01eh,01eh,01eh,0f3h,0f3h,05bh,0bdh,0feh,0feh,01eh,01eh,01ch	; 5890  .p.......[......
	defb 000h,000h,000h,000h,001h,000h,001h,060h,020h,000h,000h,0e0h,060h,000h,000h,000h	; 58a0  .......` ...`...
	defb 000h,000h,000h,000h,0e0h,0a0h,0e0h,00ch,00ch,004h,000h,000h,000h,0e0h,060h,000h	; 58b0  ..............`.
	defb 000h,001h,003h,007h,000h,000h,038h,03fh,03dh,007h,007h,01fh,07fh,01eh,018h,000h	; 58c0  ......8?=.......
	defb 000h,0c0h,0e0h,0f0h,070h,070h,07ch,0fch,07ch,0f0h,0f0h,0fch,0ffh,038h,018h,000h	; 58d0  ....pp|.|....8..
	defb 000h,000h,000h,000h,007h,002h,0c7h,0c0h,040h,000h,000h,000h,000h,0e0h,060h,000h	; 58e0  ........@.....`.
	defb 000h,000h,000h,000h,080h,080h,083h,003h,002h,000h,000h,000h,000h,007h,006h,000h	; 58f0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,00eh,01fh,03fh,003h,003h,003h,03eh	; 5900  ...........?...>
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,010h,0b8h,0fch,0fch,03eh,03eh	; 5910  ..............>>
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,03ch,03ch,054h,0c1h	; 5920  ............<<T.
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0c1h,0c1h	; 5930  ................
	defb 000h,001h,003h,003h,007h,007h,007h,003h,00fh,00fh,007h,007h,01fh,01eh,000h,000h	; 5940  ................
	defb 0e0h,0f0h,0f8h,0f8h,080h,080h,080h,0f8h,05ch,0bch,0fch,0f0h,0f0h,038h,03ch,000h	; 5950  ........\....8<.
	defb 000h,000h,000h,000h,000h,000h,000h,000h,070h,030h,000h,000h,000h,000h,018h,00ch	; 5960  ........p0......
	defb 000h,000h,000h,000h,078h,050h,078h,000h,000h,003h,003h,000h,000h,000h,000h,01eh	; 5970  ....xPx.........
	defb 001h,003h,007h,00fh,00fh,007h,007h,003h,00fh,01fh,01fh,017h,007h,007h,007h,000h	; 5980  ................
	defb 0c0h,0e0h,0f0h,000h,000h,000h,0f0h,058h,0b8h,0f8h,0f0h,0f0h,0f0h,070h,070h,000h	; 5990  .......X.....pp.
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,060h,000h,000h,000h,003h	; 59a0  .......... `....
	defb 000h,000h,000h,0f0h,0a0h,0f0h,000h,006h,006h,000h,000h,000h,000h,000h,000h,060h	; 59b0  ...............`
	defb 000h,00eh,01fh,03fh,078h,078h,078h,0cfh,0cfh,0dah,0bdh,07fh,07fh,078h,078h,038h	; 59c0  ...?xxx......xx8
	defb 000h,000h,000h,080h,000h,000h,000h,0f8h,0f8h,0f0h,0c0h,0f8h,0f8h,0f8h,000h,000h	; 59d0  ................
	defb 000h,000h,000h,000h,007h,005h,007h,030h,030h,020h,000h,000h,000h,007h,006h,000h	; 59e0  .......00 ......
	defb 000h,000h,000h,000h,080h,000h,080h,006h,004h,000h,000h,007h,006h,000h,000h,000h	; 59f0  ................
	defb 000h,003h,007h,00fh,00eh,00eh,03eh,03fh,03eh,00fh,00fh,03fh,0ffh,01ch,018h,000h	; 5a00  ......>?>..?....
	defb 000h,080h,0c0h,0e0h,000h,000h,01ch,0fch,0bch,0e0h,0e0h,0f8h,0feh,078h,018h,000h	; 5a10  .............x..
	defb 000h,000h,000h,000h,001h,001h,0c1h,0c0h,040h,000h,000h,000h,000h,0e0h,060h,000h	; 5a20  ........@.....`.
	defb 000h,000h,000h,000h,0e0h,040h,0e3h,003h,002h,000h,000h,000h,000h,007h,006h,000h	; 5a30  .....@..........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,008h,01dh,03fh,03fh,07ch,07ch	; 5a40  ............??||
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,070h,0f8h,0fch,0c0h,0c0h,0c0h,07ch	; 5a50  .........p.....|
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,083h,083h	; 5a60  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,03ch,03ch,02ah,083h	; 5a70  ............<<*.
	defb 001h,003h,007h,00fh,000h,000h,007h,03ch,03eh,007h,000h,007h,007h,003h,002h,000h	; 5a80  .......<>.......
	defb 080h,0e0h,0f0h,0f8h,070h,070h,0f8h,03ch,07eh,0f4h,000h,0f0h,0f0h,070h,040h,000h	; 5a90  ....pp.<~....p@.
	defb 000h,000h,000h,000h,007h,002h,000h,0c3h,061h,000h,000h,000h,000h,000h,001h,007h	; 5aa0  ........a.......
	defb 000h,000h,000h,000h,080h,080h,000h,0c0h,080h,002h,006h,004h,000h,000h,030h,070h	; 5ab0  ..............0p
	defb 000h,007h,00fh,01fh,000h,000h,00fh,01fh,039h,07fh,077h,000h,007h,00fh,00eh,000h	; 5ac0  ........9.w.....
	defb 000h,080h,0c0h,0e0h,070h,060h,0e0h,0fch,0fch,0f0h,080h,070h,0fch,07ch,038h,000h	; 5ad0  ....p`.....p.|8.
	defb 000h,000h,000h,000h,00fh,00ah,000h,000h,006h,000h,080h,0c0h,000h,000h,010h,01ch	; 5ae0  ................
	defb 000h,000h,000h,000h,080h,080h,000h,003h,002h,000h,000h,000h,000h,000h,004h,01ch	; 5af0  ................
	defb 001h,007h,00fh,01fh,00eh,00eh,01fh,03ch,07eh,02fh,000h,00fh,00fh,00eh,002h,000h	; 5b00  .......<~/......
	defb 080h,0c0h,0e0h,0f0h,000h,000h,0e0h,03ch,07ch,0e0h,000h,0e0h,0e0h,0c0h,040h,000h	; 5b10  .......<|.....@.
	defb 000h,000h,000h,000h,001h,001h,000h,003h,001h,040h,060h,020h,000h,000h,00ch,00eh	; 5b20  .........@` ....
	defb 000h,000h,000h,000h,0e0h,040h,000h,0c3h,086h,000h,000h,000h,000h,000h,080h,0e0h	; 5b30  .....@..........
	defb 000h,001h,003h,007h,00eh,006h,007h,03fh,03fh,00fh,001h,00eh,03fh,03eh,01ch,000h	; 5b40  .......??...?>..
	defb 000h,0e0h,0f0h,0f8h,000h,000h,0f0h,0f8h,09ch,0feh,0eeh,000h,0e0h,0f0h,070h,000h	; 5b50  ..............p.
	defb 000h,000h,000h,000h,001h,001h,000h,0c0h,040h,000h,000h,000h,000h,000h,020h,038h	; 5b60  ........@..... 8
	defb 000h,000h,000h,000h,0f0h,050h,000h,000h,060h,000h,001h,003h,000h,000h,008h,038h	; 5b70  .....P..`......8
	defb 001h,003h,00fh,01bh,00dh,00eh,007h,07fh,0f7h,09ch,08fh,05eh,00fh,01fh,036h,01ch	; 5b80  ...........^..6.
	defb 080h,0c0h,0f0h,0d8h,0b0h,070h,0e0h,0feh,0efh,039h,0f1h,07ah,0f0h,0f8h,06ch,038h	; 5b90  .....p...9.z..l8
	defb 000h,000h,000h,000h,007h,005h,000h,001h,003h,003h,000h,000h,000h,000h,00ch,01ch	; 5ba0  ................
	defb 000h,000h,000h,000h,0c0h,040h,000h,000h,080h,080h,000h,000h,000h,000h,030h,038h	; 5bb0  .....@........08
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,040h,0ffh,040h,000h	; 5bc0  ............@.@.
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,01fh,03eh,0e1h,03eh,01fh	; 5bd0  ............>.>.
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0f8h,07ch,087h,07ch,0f8h	; 5be0  ............|.|.
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,002h,0ffh,002h,000h	; 5bf0  ................
	defb 000h,000h,000h,000h,000h,060h,0f0h,07fh,07fh,0f0h,060h,000h,000h,000h,000h,000h	; 5c00  .....`....`.....
	defb 000h,000h,000h,000h,000h,006h,00fh,0feh,0feh,00fh,006h,000h,000h,000h,000h,000h	; 5c10  ................
	defb 000h,000h,000h,000h,000h,000h,003h,079h,00ch,000h,000h,000h,000h,000h,000h,000h	; 5c20  .......y........
	defb 000h,000h,000h,000h,000h,098h,0cch,0ech,0e6h,072h,038h,00ch,000h,000h,000h,000h	; 5c30  .........r8.....
	defb 000h,003h,007h,00fh,018h,008h,00fh,007h,00dh,01eh,01fh,000h,00fh,00fh,002h,000h	; 5c40  ................
	defb 000h,080h,0c0h,0e0h,030h,020h,0e0h,0c0h,070h,0f8h,0f8h,000h,0e0h,0f0h,060h,000h	; 5c50  ....0 ..p.....`.
	defb 000h,000h,000h,000h,003h,005h,000h,000h,020h,060h,060h,000h,000h,000h,00ch,01ch	; 5c60  ........ ``.....
	defb 000h,000h,000h,000h,080h,040h,000h,000h,004h,006h,006h,000h,000h,000h,010h,038h	; 5c70  .....@.........8
	defb 000h,003h,007h,00fh,01eh,00eh,03fh,03fh,01dh,00eh,00fh,000h,00fh,00eh,008h,000h	; 5c80  ......??........
	defb 000h,080h,0c0h,0e0h,000h,000h,0f8h,0f8h,078h,0f0h,0e0h,000h,0e0h,0f8h,060h,000h	; 5c90  ........x.....`.
	defb 000h,000h,000h,000h,001h,060h,040h,000h,000h,000h,000h,000h,020h,010h,010h,000h	; 5ca0  .....`@..... ...
	defb 000h,000h,000h,000h,020h,0cch,004h,000h,000h,000h,000h,000h,000h,004h,018h,000h	; 5cb0  .... ...........
	defb 001h,003h,003h,001h,031h,038h,03ch,03eh,01eh,00fh,001h,038h,07fh,07eh,038h,000h	; 5cc0  ....18<>...8.~8.
	defb 084h,0cch,0cch,0dch,0d8h,0d8h,0d8h,0d0h,050h,020h,080h,050h,098h,00ch,006h,002h	; 5cd0  ........P .P....
	defb 000h,000h,000h,000h,000h,001h,003h,005h,006h,003h,001h,000h,000h,000h,000h,000h	; 5ce0  ................
	defb 000h,000h,000h,000h,000h,080h,0c0h,0e0h,0e0h,0c0h,080h,000h,000h,000h,000h,000h	; 5cf0  ................
	defb 000h,001h,001h,043h,0e3h,0e3h,0e3h,0f3h,0f3h,077h,037h,01fh,007h,003h,000h,000h	; 5d00  ...C.....w7.....
	defb 0c6h,07dh,0ffh,096h,000h,001h,0b7h,0feh,0c2h,0e0h,0b0h,090h,080h,080h,0c0h,078h	; 5d10  .}.............x
	defb 001h,001h,003h,007h,00fh,003h,001h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5d20  ................
	defb 000h,080h,0c0h,0f0h,0e0h,0c0h,080h,080h,000h,000h,000h,000h,000h,000h,000h,000h	; 5d30  ................
	defb 000h,005h,003h,003h,007h,003h,004h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5d40  ................
	defb 000h,020h,0c0h,0e0h,0c0h,0c0h,0a0h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5d50  . ..............
	defb 007h,01fh,03fh,03fh,067h,063h,061h,063h,067h,03fh,03ah,03fh,01fh,015h,015h,015h	; 5d60  ..??gcacg?:?....
	defb 0e0h,0f0h,0f8h,0f8h,03ch,01eh,00eh,01eh,03ch,0fch,0fch,0f8h,0f8h,058h,050h,070h	; 5d70  ....<...<....XPp
	defb 001h,002h,002h,001h,001h,04dh,0e7h,0e3h,0e3h,0f7h,0f7h,0f7h,077h,03fh,01fh,006h	; 5d80  .....M......w?..
	defb 00eh,0f2h,07eh,092h,000h,000h,0b4h,0feh,0c3h,080h,080h,080h,080h,082h,0c7h,007h	; 5d90  ..~.............
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5da0  ................
	defb 000h,000h,000h,06ch,0b4h,0ech,048h,000h,03ch,07eh,07eh,066h,07ch,078h,030h,000h	; 5db0  ...l..H.<~~f|x0.
	defb 008h,008h,010h,037h,03fh,077h,073h,0bbh,03fh,03fh,03fh,038h,030h,015h,010h,008h	; 5dc0  ...7?ws.???80...
	defb 008h,008h,010h,0d0h,0fch,0deh,09fh,03bh,0f9h,0f8h,0f8h,078h,030h,030h,030h,0e0h	; 5dd0  .......;...x000.
	defb 006h,004h,00ch,01fh,013h,09bh,0c0h,0ffh,078h,003h,01fh,010h,018h,00ch,00fh,007h	; 5de0  ........x.......
	defb 070h,038h,07ch,0ech,08eh,03eh,0feh,07eh,0f6h,0ech,09ch,03ch,078h,0f8h,0f0h,0e0h	; 5df0  p8|..>.~...<x...
	defb 000h,003h,00fh,007h,007h,000h,000h,000h,007h,004h,0fch,007h,007h,00fh,00eh,004h	; 5e00  ................
	defb 000h,0f0h,0fch,0f8h,0f8h,018h,018h,018h,0f0h,0f0h,078h,0f8h,0f8h,0feh,00eh,008h	; 5e10  ..........x.....
	defb 000h,000h,000h,000h,000h,007h,005h,017h,020h,043h,003h,040h,020h,010h,000h,018h	; 5e20  ........ C.@ ...
	defb 000h,000h,000h,000h,000h,0e0h,060h,0e0h,000h,000h,080h,000h,000h,000h,000h,003h	; 5e30  ......`.........
	defb 003h,00fh,007h,007h,000h,000h,000h,007h,003h,0fch,000h,003h,003h,001h,000h,000h	; 5e40  ................
	defb 0f0h,0fch,0f8h,0f8h,018h,018h,018h,0f8h,0f0h,0f0h,078h,0f8h,0f8h,0f0h,0c0h,000h	; 5e50  ..........x.....
	defb 000h,000h,000h,000h,007h,015h,037h,050h,053h,003h,050h,050h,030h,010h,000h,001h	; 5e60  ......7PS.PP0...
	defb 000h,000h,000h,000h,0e0h,060h,0e0h,000h,000h,080h,000h,000h,000h,000h,020h,0e0h	; 5e70  .....`........ .
	defb 000h,00fh,03fh,01fh,01fh,018h,018h,018h,00fh,00fh,01eh,01fh,01fh,07fh,070h,010h	; 5e80  ..?...........p.
	defb 000h,0c0h,0f0h,0e0h,0e0h,000h,000h,000h,0e0h,020h,03fh,0e0h,0e0h,0f0h,070h,020h	; 5e90  ......... ?...p 
	defb 000h,000h,000h,000h,000h,007h,006h,007h,000h,000h,001h,000h,000h,000h,000h,0c0h	; 5ea0  ................
	defb 000h,000h,000h,000h,000h,0e0h,0a0h,0e8h,004h,0c2h,0c0h,002h,004h,008h,000h,018h	; 5eb0  ................
	defb 00fh,03fh,01fh,01fh,018h,018h,018h,01fh,00fh,00fh,01eh,01fh,01fh,00fh,003h,000h	; 5ec0  .?..............
	defb 0c0h,0f0h,0e0h,0e0h,000h,000h,000h,0e0h,0c0h,03fh,000h,0c0h,0c0h,080h,000h,000h	; 5ed0  .........?......
	defb 000h,000h,000h,000h,007h,006h,007h,000h,000h,001h,000h,000h,000h,000h,004h,007h	; 5ee0  ................
	defb 000h,000h,000h,000h,0e0h,0a8h,0ech,00ah,0cah,0c0h,00ah,00ah,00ch,008h,000h,080h	; 5ef0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5f00  ................
	defb 01fh,03fh,07fh,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,07fh,07fh,03fh,03fh,01fh,007h	; 5f10  .?..........??..
	defb 0f0h,0fch,0feh,0ffh,0ffh,0ffh,0fch,0fch,0fch,0fch,0feh,0feh,0feh,0fch,0f8h,0fch	; 5f20  ................
	defb 000h,000h,000h,000h,080h,082h,082h,002h,007h,007h,00eh,00ch,018h,038h,070h,0e0h	; 5f30  .............8p.
	defb 000h,03fh,07fh,006h,00eh,00ch,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5f40  .?..............
	defb 000h,001h,0f3h,0ffh,03fh,00fh,00fh,00fh,007h,007h,00fh,00fh,01fh,000h,000h,001h	; 5f50  ....?...........
	defb 07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,03ch,0feh,0feh	; 5f60  .............<..
	defb 0c0h,0c0h,080h,080h,080h,0c0h,0c0h,0e0h,0f0h,0f0h,0f8h,0f8h,0f0h,000h,000h,000h	; 5f70  ................
	defb 000h,000h,000h,001h,001h,003h,003h,003h,003h,003h,003h,003h,001h,001h,000h,000h	; 5f80  ................
	defb 03fh,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,03fh	; 5f90  ?..............?
	defb 000h,0c0h,0f0h,0f8h,0fch,0f2h,0f0h,0f0h,0e0h,0e0h,0e0h,0e0h,0c0h,0fdh,0ffh,0ffh	; 5fa0  ................
	defb 000h,080h,040h,020h,0a0h,0e0h,060h,070h,030h,038h,038h,070h,0f0h,0e0h,0e0h,0e0h	; 5fb0  ..@ ..`p088p....
	defb 000h,000h,000h,000h,000h,041h,0ffh,00fh,01eh,038h,000h,000h,000h,000h,001h,001h	; 5fc0  .....A...8......
	defb 001h,001h,007h,01fh,07fh,0ffh,0efh,00fh,00fh,00fh,00fh,00fh,01fh,0ffh,0fch,07ch	; 5fd0  ...............|
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,080h,000h,001h,003h	; 5fe0  ................
	defb 0c0h,0c0h,0e0h,0e0h,0e0h,0e0h,0f0h,0f0h,0f8h,0f8h,0f8h,0f8h,0f0h,078h,0f8h,0f8h	; 5ff0  .............x..
	defb 000h,000h,03fh,07fh,0ffh,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0ffh,07fh,03fh,000h	; 6000  ..?...........?.
	defb 000h,000h,0e0h,0f0h,0f8h,078h,000h,000h,000h,000h,039h,079h,0f9h,0f3h,0e3h,000h	; 6010  .....x....9y....
	defb 000h,000h,03eh,03eh,07fh,077h,077h,0e3h,0e3h,0e3h,0ffh,0ffh,0c1h,080h,080h,000h	; 6020  ..>>.ww.........
	defb 000h,000h,003h,007h,00fh,00fh,00fh,08fh,087h,083h,0c0h,0cfh,0cfh,0e7h,0e3h,000h	; 6030  ................
	defb 000h,000h,0feh,0ffh,0ffh,007h,000h,0feh,0ffh,0ffh,007h,007h,0ffh,0ffh,0feh,000h	; 6040  ................
	defb 000h,000h,038h,039h,0bbh,0bbh,03bh,03bh,03bh,0bbh,0bbh,0bbh,0bbh,039h,038h,000h	; 6050  ..89..;;;....98.
	defb 000h,000h,0ffh,0ffh,0ffh,0c1h,080h,080h,080h,080h,080h,0c1h,0ffh,0ffh,0ffh,000h	; 6060  ................
	defb 000h,000h,080h,0c0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0c0h,080h,000h	; 6070  ................
	defb 018h,00dh,00ch,018h,018h,03bh,030h,070h,079h,0d8h,018h,018h,018h,018h,018h,019h	; 6080  .....;0py.......
	defb 004h,0feh,066h,066h,066h,0ffh,066h,066h,0feh,066h,060h,060h,060h,0e0h,0c0h,080h	; 6090  ..fff.ff.f```...
	defb 01ah,07eh,01bh,033h,066h,000h,01fh,018h,01fh,018h,01fh,018h,01fh,00ch,03ch,070h	; 60a0  .~.3f.........<p
	defb 004h,07eh,066h,066h,07eh,000h,0f8h,018h,0f8h,018h,0f8h,018h,0f8h,030h,03ch,00eh	; 60b0  .~ff~........0<.
	defb 000h,03fh,003h,00bh,006h,00eh,00dh,039h,000h,018h,00dh,00dh,06dh,06dh,06ch,0cfh	; 60c0  .?.....9....mml.
	defb 010h,0f8h,018h,018h,018h,018h,038h,070h,000h,000h,000h,0a0h,0b4h,0b6h,006h,0fch	; 60d0  ......8p........
	defb 001h,070h,030h,037h,000h,080h,0e0h,0efh,000h,001h,023h,026h,066h,0efh,0efh,0c8h	; 60e0  .p07......#&f...
	defb 0c0h,0c0h,0c8h,0fch,0c0h,0c0h,0c4h,0feh,0c0h,0c0h,018h,018h,00ch,0fch,0fch,00ch	; 60f0  ................
	defb 038h,018h,01ah,0ffh,0dbh,0dbh,0dbh,0dbh,018h,019h,019h,019h,019h,019h,019h,019h	; 6100  8...............
	defb 070h,030h,030h,03eh,030h,030h,030h,030h,030h,0feh,086h,086h,086h,086h,0feh,086h	; 6110  p00>00000.......
	defb 010h,018h,00ch,00ch,001h,000h,000h,080h,011h,019h,019h,019h,0ffh,019h,019h,019h	; 6120  ................
	defb 000h,080h,080h,090h,0f8h,080h,080h,090h,010h,01fh,018h,018h,018h,018h,01fh,018h	; 6130  ................
	defb 0c1h,060h,040h,001h,001h,001h,001h,005h,0ffh,006h,006h,006h,0ffh,086h,0a6h,0b6h	; 6140  .`@.............
	defb 0f8h,000h,000h,010h,0f8h,018h,098h,0d8h,018h,018h,018h,01fh,018h,018h,018h,018h	; 6150  ................
	defb 005h,009h,049h,029h,039h,019h,011h,011h,0b6h,0b6h,0bfh,0b0h,080h,080h,080h,080h	; 6160  ..I)9...........
	defb 0d8h,0d8h,0d8h,0d8h,018h,098h,078h,038h,018h,018h,018h,038h,030h,070h,060h,0e0h	; 6170  ......x8...80p`.
	defb 0ffh,0ffh,07fh,07eh,07ch,078h,070h,0e0h,0ffh,03ch,0ffh,07eh,07dh,07bh,077h,0e3h	; 6180  ...~|xp..<.~}{w.
	defb 0ffh,03ch,0ffh,0ffh,0ffh,0ffh,0ffh,0e7h,0ffh,0ffh,0feh,07eh,03eh,01eh,00eh,007h	; 6190  .<.........~>...
	defb 0ffh,03ch,0ffh,07eh,0beh,0deh,0eeh,0c7h,0ffh,03ch,0ffh,0ffh,0ffh,0ffh,0ffh,0e7h	; 61a0  .<.~.....<......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 61b0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 61c0  ................
	defb 07eh,0c3h,0ffh,0ffh,0ffh,0ffh,0ffh,0e7h,0efh,0efh,0efh,000h,0fdh,0fdh,0fdh,000h	; 61d0  ~...............
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,011h,011h,015h,055h,055h,055h,0ffh	; 61e0  ............UUU.
	defb 038h,038h,038h,038h,03ch,01ch,01ch,01ch,03ch,07eh,07eh,0ffh,0ffh,0ffh,000h,07eh	; 61f0  8888<...<~~....~
	defb 077h,0ffh,0ffh,0efh,070h,09bh,0e1h,002h,06eh,0bfh,0f7h,010h,0bfh,0ffh,0bbh,0f0h	; 6200  w...p...n.......
	defb 0ffh,018h,03ch,00eh,082h,09bh,010h,0ffh,0f8h,01fh,0f7h,040h,010h,0ffh,008h,002h	; 6210  ..<........@....
	defb 06bh,0dfh,0eeh,084h,070h,0bdh,0a9h,0efh,07bh,0efh,0fbh,0a0h,0bbh,04ah,0fbh,0efh	; 6220  k...p...{....J..
	defb 011h,0ffh,0dfh,008h,040h,0ffh,0efh,0ffh,010h,0bfh,0ffh,002h,0bbh,0ffh,0dfh,0ffh	; 6230  ....@...........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6240  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6250  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6260  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6270  ................
	defb 000h,001h,007h,00dh,01bh,01fh,03fh,000h,000h,0c0h,0f0h,0f8h,0fch,0feh,0feh,000h	; 6280  ......?.........
	defb 0ffh,0ffh,000h,07fh,05fh,07fh,000h,0ffh,0ffh,0ffh,000h,07eh,07ah,07eh,000h,0ffh	; 6290  ...._......~z~..
	defb 00bh,00bh,00fh,000h,02fh,05fh,058h,070h,0f8h,0f8h,0f8h,000h,0feh,0ffh,00fh,007h	; 62a0  ..../_Xp........
	defb 03fh,07fh,0ffh,0ffh,0ffh,0ffh,07fh,03fh,0f4h,0eeh,0dbh,0d5h,0d5h,0dbh,0eeh,0f4h	; 62b0  ?......?........
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0cfh,05fh,00fh,0efh,0e7h,0f7h,0f1h,0f8h	; 62c0  ........._......
	defb 0dfh,0d1h,0c4h,0cfh,09fh,0bfh,03fh,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 62d0  ......?.........
	defb 07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,07fh,0f2h,0fah,0fah,0fah,0fah,0fah,0f8h,0f2h	; 62e0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 62f0  ................
	defb 000h,002h,00eh,01eh,03eh,03eh,07eh,000h,07eh,0ffh,0ffh,0ffh,0ffh,0c0h,08bh,000h	; 6300  ....>>~.~.......
	defb 000h,040h,070h,078h,07ch,07ch,03eh,000h,007h,003h,001h,001h,001h,001h,001h,007h	; 6310  .@px||>.........
	defb 07eh,0feh,0feh,0feh,0fch,0fah,0fah,072h,07bh,07ch,07eh,0ffh,0ffh,0f9h,0f2h,0e3h	; 6320  ~......r{|~.....
	defb 06eh,03fh,04fh,067h,03fh,05fh,07fh,03eh,0e0h,0c0h,080h,080h,080h,080h,080h,0e0h	; 6330  n?Og?_.>........
	defb 000h,06eh,02eh,02eh,01eh,006h,002h,000h,000h,09ah,0bbh,03bh,07bh,07bh,0fbh,07eh	; 6340  .n.........;{{.~
	defb 000h,05eh,06ch,07ch,038h,030h,040h,000h,03ch,03ch,07eh,07eh,07eh,07eh,07eh,07eh	; 6350  .^l|80@.<<~~~~~~
	defb 03ch,03ch,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,03ch,03ch	; 6360  <<~~~~~~~~~~~~<<
	defb 07fh,07fh,07fh,07fh,07fh,07fh,07fh,07fh,07eh,07eh,07eh,07eh,07eh,07eh,03ch,03ch	; 6370  ........~~~~~~<<
	defb 0ffh,07fh,07fh,07fh,07fh,07fh,07fh,07fh,0ffh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 6380  ................
	defb 07eh,0c3h,081h,091h,0a1h,0a1h,0a1h,0a1h,000h,03ch,042h,0ffh,020h,040h,040h,040h	; 6390  ~........<B. @@@
	defb 07fh,07fh,07fh,07fh,07fh,07fh,07fh,07fh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 63a0  ................
	defb 081h,0c3h,07eh,03ch,018h,018h,018h,018h,040h,0ffh,001h,0ffh,001h,0ffh,042h,03ch	; 63b0  ..~<....@.....B<
	defb 04fh,04fh,07fh,07fh,07fh,07fh,07fh,07fh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 63c0  OO..............
	defb 07fh,07fh,07fh,07fh,07fh,07fh,07fh,07fh,0f2h,0f2h,0feh,0feh,0feh,0feh,0feh,0feh	; 63d0  ................
	defb 080h,080h,080h,080h,080h,07fh,07fh,0ffh,001h,001h,001h,001h,001h,0feh,0feh,0ffh	; 63e0  ................
	defb 03ch,03ch,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,03ch,03ch	; 63f0  <<~~~~~~~~~~~~<<
	defb 003h,007h,00fh,01fh,03fh,07fh,0ffh,0ffh,0c0h,000h,0f0h,000h,0fch,000h,0ffh,0ffh	; 6400  ....?...........
	defb 0ffh,0ffh,093h,0dbh,0dbh,0dbh,0dbh,0ffh,000h,000h,000h,000h,000h,003h,003h,001h	; 6410  ................
	defb 0e7h,0e7h,0dbh,0bdh,0bdh,0dbh,0e7h,0ffh,000h,0ffh,0ffh,0ffh,000h,0ffh,0ffh,000h	; 6420  ................
	defb 0c0h,0e0h,0b0h,098h,08ch,0c6h,0c3h,0c1h,003h,007h,00dh,019h,031h,063h,0c3h,083h	; 6430  ............1c..
	defb 040h,040h,040h,040h,040h,040h,040h,040h,002h,002h,002h,002h,002h,002h,002h,002h	; 6440  @@@@@@@@........
	defb 0c1h,0c3h,0c6h,0cch,098h,0b0h,0e0h,0c0h,083h,0c3h,063h,033h,019h,00dh,007h,003h	; 6450  ..........c3....
	defb 0e7h,0e7h,0e7h,0e7h,0e7h,0e7h,0e7h,0e7h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 6460  ................
	defb 000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,07eh,05eh,05eh,076h,076h,076h,07eh,07eh	; 6470  ........~^^vvv~~
	defb 001h,003h,006h,00ch,018h,030h,060h,0c0h,0c0h,040h,040h,040h,040h,040h,040h,040h	; 6480  .....0`..@@@@@@@
	defb 0c0h,080h,000h,000h,000h,000h,000h,000h,080h,0c0h,060h,030h,018h,00ch,006h,003h	; 6490  ..........`0....
	defb 003h,002h,002h,002h,002h,002h,002h,002h,003h,001h,000h,000h,000h,000h,000h,000h	; 64a0  ................
	defb 000h,000h,000h,000h,0c2h,0b4h,05ch,0f7h,0c0h,0f0h,070h,0feh,0fch,0feh,016h,000h	; 64b0  ......\...p.....
	defb 0ffh,078h,000h,000h,001h,001h,040h,040h,09bh,01ch,07fh,03ah,0ffh,0e0h,080h,000h	; 64c0  .x....@@...:....
	defb 0efh,0efh,0efh,000h,0fdh,0fdh,0fdh,000h,0d0h,080h,0c0h,0f8h,0b8h,0f8h,030h,000h	; 64d0  ..............0.
	defb 0ffh,0ffh,0ffh,000h,018h,018h,018h,018h,07eh,07eh,000h,07eh,000h,07eh,07eh,07eh	; 64e0  ........~~.~.~~~
	defb 0efh,0eeh,0ech,000h,0f0h,0e0h,0c0h,000h,0efh,06fh,02fh,000h,00dh,005h,001h,000h	; 64f0  .........o/.....
	defb 000h,001h,001h,001h,003h,003h,007h,007h,041h,0eeh,0feh,0c0h,080h,000h,080h,000h	; 6500  ........A.......
	defb 007h,010h,038h,0dch,0f5h,0dfh,0f7h,0ffh,000h,000h,000h,000h,0c6h,0fah,0c0h,060h	; 6510  ..8............`
	defb 01fh,037h,07fh,0feh,0fbh,0f8h,0c0h,000h,0a0h,0f0h,0f8h,0dch,03eh,01ah,00ch,008h	; 6520  .7..........>...
	defb 06fh,0ffh,0ffh,087h,050h,0e8h,0f8h,0d8h,0f8h,0fch,0c8h,0f0h,0f0h,000h,004h,00bh	; 6530  o...P...........
	defb 09ch,0bch,0feh,0ffh,0ffh,079h,050h,0e0h,00fh,00ch,007h,003h,000h,080h,0e0h,03bh	; 6540  .....yP........;
	defb 0f8h,0d5h,07fh,0fbh,0dfh,0ffh,03dh,007h,000h,000h,0c0h,0e0h,0b0h,0f0h,0f8h,078h	; 6550  ......=........x
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0f8h,0f8h,0ach,0fch,07ch,008h,000h,000h,000h,000h	; 6560  ..........|.....
	defb 0fch,0dfh,0ffh,0ffh,0e1h,0c0h,080h,0c0h,000h,080h,080h,0c0h,0e0h,0f0h,03fh,00fh	; 6570  ..............?.
	defb 018h,018h,008h,008h,010h,010h,018h,018h,0f2h,0fah,0fah,0fah,0fah,0fah,0f8h,0f2h	; 6580  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,000h,0ffh,000h,0fah,0fah,0fah,0fah,0f8h,002h,005h,002h	; 6590  ................
	defb 001h,007h,01fh,03fh,0fdh,03fh,039h,000h,000h,000h,000h,000h,000h,038h,07ch,0deh	; 65a0  ...?.?9......8|.
	defb 01fh,06fh,07fh,01fh,0bch,008h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 65b0  .o..............
	defb 0ffh,0ffh,03fh,03fh,03fh,0ffh,0ffh,0ffh,0ffh,0ffh,03fh,03fh,03fh,03fh,03fh,0ffh	; 65c0  ..???.....?????.
	defb 072h,0fah,0fah,0fah,0fah,0fah,0f8h,072h,0ffh,0f8h,002h,0fah,0fah,0fah,0fah,0fah	; 65d0  r......r........
	defb 0feh,0ffh,0efh,0ffh,007h,001h,000h,000h,080h,000h,0c0h,0c0h,0c0h,084h,007h,03fh	; 65e0  ...............?
	defb 000h,000h,00fh,00fh,01fh,07fh,07eh,0ffh,000h,080h,0c0h,0e0h,0f8h,07eh,0efh,0f7h	; 65f0  ......~......~..
	defb 038h,038h,038h,03ch,03ch,01ch,01ch,01ch,00fh,00fh,007h,007h,007h,007h,007h,007h	; 6600  888<<...........
	defb 081h,081h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f0h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 6610  ................
	defb 03ch,03ch,07eh,07eh,07eh,07eh,07eh,07eh,007h,007h,007h,007h,007h,007h,007h,007h	; 6620  <<~~~~~~........
	defb 0f7h,0c1h,0d3h,083h,0f7h,0e7h,08fh,0efh,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 6630  ................
	defb 07eh,07eh,07eh,07eh,07eh,07eh,03ch,03ch,03ch,03ch,07eh,07eh,07eh,07eh,07eh,07eh	; 6640  ~~~~~~<<<<~~~~~~
	defb 083h,0e3h,0ebh,0efh,0efh,0e7h,0f7h,0f3h,07eh,07eh,07eh,07eh,07eh,07eh,03ch,03ch	; 6650  ........~~~~~~<<
	defb 03ch,03ch,07eh,07eh,07eh,07eh,07eh,07eh,007h,007h,007h,007h,007h,007h,00fh,00fh	; 6660  <<~~~~~~........
	defb 0f9h,0fdh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0f0h	; 6670  ................
	defb 00fh,00fh,00fh,00fh,000h,000h,000h,000h,081h,081h,0ffh,0ffh,000h,000h,000h,000h	; 6680  ................
	defb 0f0h,0f0h,0f0h,0f0h,000h,000h,000h,000h,018h,018h,018h,018h,018h,018h,018h,018h	; 6690  ................
	defb 018h,018h,018h,03ch,07eh,07eh,03ch,018h,018h,018h,018h,03ch,07eh,07eh,03ch,018h	; 66a0  ...<~~<....<~~<.
	defb 07eh,07eh,07eh,07eh,07eh,07eh,03ch,03ch,018h,018h,024h,024h,042h,042h,081h,081h	; 66b0  ~~~~~~<<..$$BB..
	defb 000h,000h,000h,000h,000h,010h,010h,07ch,010h,010h,000h,000h,000h,000h,000h,000h	; 66c0  .......|........
	defb 000h,000h,000h,000h,000h,008h,008h,03eh,008h,008h,000h,000h,000h,000h,000h,000h	; 66d0  .......>........
	defb 05fh,07fh,07fh,0ffh,07ch,008h,000h,07eh,0efh,0f8h,0f0h,000h,000h,000h,000h,000h	; 66e0  _...|..~........
	defb 0feh,0efh,006h,000h,000h,000h,000h,000h,003h,017h,0beh,058h,000h,000h,000h,000h	; 66f0  ...........X....
	defb 007h,018h,020h,040h,040h,080h,080h,080h,0e0h,038h,01ch,00eh,00eh,007h,007h,007h	; 6700  .. @@....8......
	defb 007h,019h,020h,040h,040h,080h,080h,080h,0e0h,0f8h,07ch,07eh,03eh,03fh,03fh,03fh	; 6710  .. @@.....|~>???
	defb 080h,080h,080h,040h,040h,020h,018h,007h,007h,007h,007h,00eh,00eh,01ch,038h,0e0h	; 6720  ...@@ ........8.
	defb 080h,080h,080h,040h,040h,020h,019h,007h,03fh,03fh,03fh,03eh,07eh,07ch,0f8h,0e0h	; 6730  ...@@ ..???>~|..
	defb 007h,01fh,027h,047h,043h,083h,083h,083h,0e0h,0f8h,0fch,0feh,0feh,0ffh,0ffh,0ffh	; 6740  ..'GC...........
	defb 007h,01fh,03fh,07fh,07fh,0ffh,0ffh,0ffh,0e0h,0f8h,0fch,0feh,0feh,0ffh,0ffh,0ffh	; 6750  ..?.............
	defb 083h,083h,083h,043h,047h,027h,01fh,007h,0ffh,0ffh,0ffh,0feh,0feh,0fch,0f8h,0e0h	; 6760  ...CG'..........
	defb 0ffh,0ffh,0ffh,07fh,07fh,03fh,01fh,007h,0ffh,0ffh,0ffh,0feh,0feh,0fch,0f8h,0e0h	; 6770  .....?..........
	defb 038h,07ch,0feh,0feh,0feh,0feh,07ch,038h,066h,066h,022h,0ffh,022h,022h,055h,055h	; 6780  8|....|8ff".""UU
	defb 038h,06ch,054h,038h,07ch,07ch,07ch,038h,02ah,02ah,0beh,0beh,0feh,0feh,07eh,03ch	; 6790  8lT8|||8**....~<
	defb 010h,018h,03ch,03ch,06eh,076h,02ch,018h,000h,008h,01ch,008h,022h,077h,022h,000h	; 67a0  ..<<nv,....."w".
	defb 000h,004h,00eh,004h,020h,070h,020h,000h,0fch,0fch,03dh,00dh,009h,003h,003h,006h	; 67b0  .... p ...=.....
	defb 006h,00dh,01fh,01fh,03ah,03eh,07fh,067h,000h,000h,000h,000h,000h,001h,006h,000h	; 67c0  ....:>.g........
	defb 000h,001h,003h,00eh,00bh,07ah,0c0h,080h,0efh,08fh,0ffh,0ffh,0cfh,007h,00bh,007h	; 67d0  .....z..........
	defb 000h,000h,038h,07ch,07ch,07ch,07ch,07ch,07ch,07ch,07ch,07ch,07ch,07ch,038h,000h	; 67e0  ..8|||||||||||8.
	defb 03ch,07eh,0ffh,0fch,0ach,0fch,07eh,03ch,01ch,03eh,07fh,03fh,035h,03fh,07fh,03ch	; 67f0  <~....~<.>.?5?.<
	defb 004h,0feh,006h,006h,006h,006h,0feh,006h,000h,002h,003h,003h,003h,003h,003h,01fh	; 6800  ................
	defb 000h,000h,000h,000h,000h,004h,047h,0e6h,023h,031h,031h,030h,030h,030h,0ffh,030h	; 6810  ......G.#11000.0
	defb 006h,006h,006h,0feh,006h,006h,006h,006h,003h,003h,003h,003h,003h,013h,00bh,007h	; 6820  ................
	defb 006h,006h,006h,006h,026h,047h,0c6h,086h,038h,018h,01ch,00eh,026h,0f6h,036h,037h	; 6830  ....&G..8...&.67
	defb 006h,006h,006h,026h,016h,01eh,00eh,004h,007h,003h,001h,000h,000h,000h,000h,000h	; 6840  ...&............
	defb 086h,00eh,00eh,00ch,01ch,018h,039h,070h,033h,031h,033h,073h,066h,0e4h,0cch,0d0h	; 6850  ......9p313sf...
	defb 000h,000h,040h,040h,0e0h,0e0h,0c0h,0c0h,00fh,03fh,039h,061h,061h,0c1h,0c1h,0c3h	; 6860  ..@@.....?9aa...
	defb 0f8h,0fch,08eh,086h,087h,083h,083h,083h,033h,03fh,033h,033h,03fh,003h,003h,003h	; 6870  ........3?33?...
	defb 0c0h,082h,0c4h,0e4h,06ch,07ch,038h,018h,0c3h,0e7h,067h,06eh,03ch,018h,000h,000h	; 6880  ....l|8...gn<...
	defb 003h,003h,006h,006h,00ch,018h,000h,000h,07fh,003h,003h,003h,003h,003h,003h,003h	; 6890  ................
	defb 031h,0f1h,030h,030h,0f0h,000h,000h,010h,080h,0c0h,0c8h,0d8h,0d8h,0d8h,0f1h,0f2h	; 68a0  1.00............
	defb 040h,040h,060h,060h,060h,060h,060h,070h,004h,006h,003h,003h,003h,003h,003h,003h	; 68b0  @@`````p........
	defb 0f8h,000h,001h,001h,003h,002h,00eh,030h,066h,0e6h,0e6h,0ech,07ch,03ch,038h,038h	; 68c0  .......0f...|<88
	defb 030h,031h,03bh,01fh,00eh,006h,000h,000h,08fh,007h,002h,000h,000h,000h,000h,000h	; 68d0  01;.............
	defb 000h,080h,080h,0c0h,000h,080h,0c0h,000h,008h,044h,026h,034h,011h,020h,03fh,033h	; 68e0  .........D&4. ?3
	defb 041h,061h,071h,0e1h,001h,021h,0f7h,031h,020h,098h,098h,088h,080h,084h,0feh,080h	; 68f0  Aaq..!.1 .......
	defb 000h,00fh,010h,010h,00fh,000h,010h,00fh,000h,01ch,0a2h,022h,022h,0a2h,0a2h,01ch	; 6900  ...........""...
	defb 000h,0fbh,080h,080h,0f0h,080h,080h,080h,000h,0e8h,088h,089h,089h,089h,089h,086h	; 6910  ................
	defb 000h,027h,028h,028h,02fh,028h,028h,0c8h,000h,09eh,051h,051h,0deh,052h,051h,051h	; 6920  .'((/((...QQ.RQQ
	defb 000h,07ch,040h,040h,078h,040h,040h,07ch,000h,000h,000h,000h,000h,000h,000h,000h	; 6930  .|@@x@@|........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,03ch,042h,099h,0a1h,0a1h,099h,042h,03ch	; 6940  ........<B....B<
	defb 07fh,080h,080h,080h,080h,080h,080h,07fh,003h,004h,008h,008h,00fh,008h,008h,008h	; 6950  ................
	defb 0c0h,020h,010h,010h,0f0h,010h,010h,010h,07fh,080h,080h,07eh,001h,001h,001h,0feh	; 6960  . .........~....
	defb 010h,010h,010h,010h,010h,010h,010h,010h,07eh,081h,081h,081h,081h,081h,081h,07eh	; 6970  ........~......~
	defb 007h,007h,007h,007h,007h,007h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f7h,0f7h	; 6980  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,000h,07eh,07eh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,07eh	; 6990  ......~~.......~
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,07eh,07fh,0ffh,03fh,01fh,00fh,0ffh,0ffh,0ffh	; 69a0  .......~..?.....
	defb 000h,000h,000h,000h,000h,00fh,00fh,00fh,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh,0ffh	; 69b0  ................
	defb 000h,000h,000h,000h,000h,0ffh,0ffh,0ffh,060h,0f1h,017h,03ch,078h,03eh,03ch,0feh	; 69c0  ........`..<x><.
	defb 000h,000h,080h,000h,038h,07ch,0feh,0beh,09ch,0feh,0c0h,0e0h,0feh,0ffh,0ffh,0ffh	; 69d0  ....8|..........
	defb 003h,003h,007h,00fh,01fh,03fh,07eh,0feh,001h,003h,007h,00fh,01eh,03eh,07eh,0feh	; 69e0  .....?~......>~.
	defb 000h,000h,000h,000h,000h,000h,000h,0e0h,00fh,00fh,00fh,00fh,00fh,0ffh,0ffh,0ffh	; 69f0  ................
	defb 000h,001h,0ffh,0ffh,0ffh,0ffh,07fh,01fh,000h,000h,01fh,00fh,007h,001h,01ch,00fh	; 6a00  ................
	defb 00fh,00fh,003h,001h,001h,000h,000h,000h,00fh,00fh,0c0h,0f0h,0fch,03fh,03fh,007h	; 6a10  .............??.
	defb 0ffh,0ffh,01fh,01fh,000h,0f8h,0ffh,03fh,000h,098h,0feh,0ffh,0ffh,07fh,000h,0ffh	; 6a20  .......?........
	defb 0fch,0f1h,0f7h,0ffh,0ffh,0ffh,000h,0ffh,02fh,08fh,0efh,0ffh,0ffh,0ffh,000h,0ffh	; 6a30  ......../.......
	defb 0c3h,018h,07eh,0ffh,0ffh,0ffh,000h,0ffh,03fh,00fh,000h,000h,000h,000h,000h,000h	; 6a40  ..~.....?.......
	defb 0ffh,0ffh,03fh,00fh,00fh,000h,000h,000h,0ffh,0ffh,00fh,00fh,01ah,01ah,01ah,01ah	; 6a50  ..?.............
	defb 0ffh,0ffh,00fh,00fh,000h,000h,000h,0ffh,0ffh,0ffh,0ffh,01dh,01dh,01dh,01dh,01dh	; 6a60  ................
	defb 0ffh,0ffh,0ffh,0ffh,0deh,0deh,0deh,0deh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,03fh,03fh	; 6a70  ..............??
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01dh,01dh,01dh,01dh,01dh,01dh,01dh,01dh	; 6a80  ................
	defb 07eh,0c3h,081h,091h,0a1h,0a1h,0a1h,0a1h,03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh	; 6a90  ~.......????????
	defb 03eh,03ch,038h,030h,020h,0ffh,0ffh,0ffh,01dh,01dh,01dh,01dh,01dh,01dh,0ffh,0ffh	; 6aa0  ><80 ...........
	defb 081h,0c3h,07eh,03ch,018h,018h,018h,018h,0fch,0fch,0f8h,0f0h,0e0h,0c0h,080h,0ffh	; 6ab0  ..~<............
	defb 0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 6ac0  ................
	defb 01eh,01eh,01eh,0feh,0feh,0feh,0feh,0feh,078h,078h,078h,07fh,07fh,07fh,07fh,07fh	; 6ad0  ........xxx.....
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,07fh,07fh,07fh,07fh,07fh,07fh,07fh,07fh	; 6ae0  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 6af0  ................
	defb 0f3h,0f3h,003h,003h,003h,003h,003h,003h,07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh	; 6b00  ........~~~~~~~~
	defb 003h,003h,003h,003h,003h,003h,003h,003h,07fh,07fh,07fh,07fh,07fh,07fh,07fh,07fh	; 6b10  ................
	defb 039h,07fh,003h,007h,07fh,0ffh,0ffh,0ffh,000h,000h,001h,000h,01ch,03eh,07fh,07dh	; 6b20  9............>.}
	defb 0feh,0ffh,0fch,0f8h,0f0h,0ffh,0ffh,0ffh,006h,08fh,0e8h,03ch,01eh,07ch,03ch,07fh	; 6b30  ...........<.|<.
	defb 00fh,03fh,03eh,0feh,0feh,07eh,07eh,07eh,000h,000h,000h,000h,000h,000h,000h,007h	; 6b40  .?>..~~~........
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0efh,0efh	; 6b50  ................
	defb 0cfh,0cfh,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h	; 6b60  ................
	defb 0c0h,0c0h,0e0h,0f0h,0f8h,0fch,07eh,07fh,080h,0c0h,0e0h,0f0h,078h,07ch,07eh,07fh	; 6b70  ......~.....x|~.
	defb 0ffh,0ffh,0f0h,0f0h,058h,058h,058h,058h,0f0h,0fch,07ch,07fh,07fh,07eh,07eh,07eh	; 6b80  ....XXXX..|..~~~
	defb 000h,080h,0ffh,0ffh,0ffh,0ffh,0feh,0f8h,000h,000h,0f8h,0f0h,0e0h,080h,038h,0f0h	; 6b90  ..............8.
	defb 0f0h,0e0h,0c0h,080h,000h,000h,000h,000h,0f0h,0f0h,003h,00fh,03fh,0feh,0fch,0f0h	; 6ba0  ............?...
	defb 0ffh,0ffh,0f8h,0f8h,000h,01fh,0ffh,0fch,000h,019h,07fh,0ffh,0ffh,0feh,000h,0ffh	; 6bb0  ................
	defb 0ffh,0ffh,0ffh,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h	; 6bc0  ................
	defb 0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0ffh,0ffh,0fch,0e0h,000h,000h,000h,000h,000h,000h	; 6bd0  ................
	defb 0ffh,0ffh,0fch,0f0h,0f0h,000h,000h,000h,0ffh,0ffh,0f0h,0f0h,058h,058h,058h,058h	; 6be0  ............XXXX
	defb 0ffh,0ffh,0f0h,0f0h,000h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,07bh,07bh,07bh,07bh	; 6bf0  ............{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,0ffh,0ffh	; 6c00  {{{{{{{{{{{{{{..
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch	; 6c10  ................
	defb 07ch,03ch,01ch,00ch,004h,0ffh,0ffh,0ffh,03fh,03fh,01fh,00fh,007h,003h,001h,0ffh	; 6c20  |<......??......
	defb 03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 6c30  ????????........
	defb 000h,000h,07fh,07fh,000h,000h,07fh,07fh,000h,000h,07fh,07fh,070h,070h,07fh,07fh	; 6c40  ............pp..
	defb 0e0h,0e0h,0f8h,0f8h,0e0h,0e0h,0f8h,0f8h,0e0h,0e0h,0f8h,0f8h,0e0h,0e0h,0e0h,0e0h	; 6c50  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0f8h,0f8h	; 6c60  ................
	defb 038h,038h,038h,038h,038h,038h,038h,038h,038h,038h,038h,038h,078h,078h,000h,000h	; 6c70  888888888888xx..
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0ffh,0ffh,007h,007h,007h,007h,03fh,03fh	; 6c80  ..............??
	defb 00eh,00eh,03fh,03fh,00eh,00eh,00eh,00eh,00eh,00eh,00eh,00eh,00eh,00eh,00eh,00eh	; 6c90  ..??............
	defb 000h,000h,0feh,0feh,000h,000h,000h,000h,0f8h,0f8h,000h,000h,000h,000h,0f8h,0f8h	; 6ca0  ................
	defb 03ch,03ch,03ch,03ch,03ch,03ch,03ch,03ch,03ch,03ch,000h,000h,03ch,03ch,03ch,03ch	; 6cb0  <<<<<<<<<<..<<<<
	defb 0deh,0deh,0deh,0deh,0deh,0deh,0deh,0deh,0deh,0deh,0deh,0deh,0deh,0deh,0ffh,0ffh	; 6cc0  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fah,0fah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,05fh,05fh	; 6cd0  ..............__
	defb 000h,000h,000h,000h,000h,000h,000h,0e0h,01fh,03fh,000h,000h,000h,000h,000h,000h	; 6ce0  .........?......
	defb 0ffh,0ffh,000h,000h,000h,000h,000h,000h,0f8h,0fch,000h,000h,000h,000h,000h,000h	; 6cf0  ................
	defb 000h,002h,00eh,01eh,03eh,03eh,07eh,000h,07eh,0ffh,0ffh,0ffh,0ffh,0c0h,08bh,000h	; 6d00  ....>>~.~.......
	defb 000h,040h,070h,078h,07ch,07ch,03eh,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6d10  .@px||>.........
	defb 07eh,0feh,0feh,0feh,0fch,0fah,0fah,072h,07bh,07ch,07eh,0ffh,0ffh,0f9h,0f2h,0e3h	; 6d20  ~......r{|~.....
	defb 06eh,03fh,04fh,067h,03fh,05fh,07fh,03eh,000h,000h,000h,000h,000h,000h,000h,000h	; 6d30  n?Og?_.>........
	defb 000h,06eh,02eh,02eh,01eh,006h,002h,000h,000h,09ah,0bbh,03bh,07bh,07bh,0fbh,07eh	; 6d40  .n.........;{{.~
	defb 000h,05eh,06ch,07ch,038h,030h,040h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6d50  .^l|80@.........
	defb 007h,003h,001h,001h,001h,001h,001h,007h,0ffh,0ffh,000h,07fh,05fh,07fh,000h,0ffh	; 6d60  ............_...
	defb 0ffh,0ffh,000h,07eh,07ah,07eh,000h,0ffh,0e0h,0c0h,080h,080h,080h,080h,080h,0e0h	; 6d70  ...~z~..........
	defb 0ffh,07fh,07fh,07fh,07fh,07fh,07fh,07fh,0ffh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 6d80  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 6d90  ................
	defb 07fh,07fh,07fh,07fh,07fh,07fh,07fh,07fh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 6da0  ................
	defb 000h,000h,000h,000h,000h,03ch,042h,0ffh,020h,040h,040h,040h,040h,001h,000h,001h	; 6db0  .....<B. @@@@...
	defb 04fh,04fh,07fh,07fh,07fh,07fh,07fh,07fh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 6dc0  OO..............
	defb 07fh,07fh,07fh,07fh,07fh,07fh,07fh,07fh,0f2h,0f2h,0feh,0feh,0feh,0feh,0feh,0feh	; 6dd0  ................
	defb 080h,080h,080h,080h,080h,07fh,07fh,0ffh,001h,001h,001h,001h,001h,0feh,0feh,0ffh	; 6de0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,001h,0ffh,042h,03ch,000h,000h,000h,000h	; 6df0  ..........B<....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6e00  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6e10  ................
	defb 000h,000h,010h,01ch,00eh,00eh,006h,000h,018h,01ch,00ch,07fh,03fh,00ch,00dh,0ffh	; 6e20  ............?...
	defb 030h,014h,0feh,0ffh,098h,07ah,0ffh,0ffh,001h,03fh,01fh,00fh,00eh,00eh,00eh,08eh	; 6e30  0....z...?......
	defb 080h,0e0h,070h,070h,000h,000h,000h,000h,07fh,000h,01fh,03fh,07fh,078h,030h,0b4h	; 6e40  ..pp.......?.x0.
	defb 0c0h,0f8h,0feh,0ffh,0c7h,0c3h,0d3h,0dbh,00fh,00fh,00eh,00eh,00eh,00eh,00fh,00fh	; 6e50  ................
	defb 001h,003h,013h,036h,01eh,01eh,01ch,00ch,036h,037h,033h,022h,020h,060h,040h,080h	; 6e60  ...6....673" `@.
	defb 0fbh,0fbh,0d3h,003h,003h,01bh,00fh,007h,00eh,01ch,01ch,01ch,018h,018h,030h,060h	; 6e70  ..............0`
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6e80  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6e90  ................
	defb 0f8h,0fch,09eh,00eh,00fh,007h,007h,077h,000h,000h,000h,018h,00ch,00ch,00fh,01fh	; 6ea0  .......w........
	defb 007h,007h,003h,001h,0e1h,0f9h,07fh,07fh,003h,081h,0b1h,0f8h,0f8h,0fch,0f8h,0e0h	; 6eb0  ................
	defb 0f7h,0ffh,08fh,007h,007h,077h,0ffh,08fh,07fh,03eh,01ch,00ch,00ch,00dh,00fh,00fh	; 6ec0  .....w...>......
	defb 03ch,038h,038h,033h,037h,07fh,07fh,07dh,0e0h,060h,060h,070h,030h,0b0h,0b8h,0b8h	; 6ed0  <8837..}.``p0...
	defb 007h,007h,007h,027h,01fh,00fh,00eh,006h,01eh,07eh,03eh,01ch,001h,003h,003h,006h	; 6ee0  ...'.....~>.....
	defb 069h,061h,0c3h,0c3h,08fh,007h,003h,003h,0d8h,0d8h,0dch,09fh,09fh,00fh,00fh,007h	; 6ef0  ia..............
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6f00  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6f10  ................
	defb 0c0h,0c0h,0e0h,0e0h,0e0h,040h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6f20  .....@..........
	defb 000h,000h,000h,000h,000h,000h,003h,001h,0cch,0cch,065h,000h,00fh,0feh,0ech,0cdh	; 6f30  ..........e.....
	defb 000h,000h,000h,000h,001h,083h,083h,0c1h,01fh,07fh,0fch,0f6h,0e7h,0c3h,083h,083h	; 6f40  ................
	defb 0e1h,0f0h,0f8h,038h,01ch,01ch,00eh,00eh,0dfh,0ffh,0fch,0cdh,0dfh,07fh,07ch,00dh	; 6f50  ...8..........|.
	defb 0c1h,0e1h,0e1h,0c1h,0c0h,0c0h,080h,000h,083h,087h,086h,0ceh,0deh,0fch,0f8h,060h	; 6f60  ...............`
	defb 00eh,00eh,00eh,00ch,01ch,018h,038h,060h,01fh,0ffh,07eh,06ch,00ch,00ch,00ch,00ch	; 6f70  ......8`..~l....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6f80  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6f90  ................
	defb 060h,0e3h,003h,0c3h,0c1h,0c1h,0c3h,0dfh,00eh,00fh,087h,091h,0bch,0feh,0ffh,0e6h	; 6fa0  `...............
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 6fb0  ................
	defb 0dfh,0cfh,0cch,0c0h,0c0h,080h,000h,000h,0c0h,0cch,0ech,0feh,0fch,078h,078h,0f0h	; 6fc0  .............xx.
	defb 080h,0c0h,0c0h,0e0h,0e0h,0e0h,0e0h,061h,00ch,00eh,00eh,007h,007h,003h,003h,007h	; 6fd0  .......a........
	defb 0c0h,0c1h,081h,003h,007h,00eh,018h,020h,0f6h,0f6h,0f6h,0bch,03ch,03ch,03ch,018h	; 6fe0  ....... ....<<<.
	defb 073h,07fh,03eh,03eh,03eh,03ch,01ch,008h,007h,00fh,006h,000h,000h,000h,000h,000h	; 6ff0  s.>>><..........
	defb 0f0h,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h	; 7000  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7010  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h,0f0h,0f0h	; 7020  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7030  ................
	defb 0f0h,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h	; 7040  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7050  ................
	defb 0f0h,0f0h,0ffh,0ffh,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh,0ffh,0f0h	; 7060  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7070  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7080  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7090  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 70a0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 70b0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 70c0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 70d0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 70e0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 70f0  ................
	defb 0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7100  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7110  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h	; 7120  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7130  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h	; 7140  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7150  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7160  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7170  ................
	defb 0bfh,0bfh,080h,080h,080h,060h,060h,060h,04fh,0b4h,04fh,080h,080h,090h,090h,0a0h	; 7180  .....```O.O.....
	defb 04fh,0b4h,04fh,08fh,08fh,09fh,09fh,0a0h,0bfh,0bfh,080h,080h,080h,060h,060h,060h	; 7190  O.O..........```
	defb 04fh,0b4h,04fh,080h,080h,090h,090h,0a0h,04fh,0b4h,04fh,08fh,08fh,09fh,09fh,0a0h	; 71a0  O.O.....O.O.....
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 71b0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 71c0  ................
	defb 0b0h,0a9h,06fh,08fh,08fh,09fh,09fh,0a0h,0e0h,0e0h,0e0h,0f0h,0e0h,0e0h,0e0h,0f0h	; 71d0  ..o.............
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,09fh	; 71e0  ................
	defb 074h,074h,074h,074h,074h,074h,074h,074h,060h,060h,060h,06fh,06fh,06fh,0f0h,060h	; 71f0  tttttttt```ooo.`
	defb 060h,06fh,06fh,080h,086h,080h,098h,086h,060h,060h,060h,096h,080h,08fh,060h,096h	; 7200  `oo.....```...`.
	defb 08fh,096h,096h,098h,096h,060h,096h,06fh,086h,086h,080h,096h,086h,09fh,096h,086h	; 7210  .....`.o........
	defb 0f0h,0f0h,0f0h,0f7h,0f7h,070h,0f7h,070h,0f0h,0f0h,0f7h,0f7h,070h,0f7h,070h,070h	; 7220  .....p.p....p.pp
	defb 0f7h,07fh,075h,0f7h,0f7h,07fh,075h,07fh,0f7h,075h,07fh,0f7h,075h,07fh,075h,07fh	; 7230  ..u...u..u..u.u.
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7240  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7250  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7260  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7270  ................
	defb 0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0f0h	; 7280  ................
	defb 06fh,06fh,0f0h,0f0h,0f0h,0f0h,0f0h,06fh,06fh,06fh,0f0h,0f0h,0f0h,0f0h,0f0h,06fh	; 7290  oo.....ooo.....o
	defb 0e0h,0e0h,0e0h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0e0h,0efh,0e0h,0e0h	; 72a0  ................
	defb 0a0h,090h,09fh,08fh,08fh,06fh,060h,060h,0a0h,090h,090h,080h,080h,060h,060h,060h	; 72b0  .....o``.....```
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 72c0  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0efh,0efh,0efh,0ffh,0ffh,0ffh,0ffh,0ffh	; 72d0  ................
	defb 040h,04fh,04fh,04fh,04fh,04fh,04fh,040h,040h,040h,040h,040h,040h,040h,040h,040h	; 72e0  @OOOOOO@@@@@@@@@
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 72f0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh,0ffh,0ffh,0f0h,0f0h,0f0h	; 7300  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,060h,060h,060h,060h,060h,060h,060h,060h	; 7310  ........````````
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h,0f0h	; 7320  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,060h,060h,060h,060h,060h,060h,060h,060h	; 7330  ........````````
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7340  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0e0h,0e0h,0f0h,0f0h,0f0h,0f0h,050h,0e0h	; 7350  ..............P.
	defb 060h,060h,090h,090h,090h,090h,0f0h,060h,060h,0f0h,090h,090h,090h,090h,060h,060h	; 7360  ``.....``.....``
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0c6h,0c6h,0c6h,0e0h,050h,0f0h,0f0h,0f0h,0f0h,0e0h,0e0h	; 7370  .........P......
	defb 06fh,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,06fh,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; 7380  o.......o.......
	defb 0f0h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f0h,0b0h,0b0h,0bfh,0f0h,0fbh,0f6h,0fbh	; 7390  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; 73a0  ................
	defb 0f7h,0f7h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f6h,0bfh,0e6h,0bfh,0e6h,0bfh,0b0h,0b0h	; 73b0  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0c6h,0c6h,0c6h,0f6h,0f6h,0f6h,0f6h,0f6h,0c6h,0c6h,0c6h	; 73c0  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0c6h,0c6h,0c6h,0f6h,0f6h,0f6h,0f6h,0f6h,0c6h,0c6h,0c6h	; 73d0  ................
	defb 064h,064h,064h,064h,064h,0f6h,0f6h,06fh,064h,064h,064h,064h,064h,0f6h,0f6h,06fh	; 73e0  ddddd..oddddd..o
	defb 050h,050h,070h,070h,070h,070h,050h,0d0h,0d0h,050h,070h,070h,070h,070h,050h,050h	; 73f0  PPppppP..PppppPP
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0efh,0efh,0e0h,0f0h,0e0h,0f0h,0e0h,0f0h,0efh,0efh	; 7400  ................
	defb 0afh,0afh,0a0h,0a0h,0a0h,0a0h,0a0h,06fh,0f0h,0f0h,0f0h,0f0h,0f0h,0c0h,0c0h,0c0h	; 7410  .......o........
	defb 0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0afh,0f0h,06fh,06fh,06fh,0f0h,06fh,06fh,0f0h	; 7420  .........ooo.oo.
	defb 0a0h,0a0h,060h,060h,0a0h,0a0h,060h,060h,0a0h,0a0h,060h,060h,0a0h,0a0h,060h,060h	; 7430  ..``..``..``..``
	defb 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h	; 7440  ````````````````
	defb 0a0h,0a0h,060h,060h,0a0h,0a0h,060h,060h,0a0h,0a0h,060h,060h,0a0h,0a0h,060h,060h	; 7450  ..``..``..``..``
	defb 0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0afh,0afh,0afh,0afh,0afh,0afh,0afh,0afh	; 7460  ................
	defb 0f0h,0efh,0efh,0efh,0efh,0efh,0efh,0f0h,060h,060h,060h,060h,060h,060h,060h,060h	; 7470  ........````````
	defb 0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,080h,080h,080h,080h,080h,080h,080h,080h	; 7480  ................
	defb 0b0h,0b0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h	; 7490  ................
	defb 080h,080h,080h,080h,080h,080h,080h,080h,0b0h,0b0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 74a0  ................
	defb 0f0h,0f0h,0f0h,0f0h,030h,0c0h,0c3h,0c0h,030h,030h,0c0h,030h,0c0h,0c0h,0c0h,0f0h	; 74b0  ....0...00.0....
	defb 0cfh,0c0h,0f0h,0f0h,0c0h,0c0h,060h,060h,0c0h,0c0h,0c0h,0c0h,0cfh,0c0h,0c0h,0f0h	; 74c0  ......``........
	defb 0e0h,0e0h,0e0h,0f0h,0e0h,0e0h,0e0h,0f0h,030h,0c0h,0c0h,030h,0c0h,0c0h,0c0h,0f0h	; 74d0  ........0..0....
	defb 06fh,06fh,06fh,0f0h,060h,060h,060h,060h,060h,060h,0f0h,060h,0f0h,060h,060h,060h	; 74e0  ooo.``````.`.```
	defb 0e0h,0e0h,0e0h,0f0h,0e0h,0e0h,0e0h,0f0h,0e0h,0e0h,0e0h,0f0h,0e0h,0e0h,0e0h,0f0h	; 74f0  ................
	defb 0f0h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,0f0h,060h,0f0h	; 7500  .````````````.`.
	defb 060h,0c0h,0c0h,0c6h,0c6h,0c6h,0c6h,0cfh,0f0h,0f0h,0f0h,0f0h,060h,060h,0c0h,0c0h	; 7510  `...........``..
	defb 030h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0f0h,030h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h	; 7520  0.......0.......
	defb 0c0h,0cfh,0cfh,0c6h,060h,060h,060h,060h,0c0h,0c0h,0c0h,0c0h,0c0h,0f0h,0c0h,0c0h	; 7530  ....````........
	defb 060h,060h,060h,06fh,06fh,060h,060h,060h,0c0h,0c0h,0c0h,0c0h,0f0h,060h,060h,060h	; 7540  ```oo```.....```
	defb 0c0h,0c3h,0c0h,0c0h,0c0h,0cfh,0c0h,0c0h,0f0h,0f0h,030h,0c0h,0c0h,0c0h,0c0h,0c0h	; 7550  ..........0.....
	defb 060h,060h,060h,060h,060h,060h,060h,060h,0c0h,0c0h,0c0h,0c0h,0f0h,0f0h,0f0h,0f0h	; 7560  ````````........
	defb 060h,060h,06fh,06fh,060h,060h,060h,060h,0f0h,060h,060h,060h,060h,060h,060h,060h	; 7570  ``oo````.```````
	defb 040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h	; 7580  @@@@@@@@@@@@@@@@
	defb 04fh,04fh,04fh,04fh,04fh,0f0h,04fh,0f0h,040h,040h,040h,040h,040h,0f0h,0f4h,0f0h	; 7590  OOOOO.O.@@@@@...
	defb 030h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,030h,0c0h,0c0h	; 75a0  0............0..
	defb 0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0f0h,0f0h,0efh,0efh,07fh,07fh,07fh,07fh,07fh,07fh	; 75b0  ................
	defb 0efh,0efh,041h,041h,071h,01fh,01fh,07fh,0efh,0efh,074h,074h,074h,074h,074h,07fh	; 75c0  ..AAq.....ttttt.
	defb 041h,041h,041h,041h,041h,041h,041h,041h,01fh,041h,041h,041h,041h,041h,041h,041h	; 75d0  AAAAAAAA.AAAAAAA
	defb 0c3h,0cfh,0c0h,0cfh,0c0h,0c0h,0f0h,0f0h,030h,0f0h,0c0h,030h,0c0h,0c6h,0c0h,0c0h	; 75e0  ........0..0....
	defb 0f0h,0f0h,0c0h,0c0h,0c0h,0c0h,0c0h,0cfh,0f0h,030h,030h,030h,0c0h,030h,0c0h,0c0h	; 75f0  .........000.0..
	defb 074h,074h,074h,074h,074h,074h,074h,074h,060h,060h,070h,070h,070h,070h,070h,070h	; 7600  tttttttt``pppppp
	defb 0f6h,0f6h,07fh,07fh,07fh,0ffh,0ffh,0ffh,060h,060h,070h,070h,070h,070h,070h,070h	; 7610  ........``pppppp
	defb 0a0h,0a0h,0b0h,0b0h,0b0h,0b0h,0a0h,0c0h,070h,070h,070h,070h,070h,070h,070h,070h	; 7620  ........pppppppp
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,070h,070h,070h,070h,070h,070h,070h,070h	; 7630  ........pppppppp
	defb 0c0h,0a0h,0b0h,0b0h,0b0h,0b0h,0a0h,0a0h,0c0h,0c0h,030h,030h,030h,030h,0c0h,070h	; 7640  ..........0000.p
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,070h,0c0h,030h,030h,030h,030h,0c0h,0c0h	; 7650  ........p.0000..
	defb 0b0h,0b0h,0d0h,0d0h,0d0h,0d0h,070h,0d0h,070h,070h,070h,070h,070h,070h,060h,060h	; 7660  ......p.pppppp``
	defb 0f0h,0f0h,0ffh,07fh,07fh,07fh,06fh,06fh,070h,070h,070h,070h,070h,070h,060h,060h	; 7670  ......oopppppp``
	defb 080h,080h,060h,060h,0f0h,0f0h,0f0h,0f0h,0f8h,0f8h,06fh,06fh,0f0h,0f0h,0f0h,0f0h	; 7680  ..``......oo....
	defb 080h,080h,060h,060h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7690  ..``............
	defb 0f0h,0f0h,0f0h,0b0h,0b0h,0b0h,0b0h,0b0h,0f0h,0f0h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 76a0  ................
	defb 0d0h,070h,0d0h,0d0h,0d0h,0d0h,0b0h,0b0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 76b0  .p..............
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 76c0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 76d0  ................
	defb 0c0h,0c0h,0c0h,0cfh,0c0h,0c0h,0f0h,060h,0c0h,0c0h,0c0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 76e0  .......`........
	defb 0c0h,0c0h,0c0h,0f0h,0f0h,0f0h,0f0h,0f0h,060h,060h,060h,060h,0f0h,0f0h,0f0h,0f0h	; 76f0  ........````....
	defb 0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h	; 7700  ................
	defb 0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h	; 7710  ................
	defb 0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h	; 7720  ................
	defb 0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h	; 7730  ................
	defb 0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0bfh,0bfh,0bfh	; 7740  ................
	defb 0b0h,0b0h,0b0h,0b0h,0b0h,0bfh,0bfh,0bfh,0b0h,0b0h,0b0h,0b0h,0b0h,0bfh,0bfh,0bfh	; 7750  ................
	defb 0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0bfh,0bfh,0bfh,0b0h,0b0h,0b0h,0b0h,0b0h	; 7760  ................
	defb 0bfh,0bfh,0bfh,0b0h,0b0h,0b0h,0b0h,0b0h,0bfh,0bfh,0bfh,0b0h,0b0h,0b0h,0b0h,0b0h	; 7770  ................
	defb 040h,040h,040h,040h,040h,040h,040h,040h,050h,050h,0b0h,0bfh,0b0h,0b0h,0b0h,0b0h	; 7780  @@@@@@@@PP......
	defb 0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h	; 7790  ................
	defb 090h,090h,090h,090h,090h,090h,090h,090h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 77a0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,060h,060h,060h,060h,060h,060h,060h,060h	; 77b0  ........````````
	defb 060h,060h,060h,060h,060h,060h,060h,060h,0f0h,0f0h,0f0h,0f0h,0f0h,060h,060h,0f0h	; 77c0  ````````.....``.
	defb 0f0h,060h,060h,060h,060h,060h,060h,060h,060h,060h,06fh,06fh,060h,060h,060h,060h	; 77d0  .`````````oo````
	defb 0f0h,0f0h,060h,0a0h,0b0h,0e0h,0e0h,070h,040h,070h,0e0h,0e0h,0b0h,0a0h,060h,0f0h	; 77e0  ..`....p@p....`.
	defb 040h,040h,04fh,0b4h,0b4h,0b4h,040h,040h,090h,090h,090h,0b9h,0b9h,0b9h,090h,090h	; 77f0  @@O...@@........
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7800  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0f0h	; 7810  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7820  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7830  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7840  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7850  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7860  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7870  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7880  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7890  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 78a0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 78b0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 78c0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 78d0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 78e0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 78f0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7900  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7910  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7920  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7930  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7940  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7950  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7960  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7970  ................
	defb 040h,040h,040h,040h,040h,050h,0f0h,0f0h,04fh,04fh,04fh,04fh,04fh,05fh,040h,040h	; 7980  @@@@@P..OOOOO_@@
	defb 04fh,04fh,04fh,04fh,05fh,0f0h,040h,040h,04fh,04fh,04fh,04fh,05fh,0f0h,0f0h,040h	; 7990  OOOO_.@@OOOO_..@
	defb 04fh,04fh,04fh,04fh,05fh,0f0h,0f0h,040h,0b0h,0bfh,0b0h,0b0h,0b0h,05fh,04fh,04fh	; 79a0  OOOO_..@....._OO
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,050h,040h,040h,040h,040h,040h,040h,040h,05fh,04fh,04fh	; 79b0  .....P@@@@@@@_OO
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,05fh,04fh,04fh,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h	; 79c0  ....._OO........
	defb 0f0h,0f0h,0b0h,0f0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,05fh,04fh,04fh	; 79d0  ............._OO
	defb 040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h	; 79e0  @@@@@@@@@@@@@@@@
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,040h,040h,040h,040h,040h,040h,05fh,04fh,04fh	; 79f0  .......@@@@@@_OO
	defb 0f0h,040h,04fh,04fh,04fh,04fh,040h,040h,0f0h,0f0h,040h,040h,040h,040h,070h,070h	; 7a00  .@OOOO@@..@@@@pp
	defb 070h,070h,070h,070h,070h,0f0h,0f0h,0f0h,040h,040h,070h,070h,070h,070h,070h,070h	; 7a10  ppppp...@@pppppp
	defb 04fh,04fh,040h,040h,0f0h,070h,07fh,070h,0f0h,040h,040h,04fh,04fh,040h,0f0h,07fh	; 7a20  OO@@.p.p.@@OO@..
	defb 040h,040h,040h,04fh,04fh,04fh,0f0h,07fh,040h,040h,040h,04fh,04fh,04fh,0f0h,07fh	; 7a30  @@@OOO..@@@OOO..
	defb 040h,040h,040h,04fh,04fh,04fh,0f0h,07fh,070h,070h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7a40  @@@OOO..pp......
	defb 07fh,07fh,070h,070h,070h,0f0h,0f0h,0f0h,07fh,07fh,070h,070h,0b0h,0b0h,0b0h,0b0h	; 7a50  ..ppp.....pp....
	defb 07fh,07fh,070h,070h,0f0h,0f0h,0f0h,0bfh,0bfh,0bfh,04fh,0b0h,0b0h,0b0h,0b0h,0b0h	; 7a60  ..pp......O.....
	defb 0bfh,0bfh,0bfh,04fh,0b4h,0b4h,0b4h,0b4h,0bfh,0bfh,0bfh,04fh,07fh,07fh,0f7h,0f7h	; 7a70  ...O.......O....
	defb 0bfh,0bfh,0bfh,04fh,07fh,07fh,09fh,09fh,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h	; 7a80  ...O............
	defb 0f0h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h	; 7a90  ................
	defb 0fbh,0fbh,0fbh,0fbh,0fbh,07fh,04fh,04fh,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,04fh,04fh	; 7aa0  ......OO......OO
	defb 0f7h,0f7h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f7h,0fbh,0fbh,0fbh,0fbh,0fbh,0fbh,0bfh	; 7ab0  ................
	defb 0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,09fh,09fh,09fh,09fh,09fh,09fh,09fh,09fh	; 7ac0  ................
	defb 097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h	; 7ad0  ................
	defb 097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h,097h	; 7ae0  ................
	defb 07fh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,07fh,04fh,04fh	; 7af0  ..............OO
	defb 040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h	; 7b00  @@@@@@@@@@@@@@@@
	defb 040h,040h,040h,040h,040h,040h,040h,040h,097h,097h,097h,097h,097h,097h,097h,097h	; 7b10  @@@@@@@@........
	defb 0b0h,0b0h,0b0h,0b0h,0b0h,05fh,04fh,04fh,0f0h,0f0h,0b0h,0f0h,0b0h,0b0h,0b0h,0b0h	; 7b20  ....._OO........
	defb 0b0h,0bfh,0b0h,0b0h,0b0h,05fh,04fh,04fh,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h	; 7b30  ....._OO........
	defb 040h,040h,040h,040h,040h,040h,040h,040h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,040h	; 7b40  @@@@@@@@.......@
	defb 040h,040h,040h,040h,040h,050h,0f0h,0f0h,04fh,04fh,04fh,04fh,04fh,05fh,040h,040h	; 7b50  @@@@@P..OOOOO_@@
	defb 040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h	; 7b60  @@@@@@@@@@@@@@@@
	defb 040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h	; 7b70  @@@@@@@@@@@@@@@@
	defb 07fh,07fh,070h,070h,0b0h,0b0h,0b0h,0b0h,040h,040h,040h,040h,040h,040h,040h,040h	; 7b80  ..pp....@@@@@@@@
	defb 0f0h,040h,04fh,04fh,04fh,04fh,040h,040h,0f0h,0f0h,040h,040h,040h,040h,070h,070h	; 7b90  .@OOOO@@..@@@@pp
	defb 070h,070h,070h,070h,0f0h,0f0h,0f0h,0f0h,040h,040h,070h,070h,070h,070h,070h,070h	; 7ba0  pppp....@@pppppp
	defb 04fh,04fh,040h,040h,0f0h,070h,07fh,070h,0f0h,040h,040h,04fh,04fh,040h,0f0h,07fh	; 7bb0  OO@@.p.p.@@OO@..
	defb 0bfh,0bfh,04fh,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h	; 7bc0  ..O.............
	defb 0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,04fh,04fh,070h,070h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7bd0  ......OOpp......
	defb 07fh,07fh,070h,070h,070h,0f0h,0f0h,0f0h,07fh,07fh,070h,070h,0b0h,0b0h,0b0h,0b0h	; 7be0  ..ppp.....pp....
	defb 07fh,07fh,070h,070h,0f0h,0f0h,0f0h,0bfh,0bfh,0bfh,0bfh,04fh,0b4h,0b4h,0b4h,0b4h	; 7bf0  ..pp.......O....
	defb 0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,04fh,04fh	; 7c00  ..............OO
	defb 0bfh,0bfh,0bfh,04fh,07fh,07fh,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h	; 7c10  ...O............
	defb 0fbh,0fbh,0fbh,0fbh,0fbh,07fh,04fh,04fh,0f7h,0fbh,0fbh,0fbh,0fbh,0fbh,0fbh,0bfh	; 7c20  ......OO........
	defb 0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,097h,097h,097h,097h,097h,097h,097h,097h	; 7c30  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7c40  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7c50  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7c60  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7c70  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7c80  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7c90  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7ca0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7cb0  ................
	defb 0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,0b4h,04fh,04fh	; 7cc0  ..............OO
	defb 0bfh,0bfh,0bfh,04fh,07fh,07fh,0f7h,0f7h,0bfh,0bfh,0bfh,04fh,07fh,07fh,0f7h,0f7h	; 7cd0  ...O.......O....
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,040h,080h,060h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7ce0  .......@.`......
	defb 08fh,06fh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,080h,060h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7cf0  .o.......`......
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh,0ffh,0ffh,0f0h,0f0h,0f0h	; 7d00  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7d10  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h,0f0h	; 7d20  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7d30  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7d40  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7d50  ................
	defb 060h,060h,060h,060h,060h,060h,060h,060h,06fh,06fh,0f0h,0f0h,0f0h,0f0h,0f0h,06fh	; 7d60  ````````oo.....o
	defb 06fh,06fh,0f0h,0f0h,0f0h,0f0h,0f0h,06fh,060h,060h,060h,060h,060h,060h,060h,060h	; 7d70  oo.....o````````
	defb 06fh,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,06fh,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; 7d80  o.......o.......
	defb 0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 7d90  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; 7da0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0b0h,0b0h,0bfh,0f0h,0fbh,0f6h,0fbh,0f6h,0ebh,0f0h,0ebh	; 7db0  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0c6h,0c6h,0c6h,0f6h,0f6h,0f6h,0f6h,0f6h,0c6h,0c6h,0c6h	; 7dc0  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0c6h,0c6h,0c6h,0f6h,0f6h,0f6h,0f6h,0f6h,0c6h,0c6h,0c6h	; 7dd0  ................
	defb 064h,064h,064h,064h,064h,0f6h,0f6h,06fh,064h,064h,064h,064h,064h,0f6h,0f6h,06fh	; 7de0  ddddd..oddddd..o
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0e6h,0bfh,0b0h,0b0h,0f0h,0f0h,0f0h,0f0h	; 7df0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7e00  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7e10  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh	; 7e20  ................
	defb 0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7e30  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7e40  ................
	defb 0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7e50  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7e60  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7e70  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7e80  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7e90  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7ea0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7eb0  ................
	defb 0f0h,0ffh,0f0h,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7ec0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7ed0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7ee0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7ef0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7f00  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7f10  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7f20  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7f30  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7f40  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7f50  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7f60  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7f70  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7f80  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7f90  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0f0h	; 7fa0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7fb0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7fc0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7fd0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7fe0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7ff0  ................

; ======================================================================
; CODIGO 0x8000..0x8506  (1286 bytes)
; ======================================================================


arranque:		; 16 "nop" y el arranque: la RAM a cero (salvo 0xE000, que dice si esta el primer Iga: pasa a 0xE060), la interrupcion en H.TIMI (0x8CD2), SCREEN 2 en negro, las letras (0x5000), la pantalla y los sprites
	nop			;8000   ; 16 "nop": INIT salta aqui (0x4035)
	nop			;8001
	nop			;8002
	nop			;8003
	nop			;8004
	nop			;8005
	nop			;8006
	nop			;8007
	nop			;8008
	nop			;8009
	nop			;800a
	nop			;800b
	nop			;800c
	nop			;800d
	nop			;800e
	nop			;800f
	call 00041h		;8010   ; DISSCR
	ld hl,0e001h		;8013   ; la RAM: 0xE001...
	ld bc,0137fh		;8016   ; ...0x137F bytes
L_8019:
	ld (hl),000h		;8019   ; a cero
	inc hl			;801b   ; la siguiente
	dec c			;801c
	jr nz,L_8019		;801d
	djnz L_8019		;801f   ; 0x13 vueltas de 256
	ld a,(0e000h)		;8021   ; el primer Iga en otro slot?
	cp 001h		;8024   ; 1?
	jr nz,L_802B		;8026
	ld (0e060h),a		;8028   ; 0xE060 = 1
L_802B:
	xor a			;802b   ; 0xE000 = 0: sin partida
	ld (0e000h),a		;802c   ; 0xE000 a 0: sin partida
	ld sp,0f380h		;802f   ; la pila
	ld hl,08cd2h		;8032   ; la interrupcion...
	ld (0fda0h),hl		;8035   ; ...en H.TIMI...
	ld a,0c3h		;8038   ; ...con su "jp"
	ld (0fd9fh),a		;803a   ; ...0xFD9F
	call 0007eh		;803d   ; SETGRP: SCREEN 2
	xor a			;8040   ; fondo y borde negros...
	ld (0f3eah),a		;8041   ; BAKCLR = 0
	ld (0f3ebh),a		;8044   ; BDRCLR = 0
	dec a			;8047   ; ...letras blancas (0xFF)
	ld (0f3e9h),a		;8048   ; FORCLR = 0xFF
	call 00062h		;804b   ; CHGCLR
	ld de,00000h		;804e   ; las letras propias (0x5000) en los tres tercios
	ld b,003h		;8051   ; tres tercios
init_letras:
	call letras_pon		;8053   ; las letras
	djnz init_letras		;8056
	xor a			;8058   ; los colores de 0x80 casillas a 0...
	ld hl,00080h		;8059   ; desde la casilla 0x10
	ld b,003h		;805c   ; ...en los tres tercios
L_805E:
	call colores_ocho		;805e   ; 8 bytes de colores
	djnz L_805E		;8061
	ld hl,02000h		;8063   ; los colores de las casillas 0x400-0x1BFF...
	ld bc,01800h		;8066   ; 0x1800 bytes
	ld a,0f0h		;8069   ; ...blanco sobre negro
	call 00056h		;806b   ; FILVRM
	call sprites_dibujos		;806e   ; los dibujos de los sprites
	ld hl,0fbf0h		;8071   ; el buffer del teclado vacio
	ld (0f3f8h),hl		;8074   ; GETPNT = PUTPNT: nada en el buffer
	ld (0f3fah),hl		;8077   ; PUTPNT
	ld a,0a2h		;807a   ; el registro 1 a 0xA2: la pantalla apagada, sprites de 16 x 16
	ld b,a			;807c   ; el valor
	ld c,001h		;807d   ; el registro 1
	call 00047h		;807f   ; WRTVDP
	ld a,001h		;8082   ; 0xE030 = 1
	ld (0e030h),a		;8084   ; 0xE030 = 1
	ld a,010h		;8087   ; 0xE035 = 0x10
	ld (0e035h),a		;8089
	ei			;808c   ; con interrupciones
titulo:		; El titulo: la presentacion de CASIO; las teclas BS (0xE023 = 1) y 2, A, I y G a la vez (0xE039 = 2); CASIO, el nombre, COPYRIGHT, GAME START y PUSH TRIG:1 OR SPACE; los colores del nombre cambian cada 4 cuadros (0xE037 recorre la ROM desde 0x3000); con el boton, la partida; a los 0xF0 cuadros (0xE018), la demostracion
	call sonido_reinicia		;808d   ; el sonido a cero
	call pantalla_limpia		;8090   ; la pantalla a cero
	call casillas_titulo		;8093   ; las casillas del titulo
	call 00044h		;8096   ; ENASCR
	call presentacion		;8099   ; la presentacion de CASIO
	ld a,007h		;809c   ; la fila 7...
	call 00141h		;809e   ; SNSMAT
	bit 5,a		;80a1   ; BS (bit 5)?
	jr nz,L_80AA		;80a3   ; suelta
	ld a,001h		;80a5   ; pulsada: 0xE023 = 1
	ld (0e023h),a		;80a7   ; BS: 0xE023 = 1
L_80AA:
	xor a			;80aa   ; la fila 0: el 2 (bit 2)?
	call 00141h		;80ab   ; SNSMAT
	bit 2,a		;80ae   ; el 2?
	jr nz,L_80CD		;80b0
	ld a,002h		;80b2   ; la fila 2: la A (bit 6)?
	call 00141h		;80b4   ; SNSMAT
	bit 6,a		;80b7   ; la A?
	jr nz,L_80CD		;80b9
	ld a,003h		;80bb   ; la fila 3: la I (bit 6)?
	call 00141h		;80bd   ; SNSMAT
	bit 6,a		;80c0   ; la I?
	jr nz,L_80CD		;80c2
	bit 4,a		;80c4   ; y la G (bit 4)?
	jr nz,L_80CD		;80c6   ; la G?
	ld a,002h		;80c8   ; las cuatro: 0xE039 = 2
	ld (0e039h),a		;80ca   ; las cuatro: 0xE039 = 2
L_80CD:
	ld a,001h		;80cd   ; 0xE051 = 1
	ld (0e051h),a		;80cf   ; la posicion 1
	call 00044h		;80d2   ; ENASCR
	ld hl,08f79h		;80d5   ; el nombre en casillas (0x8F79): dos filas de 10...
	ld de,018cbh		;80d8   ; la fila 6, columna 11
	ld bc,0000ah		;80db
	call 0005ch		;80de   ; LDIRVM
	ex de,hl			;80e1   ; el siguiente trozo
	ld de,018ebh		;80e2   ; la fila 7
	ld bc,0000ah		;80e5
	call 0005ch		;80e8   ; LDIRVM
	ex de,hl			;80eb
	ld de,01928h		;80ec   ; ...y tres de 16
	ld bc,00010h		;80ef   ; 16 casillas
	call 0005ch		;80f2   ; LDIRVM
	ex de,hl			;80f5
	ld de,01948h		;80f6   ; la fila 10
	ld bc,00010h		;80f9
	call 0005ch		;80fc   ; LDIRVM
	ex de,hl			;80ff
	ld de,01968h		;8100   ; la fila 11
	ld bc,00010h		;8103
	call 0005ch		;8106   ; LDIRVM
	ld hl,09030h		;8109   ; CASIO (0x9030) en la fila 4
	ld de,0188dh		;810c   ; la fila 4, columna 13
	ld bc,00006h		;810f
	call 0005ch		;8112   ; LDIRVM
	ld hl,09049h		;8115   ; PUSH TRIG:1 OR SPACE (0x9049) en la fila 20
	ld de,01a86h		;8118   ; la fila 20, columna 6
	ld bc,00014h		;811b
	call 0005ch		;811e   ; LDIRVM
	ld hl,0905dh		;8121   ; COPYRIGHT 1986 (c) CASIO (0x905D) en la fila 16
	ld de,01a05h		;8124   ; la fila 16, columna 5
	ld bc,00016h		;8127
	call 0005ch		;812a   ; LDIRVM
	ld de,01a4bh		;812d   ; GAME START (0x9026) en la fila 18
	ld hl,09026h		;8130   ; GAME START
	ld bc,0000ah		;8133
	call 0005ch		;8136   ; LDIRVM
	ld de,03000h		;8139   ; los colores salen de 0x3000...
	ld (0e037h),de		;813c   ; el puntero de los colores
	xor a			;8140   ; la cuenta del titulo a 0
	ld (0e018h),a		;8141   ; la cuenta del titulo
titulo_bucle:
	ld a,(0e018h)		;8144   ; 0xF0 cuadros?
	cp 0f0h		;8147   ; 0xF0?
	jp nc,demo_empieza		;8149   ; la demostracion
	ld a,(0e011h)		;814c   ; 4 cuadros?
	cp 004h		;814f   ; cuatro?
	jr c,L_8187		;8151   ; aun no
	xor a			;8153   ; la cuenta a 0
	ld (0e011h),a		;8154
	ld hl,0e800h		;8157   ; 512 colores en 0xE800
	ld bc,00200h		;815a   ; 512 bytes
	ld de,(0e037h)		;815d   ; desde 0xE037
titulo_color:		; Un byte: su mitad alta es el color (0x20 o mas); si no, 0x60
	ld a,(de)			;8161   ; un byte de la BIOS
	and 0f0h		;8162   ; su mitad alta
	cp 020h		;8164   ; 0x20 o mas?
	jr nc,titulo_color_pon		;8166
	ld a,060h		;8168   ; si no, 0x60
titulo_color_pon:
	ld (hl),a			;816a   ; el color
	inc hl			;816b
	inc de			;816c
	dec c			;816d   ; uno menos
	jr nz,titulo_color		;816e
	djnz titulo_color		;8170   ; dos vueltas de 256
	ld hl,0e800h		;8172   ; los 512 colores...
	ld de,02a00h		;8175   ; ...en el tercer tercio (0x2A00)
	ld bc,00200h		;8178
	call 0005ch		;817b   ; LDIRVM
	ld de,(0e037h)		;817e   ; la proxima vez, un byte mas alla
	inc de			;8182
	ld (0e037h),de		;8183   ; apuntado
L_8187:
	ld a,(0e026h)		;8187   ; el boton?
	and a			;818a
	jr z,titulo_bucle		;818b   ; no: el titulo sigue
	xor a			;818d
	ld (0e026h),a		;818e   ; el boton, gastado
	jr partida_empieza		;8191   ; la partida
demo_empieza:		; La demostracion: sin partida, las cuentas y la fase a 0, 0xE058-0xE05F a 0x10; la lista de mandos en 0x7F00 (0xE037)
	ld a,001h		;8193   ; 0xE00A = 1...
	ld (0e00ah),a		;8195   ; 0xE00A = 1
	xor a			;8198   ; las cuentas...
	ld (0e19fh),a		;8199   ; 0xE19F = 0
	ld (0e023h),a		;819c   ; sin trucos: BS...
	ld (0e028h),a		;819f
	ld (0e027h),a		;81a2   ; ...sin demostracion aun...
	ld (0e00ah),a		;81a5   ; ...y otra vez a 0: la fase 0
	ld (0e039h),a		;81a8   ; ...ni 2, A, I y G
	ld (0e055h),a		;81ab
	ld (0e056h),a		;81ae
	ld (0e057h),a		;81b1
	ld hl,07f00h		;81b4   ; la lista de mandos de la demostracion: 0x7F00
	ld (0e037h),hl		;81b7   ; en 0xE037
	ld hl,0e058h		;81ba   ; 0xE058-0xE05F...
	ld b,008h		;81bd   ; ocho
L_81BF:
	ld (hl),010h		;81bf   ; ...a 0x10
	inc hl			;81c1
	djnz L_81BF		;81c2   ; los ocho
	jp fase_empieza		;81c4   ; a la fase
partida_empieza:		; Una partida: jugando (0xE000 = 1), cuatro vidas, los puntos a cero, 0xE058-0xE05F a 0x10
	xor a			;81c7   ; a cero:
	ld (0e026h),a		;81c8   ; los botones...
	ld (0e027h),a		;81cb   ; ...sin demostracion...
	ld (0e028h),a		;81ce
	ld (0e00ah),a		;81d1   ; ...la fase 0...
	ld (0e009h),a		;81d4   ; la vuelta 0
	ld (0e03ah),a		;81d7   ; 0xE03A = 0
	ld (0e19fh),a		;81da
	ld (0e053h),a		;81dd   ; 0xE053 = 0
	inc a			;81e0   ; 1
	ld (0e000h),a		;81e1   ; 0xE000 = 1
	ld a,004h		;81e4   ; 4 vidas
	ld (0e00bh),a		;81e6   ; en 0xE00B
	ld hl,0e001h		;81e9   ; los puntos (0xE001-0xE006) a cero
	ld b,006h		;81ec   ; seis cifras
partida_borra:
	ld (hl),000h		;81ee   ; una cifra a 0
	inc hl			;81f0
	djnz partida_borra		;81f1
	xor a			;81f3   ; y los tres bytes BCD
	ld (0e00eh),a		;81f4   ; los puntos a cero
	ld (0e00dh),a		;81f7   ; los puntos a cero
	ld (0e00ch),a		;81fa
	ld (0e055h),a		;81fd
	ld (0e056h),a		;8200
	ld (0e057h),a		;8203
	ld hl,0e058h		;8206   ; 0xE058-0xE05F...
	ld b,008h		;8209   ; ocho
L_820B:
	ld (hl),010h		;820b   ; ...a 0x10
	inc hl			;820d   ; el siguiente
	djnz L_820B		;820e
fase_empieza:		; La fase (0xE00A): la pantalla y el marcador; la posicion 0xE051 (la 1 desde la fase 2) en 0xE195 (x 32); el ninja (0xE300: dos sprites, dibujos 0x28 y 0x2C, colores 5 y 11); en la fase 6 otras casillas (0x6980, 0x7980); la musica 2; su sitio de salida: en la fase 0 con el primer Iga, Y 0xA0; si no, 0x70; en la 6, 0x88; desde la 2, una entrada en tres pasos (0xE1B0)
	ld a,(0e00ah)		;8210   ; la fase...
	ld (0e050h),a		;8213   ; ...en 0xE050
	ld a,(0e00ah)		;8216   ; la fase...
	cp 002h		;8219   ; desde la 2...
	jr c,L_8222		;821b   ; la 0 o la 1: la posicion de antes
	ld a,001h		;821d   ; ...la posicion 1
	ld (0e051h),a		;821f   ; la posicion 1
L_8222:
	call pantalla_limpia		;8222   ; la pantalla a cero
	call marcador_pon		;8225   ; el marcador
	ld a,(0e051h)		;8228   ; la posicion...
	dec a			;822b   ; la posicion - 1...
	jr z,L_823B		;822c   ; la 1: 0
	ld b,a			;822e
	ld hl,00000h		;822f   ; ...veces 32
	ld de,00020h		;8232   ; ...x 32
L_8235:
	add hl,de			;8235   ; 32 mas
	djnz L_8235		;8236
	ld (0e195h),hl		;8238   ; en 0xE195
L_823B:
	ld a,r		;823b   ; al azar, 1-4...
	and 003h		;823d   ; 0-3...
	inc a			;823f   ; ...1-4: la cuenta de cofres
	ld (0e1c7h),a		;8240   ; ...en 0xE1C7
	ld ix,0e300h		;8243   ; el ninja
	ld a,(0e00ah)		;8247   ; la fase 6?
	cp 006h		;824a   ; la fase 6?
	jr nz,fase_ninja		;824c   ; no
	ld hl,06980h		;824e   ; sus casillas: 0x6980 en los tres tercios...
	ld de,00280h		;8251   ; a las casillas 0x50-0xBF del primer tercio
	ld bc,00380h		;8254
	call 0005ch		;8257   ; LDIRVM
	ld hl,06980h		;825a
	ld de,00a80h		;825d   ; del segundo
	ld bc,00380h		;8260
	call 0005ch		;8263   ; LDIRVM
	ld hl,06980h		;8266
	ld de,01280h		;8269   ; del tercero
	ld bc,00380h		;826c
	call 0005ch		;826f   ; LDIRVM
	ld hl,07980h		;8272   ; ...y sus colores, 0x7980
	ld de,02280h		;8275   ; los colores, en el primero
	ld bc,00380h		;8278
	call 0005ch		;827b   ; LDIRVM
	ld hl,07980h		;827e
	ld de,02a80h		;8281   ; en el segundo
	ld bc,00380h		;8284
	call 0005ch		;8287   ; LDIRVM
	ld hl,07980h		;828a
	ld de,03280h		;828d   ; en el tercero
	ld bc,00380h		;8290
	call 0005ch		;8293   ; LDIRVM
fase_ninja:
	ld (ix+000h),0ech		;8296   ; Y 0xEC (fuera)...
	ld (ix+001h),074h		;829a   ; ...X 0x74, dibujo 0x28, color 5
	ld (ix+002h),028h		;829e   ; dibujo 0x28
	ld (ix+003h),005h		;82a2   ; color 5
	ld (ix+010h),0ech		;82a6   ; el segundo sprite: dibujo 0x2C, color 11
	ld (ix+011h),074h		;82aa   ; X 0x74
	ld (ix+012h),02ch		;82ae   ; dibujo 0x2C
	ld (ix+013h),00bh		;82b2   ; color 11
	ld a,002h		;82b6   ; la musica 2
	call musica_pide		;82b8   ; pide la musica
	call puntos_pinta		;82bb   ; los puntos y el record
	call 00044h		;82be   ; ENASCR
	call mapa_monta		;82c1   ; la pantalla de la fase
	call pantalla_abre		;82c4   ; el desplazamiento
	xor a			;82c7   ; la cuenta a 0
	ld (0e011h),a		;82c8
	ld a,(0e00ah)		;82cb   ; la fase 6?
	cp 006h		;82ce   ; la 6
	jr z,fase_ninja_y88		;82d0
	cp 002h		;82d2   ; la 2 o mas?
	jr nc,fase_entrada		;82d4   ; la 2 o mas: la entrada
	cp 000h		;82d6   ; la 0...
	jr nz,fase_ninja_y70		;82d8   ; la 1: Y 0x70
	ld a,(0e060h)		;82da   ; ...con el primer Iga?
	and a			;82dd
	jr z,fase_ninja_y70		;82de   ; sin el: Y 0x70
	ld (ix+000h),0a0h		;82e0   ; Y 0xA0
	ld (ix+010h),0a0h		;82e4   ; el segundo sprite
	jr fase_ninja_pon		;82e8   ; al bucle
fase_ninja_y70:
	ld (ix+000h),070h		;82ea   ; Y 0x70
	ld (ix+010h),070h		;82ee   ; el segundo sprite
fase_ninja_pon:
	call sprites_rota		;82f2   ; los sprites
	jp fase_bucle_empieza		;82f5   ; al bucle
fase_ninja_y88:
	ld (ix+000h),088h		;82f8   ; la fase 6: Y 0x88
	ld (ix+010h),088h		;82fc   ; el segundo sprite
	jp fase_bucle_empieza		;8300   ; al bucle
fase_entrada:		; Desde la fase 2: cada 24 cuadros un paso de la entrada (0xE1B0, 0-3), con su dibujo (0x4790, 0x47A2, 0x477E) en la fila 12
	ld a,(0e011h)		;8303   ; 24 cuadros
	cp 018h		;8306   ; 24?
	jr c,fase_entrada		;8308
	xor a			;830a   ; la cuenta a 0
	ld (0e011h),a		;830b
	ld hl,0198dh		;830e   ; la fila 12, columna 13
	ld de,04790h		;8311   ; el paso 0: 0x4790
	ld a,(0e1b0h)		;8314   ; el paso
	and a			;8317
	jr z,fase_entrada_paso		;8318   ; 0: a pintar
	ld de,047a2h		;831a   ; el 1: 0x47A2
	cp 001h		;831d
	jr z,fase_entrada_paso		;831f
	ld (ix+000h),070h		;8321   ; Y 0x70
	ld (ix+010h),070h		;8325   ; el ninja en la puerta
	ld de,04790h		;8329   ; el 2: 0x4790
	cp 002h		;832c
	jr z,fase_entrada_paso		;832e
	ld de,0477eh		;8330   ; el 3: 0x477E
	cp 003h		;8333
	jr z,fase_entrada_paso		;8335
	jr fase_bucle_empieza		;8337   ; el 4: al bucle
fase_entrada_paso:
	inc a			;8339   ; uno mas
	ld (0e1b0h),a		;833a   ; apuntado
	call dibujo_vram		;833d   ; el dibujo
	call sprites_rota		;8340   ; los sprites
	jr fase_entrada		;8343   ; otro paso
fase_bucle_empieza:		; La musica entera; las cuentas y los botones a 0; sin partida, la demostracion (0xE027 = 1)
	call espera_musica		;8345   ; espera a que acabe la musica
	xor a			;8348   ; las cuentas y los botones a 0
	ld (0e010h),a		;8349   ; 0xE010
	ld (0e01fh),a		;834c   ; 0xE01F: la cuenta de la luna
	ld (0e022h),a		;834f   ; el boton 1
	ld (0e020h),a		;8352   ; el boton 2
	ld (0e026h),a		;8355   ; el de empezar
	ld (0e180h),a		;8358   ; la palanca
	ld (0e01fh),a		;835b
	ld a,(0e000h)		;835e   ; jugando?
	and a			;8361
	jr nz,fase_bucle		;8362   ; si: al bucle
	inc a			;8364   ; no: la demostracion
	ld (0e027h),a		;8365   ; 0xE027 = 1
fase_bucle:		; El bucle de la fase: el ninja tocado (0xE183), la fase acabada (0xE186), el ninja que cae (0xE1B3), el cambio (0xE1B5); cada cuadro (0xE011) el sonido de fondo y, en el modo de 0xE1B7, solo el dibujo; si no, todo: el ninja, sus armas, los enemigos, el desplazamiento, los puntos...; sin partida, con el boton, el titulo
	ld a,(0e183h)		;8368   ; tocado?
	and a			;836b
	jp nz,ninja_tocado		;836c   ; si
	ld a,(0e186h)		;836f   ; la fase acabada?
	and a			;8372
	jp nz,fase_acabada		;8373   ; si
	ld a,(0e1b3h)		;8376   ; cae?
	and a			;8379
	jp nz,ninja_cae		;837a   ; si
	ld a,(0e1b5h)		;837d   ; el cambio?
	and a			;8380
	jp nz,fase_cambio		;8381   ; si
fase_cuadro:
	ld a,(0e011h)		;8384   ; un cuadro
	cp 001h		;8387   ; un cuadro?
	jp c,fase_bucle_fin		;8389   ; aun no
	xor a			;838c   ; la cuenta a 0
	ld (0e011h),a		;838d
	call sonido_fondo		;8390   ; el sonido de fondo
	ld a,(0e1b7h)		;8393   ; el modo de 0xE1B7?
	and a			;8396
	jr z,fase_todo		;8397   ; no: todo
	ld a,(0e019h)		;8399   ; 0x60 cuadros (0xE019)?
	cp 060h		;839c   ; 0x60?
	jr c,fase_cambio_teclas		;839e   ; aun no: las teclas
	ld (ix+002h),00ch		;83a0   ; los dibujos de vuelta
	ld (ix+003h),009h		;83a4   ; color 9
	ld (ix+012h),004h		;83a8   ; el sprite 1, dibujo 4
	ld (ix+022h),008h		;83ac   ; el 2, dibujo 8, color 9
	ld (ix+023h),009h		;83b0
	ld (ix+032h),000h		;83b4   ; el 3, dibujo 0
	ld (ix+040h),0ech		;83b8   ; el 4 y el 5 fuera
	ld (ix+050h),0ech		;83bc
	jr fase_cambio_pinta		;83c0   ; a pintar
fase_cambio_teclas:
	ld a,003h		;83c2   ; la fila 3: la C (bit 0)...
	call 00141h		;83c4   ; SNSMAT
	bit 0,a		;83c7   ; la C?
	jr nz,L_8408		;83c9   ; no
	ld a,005h		;83cb   ; ...y la fila 5: la W (bit 4)
	call 00141h		;83cd   ; SNSMAT
	bit 4,a		;83d0   ; la W?
	jr nz,L_8408		;83d2   ; no
	ld (ix+002h),024h		;83d4   ; las dos: otros dibujos
	ld (ix+003h),005h		;83d8   ; color 5
	ld (ix+012h),018h		;83dc   ; el sprite 1, dibujo 0x18
	ld (ix+022h),020h		;83e0   ; el 2, dibujo 0x20, color 5
	ld (ix+023h),005h		;83e4
	ld (ix+032h),010h		;83e8   ; el 3, dibujo 0x10
	ld a,(ix+000h)		;83ec   ; el 4 a la altura del ninja...
	ld (ix+040h),a		;83ef
	sub 010h		;83f2   ; ...y el 5, 16 mas arriba
	ld (ix+050h),a		;83f4
fase_cambio_pinta:
	ld hl,0e300h		;83f7   ; seis sprites...
	ld de,0e100h		;83fa   ; ...a su tabla
	ld b,006h		;83fd   ; seis
	call sprites_vram_uno		;83ff   ; a la tabla
	xor a			;8402   ; la cuenta a 0
	ld (0e019h),a		;8403   ; la cuenta a 0
	jr fase_bucle_fin		;8406
L_8408:
	jr fase_bucle_fin		;8408
fase_todo:
	call sprites_rota		;840a   ; los sprites
	call objeto_cogido		;840d   ; lo cogido
	call ninja_mueve		;8410   ; el ninja se mueve
	call salto		;8413   ; el salto
	call ninja_dibujo		;8416   ; su dibujo
	call shuriken		;8419   ; el shuriken
	call puntos_pinta		;841c   ; los puntos
	call enemigos		;841f   ; los enemigos
	call objetos_e400		;8422   ; los objetos de 0xE400
	call luna		;8425   ; la luna
	call enemigos_salen		;8428   ; los que salen
	call fase_fin		;842b   ; el final de la fase
fase_bucle_fin:
	ld a,(0e000h)		;842e   ; jugando?
	and a			;8431
	jp nz,fase_bucle		;8432   ; si: otro cuadro
	ld a,(0e026h)		;8435   ; si no: el boton?
	and a			;8438
	jp z,fase_bucle		;8439   ; no: otro cuadro
	jp titulo		;843c   ; el titulo
fase_cambio:		; 0xE1B5: 0xE1B7 cambia; a 0, los sprites 2-5 fuera y los dibujos de siempre; si no, otros dibujos (0x5400) y el ninja en seis sprites
	xor a			;843f
	ld (0e1b5h),a		;8440   ; gastado
	ld a,(0e1b7h)		;8443   ; 0xE1B7 al reves
	cpl			;8446
	ld (0e1b7h),a		;8447   ; apuntado
	and a			;844a
	jr nz,fase_cambio_otro		;844b   ; al otro modo
	ld (ix+020h),0ech		;844d   ; los otros cuatro sprites fuera
	ld (ix+030h),0ech		;8451   ; los sprites 2-5 fuera
	ld (ix+040h),0ech		;8455
	ld (ix+050h),0ech		;8459
	call sprites_dibujos		;845d   ; los dibujos de los sprites de siempre
	ld (ix+003h),005h		;8460   ; el ninja de color 5...
	ld (ix+013h),00bh		;8464   ; ...y 11
	jr fase_bucle_fin		;8468   ; al bucle
fase_cambio_otro:
	call sprites_dibujos_otros		;846a   ; los otros dibujos (0x5400)
	ld (ix+042h),01ch		;846d   ; los dibujos de los sprites 4 y 5
	ld (ix+052h),014h		;8471
	ld (ix+013h),00bh		;8475   ; los colores: 11...
	ld (ix+033h),00bh		;8479
	ld (ix+043h),009h		;847d   ; ...y 9
	ld (ix+053h),009h		;8481
	ld a,(ix+000h)		;8485   ; los seis sprites alrededor del ninja
	ld (ix+040h),a		;8488   ; las Y: la del ninja...
	sub 010h		;848b   ; ...y 16 mas arriba
	ld (ix+020h),a		;848d
	ld (ix+030h),a		;8490
	ld (ix+050h),a		;8493
	ld a,(ix+001h)		;8496   ; las X: la del ninja...
	ld (ix+021h),a		;8499
	ld (ix+031h),a		;849c
	add a,010h		;849f   ; ...y 16 a la derecha
	ld (ix+041h),a		;84a1
	ld (ix+051h),a		;84a4
	ld (ix+002h),00ch		;84a7   ; los dibujos y colores del cambio
	ld (ix+003h),009h		;84ab
	ld (ix+012h),004h		;84af
	ld (ix+022h),008h		;84b3
	ld (ix+023h),009h		;84b7
	ld (ix+032h),000h		;84bb
	ld (ix+040h),0ech		;84bf   ; el 4 y el 5 fuera
	ld (ix+050h),0ech		;84c3
	ld hl,0e100h		;84c7   ; la tabla de sprites a cero
	ld b,040h		;84ca   ; 0x40 bytes
L_84CC:
	ld (hl),000h		;84cc   ; a cero
	inc hl			;84ce
	djnz L_84CC		;84cf
	ld hl,0e300h		;84d1   ; los seis sprites...
	ld de,0e100h		;84d4
	ld b,006h		;84d7   ; seis
	call sprites_vram_uno		;84d9   ; ...a la tabla
	jp fase_bucle_fin		;84dc   ; al bucle
sonido_fondo:		; El ruido de cada cuadro: en el modo de 0xE1BB con 0xE1BA = 1, el efecto 1; en las fases 0-1, el 5; desde la 2, el 4; en la 6, el 3
	ld a,(0e1bbh)		;84df   ; la luna menguando?
	and a			;84e2
	jr z,L_84F1		;84e3
	ld a,(0e1bah)		;84e5   ; la ultima?
	cp 001h		;84e8
	jr nz,L_84F1		;84ea
	ld a,001h		;84ec   ; el efecto 1: la alarma
	jp efecto_pide		;84ee
L_84F1:
	ld a,(0e00ah)		;84f1   ; la fase 6?
	cp 006h		;84f4   ; la 6?
	jr z,$+17		;84f6   ; a 0x8507
	cp 002h		;84f8   ; la 2 o mas: el efecto 4
	jr c,sonido_fondo_5		;84fa   ; las fases 0 y 1
	ld a,004h		;84fc   ; el efecto 4
	jp efecto_pide		;84fe
sonido_fondo_5:
	ld a,005h		;8501   ; el efecto 5
	jp efecto_pide		;8503

; ----------------------------------------------------------------------
; DATOS byte_8506: Un byte suelto entre dos "jp": el "jr z" de 0x84F6 salta
;   por encima
;   0x8506..0x8507  (1 bytes)
DATA_byte_8506:
	defb 0c9h	; 8506

; ======================================================================
; CODIGO 0x8507..0x862e  (295 bytes)
; ======================================================================


sonido_fondo_3:
	ld a,003h		;8507   ; el efecto 3
	jp efecto_pide		;8509
ninja_tocado:		; El ninja tocado (0xE183): con BS en el titulo (0xE023) no pasa nada, salvo con 0xE183 = 2; si no, el sonido a cero, el ninja sube 0x28 cuadros y baja otros 0x28 cambiando de dibujo cada 4; despues de 0x80 cuadros, una vida menos y la fase otra vez; sin vidas, con 2, A, I y G en el titulo (0xE039), CONTINUE PUSH TRIG1 / END PUSH TRIG2; si no, GAME OVER
	ld a,(0e183h)		;850c   ; 2?
	cp 002h		;850f
	jr z,ninja_tocado_va		;8511   ; 2: muere aunque haya BS
	ld a,(0e023h)		;8513   ; BS en el titulo?
	and a			;8516
	jr z,ninja_tocado_va		;8517   ; no: muere
	xor a			;8519   ; nada
	ld (0e183h),a		;851a   ; 0
	jp fase_cuadro		;851d   ; al bucle
ninja_tocado_va:
	call sonido_reinicia		;8520   ; el sonido a cero
	ld a,(0e183h)		;8523   ; 2?
	cp 002h		;8526
	jr nz,ninja_tocado_cero		;8528
	xor a			;852a   ; 2: la cuenta desde 0x20
	ld (0e183h),a		;852b   ; 0
	ld a,020h		;852e   ; la cuenta desde 0x20...
	ld (0e013h),a		;8530
	jr ninja_cae		;8533   ; ...menos espera
ninja_tocado_cero:
	xor a			;8535
	ld (0e183h),a		;8536   ; 0
	ld (0e013h),a		;8539   ; la cuenta desde 0
ninja_cae:		; Espera 0x30 cuadros (0xE013) con el ninja quieto; despues lo borra todo y el efecto 2
	ld a,(0e011h)		;853c   ; un cuadro
	cp 001h		;853f   ; un cuadro?
	jr c,ninja_cae		;8541
	xor a			;8543   ; la cuenta a 0
	ld (0e011h),a		;8544
	ld (ix+003h),005h		;8547   ; color 5
	call sprites_rota		;854b   ; los sprites
	ld a,(0e013h)		;854e   ; 0x30?
	cp 030h		;8551   ; 0x30?
	jr c,ninja_cae		;8553
	call todos_fuera		;8555   ; los otros sprites fuera
	ld a,002h		;8558   ; el efecto 2
	call efecto_pide		;855a   ; pide el efecto
ninja_cae_cuadro:
	ld a,(0e011h)		;855d   ; un cuadro
	cp 001h		;8560
	jr c,ninja_cae_cuadro		;8562
	xor a			;8564   ; la cuenta a 0
	ld (0e011h),a		;8565
	ld a,(0e013h)		;8568   ; cada 4 cuadros...
	and 004h		;856b   ; cada 4 cuadros
	and a			;856d
	jr nz,ninja_cae_dibujo2		;856e
	ld (ix+002h),088h		;8570   ; ...los dibujos 0x88 y 0x8C...
	ld (ix+012h),08ch		;8574   ; y 0x8C
	jr ninja_cae_mueve		;8578
ninja_cae_dibujo2:
	ld (ix+002h),090h		;857a   ; ...o 0x90 y 0x94
	ld (ix+012h),094h		;857e   ; y 0x94
ninja_cae_mueve:
	call sprites_rota		;8582   ; los sprites
	inc (ix+01eh)		;8585   ; la cuenta (+0x1E)
	ld a,(ix+01eh)		;8588   ; la cuenta
	cp 028h		;858b   ; 0x28 cuadros sube
	jr nc,ninja_cae_baja		;858d
	dec (ix+000h)		;858f   ; un punto arriba
	dec (ix+010h)		;8592
	jr ninja_cae_cuadro		;8595   ; otro cuadro
ninja_cae_baja:
	cp 050h		;8597   ; y otros 0x28 baja
	jr nc,ninja_cae_espera		;8599
	inc (ix+000h)		;859b   ; un punto abajo
	inc (ix+010h)		;859e
	jr ninja_cae_cuadro		;85a1   ; otro cuadro
ninja_cae_espera:
	ld a,(0e011h)		;85a3   ; 0x80 cuadros
	cp 080h		;85a6   ; 0x80?
	jr c,ninja_cae_espera		;85a8
	ld a,(0e00bh)		;85aa   ; vidas?
	and a			;85ad   ; ninguna?
	jr z,sin_vidas		;85ae
	dec a			;85b0   ; una menos
	ld (0e00bh),a		;85b1   ; apuntada
	jp fase_empieza		;85b4   ; la fase otra vez
sin_vidas:
	ld a,(0e039h)		;85b7   ; 2, A, I y G en el titulo?
	and a			;85ba
	jp z,game_over		;85bb   ; no: GAME OVER
	ld a,(ix+000h)		;85be   ; la Y del ninja
	ld (0e1a8h),a		;85c1
	call objetos_fuera		;85c4   ; la pantalla limpia
	call pantalla_cierra		;85c7   ; la pantalla se borra
	ld de,018c8h		;85ca   ; CONTINUE PUSH TRIG1 (0x862E) en la fila 6
	ld hl,0862eh		;85cd
	ld bc,00013h		;85d0
	call 0005ch		;85d3   ; LDIRVM
	ld de,01908h		;85d6   ; END      PUSH TRIG2 (0x8641) en la fila 8
	ld hl,08641h		;85d9
	ld bc,00013h		;85dc
	call 0005ch		;85df   ; LDIRVM
	xor a			;85e2   ; las cuentas y los botones a 0
	ld (0e010h),a		;85e3   ; las cuentas...
	ld (0e1a0h),a		;85e6
	ld (0e020h),a		;85e9   ; ...y los botones a 0
	ld (0e022h),a		;85ec
continuar_espera:
	ld a,(0e022h)		;85ef   ; el boton 1?
	and a			;85f2
	jr z,continuar_boton2		;85f3   ; no: el 2
	jr continuar		;85f5   ; si: continuar
continuar_boton2:
	ld a,(0e020h)		;85f7   ; el boton 2?
	and a			;85fa
	jr z,continuar_espera		;85fb   ; no: espera
	jr game_over		;85fd   ; GAME OVER
continuar:
	ld a,002h		;85ff   ; dos vidas
	ld (0e00bh),a		;8601   ; apuntadas
	jp fase_empieza		;8604   ; la fase otra vez
game_over:		; GAME OVER (0x907B) en la fila 9, la musica 1, la espera y el titulo
	call ram_borra		;8607   ; la pantalla a cero
	call pantalla_cierra		;860a   ; la pantalla se borra
	ld de,0192ch		;860d   ; la fila 9, columna 12
	ld hl,0907bh		;8610   ; GAME OVER
	ld bc,00009h		;8613
	call 0005ch		;8616   ; LDIRVM
	ld a,001h		;8619   ; la musica 1
	call musica_pide		;861b   ; pide la musica
	call espera_musica		;861e   ; entera
	xor a			;8621   ; sin partida
	ld (0e028h),a		;8622
	ld (0e000h),a		;8625   ; 0xE000 = 0
	ld (0e026h),a		;8628   ; el boton a 0
	jp titulo		;862b   ; el titulo

; ----------------------------------------------------------------------
; DATOS continuar_textos: Los textos de continuar: CONTINUE PUSH TRIG1
;   (0x862E) y END      PUSH TRIG2 (0x8641), 19 letras cada uno
;   0x862e..0x8654  (38 bytes)
DATA_continuar_textos:
	defb 013h,01fh,01eh,024h,019h,01eh,025h,015h,010h,020h,025h,023h,018h,010h,024h,022h	; 862e  ...$..%.. %#..$"
	defb 019h,017h,001h,015h,01eh,014h,010h,010h,010h,010h,010h,010h,020h,025h,023h,018h	; 863e  ............ %#.
	defb 010h,024h,022h,019h,017h,002h	; 864e

; ======================================================================
; CODIGO 0x8654..0x88ec  (664 bytes)
; ======================================================================


fase_acabada:		; La fase acabada (0xE186): los puntos, todo fuera, la musica entera; la posicion 1 y la fase siguiente; despues de la 6, la 0 y una vuelta mas (0xE009); con tres vueltas, el final: los creditos (0x9084) en diez filas, la musica 5 y el titulo
	call puntos_pinta		;8654   ; los puntos
	call todos_fuera		;8657   ; todos fuera
	call espera_musica		;865a   ; la musica entera
	xor a			;865d
	ld (0e186h),a		;865e   ; 0
	inc a			;8661   ; la posicion 1
	ld (0e051h),a		;8662   ; 0xE051 = 1
	ld a,(0e00ah)		;8665   ; la fase siguiente
	inc a			;8668
	ld (0e00ah),a		;8669   ; apuntada
	cp 007h		;866c   ; 7?
	jp c,fase_empieza		;866e   ; no: la fase
	xor a			;8671   ; otra vez la 0...
	ld (0e00ah),a		;8672
	xor a			;8675
	ld (0e053h),a		;8676   ; las marcas a 0
	ld a,(0e009h)		;8679   ; ...y una vuelta mas
	inc a			;867c
	ld (0e009h),a		;867d   ; apuntada
	cp 003h		;8680   ; tres?
	jp nz,fase_empieza		;8682   ; no: la fase 0 otra vez
	xor a			;8685   ; el final: sin partida, sin vidas
	ld (0e009h),a		;8686   ; la vuelta 0
	ld (0e053h),a		;8689
	ld (0e000h),a		;868c
	ld (0e00bh),a		;868f   ; 0 vidas
	ld (ix+000h),0ech		;8692   ; el ninja fuera
	ld (ix+010h),0ech		;8696
	ld (ix+020h),0ech		;869a
	call sprites_rota		;869e   ; los sprites
	call pantalla_cierra		;86a1   ; la pantalla se borra
	ld hl,09084h		;86a4   ; STAFF y los nombres (0x9084), una fila de cada dos
	ld de,0188dh		;86a7   ; STAFF en la fila 4
	ld bc,00005h		;86aa
	call 0005ch		;86ad   ; LDIRVM
	ex de,hl			;86b0
	ld de,018cbh		;86b1   ; K;ARISAWA en la 6
	ld bc,00009h		;86b4
	call 0005ch		;86b7   ; LDIRVM
	ex de,hl			;86ba
	ld de,0190bh		;86bb   ; K;ASAHINA en la 8
	ld bc,00009h		;86be
	call 0005ch		;86c1   ; LDIRVM
	ex de,hl			;86c4
	ld de,0194bh		;86c5   ; T;SATHO en la 10
	ld bc,00007h		;86c8
	call 0005ch		;86cb   ; LDIRVM
	ex de,hl			;86ce
	ld de,0198bh		;86cf   ; T;TSUJITANI en la 12
	ld bc,0000bh		;86d2
	call 0005ch		;86d5   ; LDIRVM
	ex de,hl			;86d8
	ld de,019cbh		;86d9   ; K;OHSAWA en la 14
	ld bc,00008h		;86dc
	call 0005ch		;86df   ; LDIRVM
	ex de,hl			;86e2
	ld de,01a0bh		;86e3   ; A;HASEGAWA en la 16
	ld bc,0000ah		;86e6
	call 0005ch		;86e9   ; LDIRVM
	ex de,hl			;86ec
	ld de,01a4eh		;86ed   ; M;K en la 18
	ld bc,00003h		;86f0
	call 0005ch		;86f3   ; LDIRVM
	ex de,hl			;86f6
	ld de,01a8ch		;86f7   ; PRODUCER en la 20
	ld bc,00008h		;86fa
	call 0005ch		;86fd   ; LDIRVM
	ex de,hl			;8700
	ld de,01acbh		;8701   ; T;MORIYAMA en la 22
	ld bc,0000ah		;8704
	call 0005ch		;8707   ; LDIRVM
	ld a,005h		;870a   ; la musica 5
	call musica_pide		;870c   ; pide la musica
	call espera_musica		;870f   ; entera
	jp titulo		;8712   ; el titulo
todos_fuera:		; Los 0xE0 bytes de 0xE320 a cero y 14 objetos de 16 bytes fuera (Y 0xEC); y los sprites a la VRAM
	ld hl,0e320h		;8715   ; desde 0xE320...
	ld b,0e0h		;8718   ; ...0xE0 bytes...
todos_fuera_byte:
	ld (hl),000h		;871a   ; ...a cero
	inc hl			;871c
	djnz todos_fuera_byte		;871d
	ld hl,0e320h		;871f   ; y los 14 objetos...
	ld de,00010h		;8722
	ld b,00eh		;8725   ; 14
todos_fuera_y:
	ld (hl),0ech		;8727   ; ...fuera
	add hl,de			;8729
	djnz todos_fuera_y		;872a
	jp sprites_vram		;872c   ; a la VRAM
otro_borra_va:
	push iy		;872f   ; sus 16 bytes...
	pop hl			;8731   ; su principio
	ld b,010h		;8732   ; 16 bytes
otro_borra_byte:
	ld (hl),000h		;8734   ; ...a cero
	inc hl			;8736
	djnz otro_borra_byte		;8737
	ld (iy+000h),0ech		;8739   ; fuera (Y 0xEC)
	ret			;873d   ; listo
cerca_y:		; ¿Toca en Y? A = la Y de IY menos la del protagonista (IX): C (toca) si, con signo, queda entre C - 0x100 y B - 1 (B, el margen por un lado; C, 0x100 menos el del otro)
	ld a,(iy+000h)		;873e   ; la Y del otro...
	sub (ix+000h)		;8741   ; ...menos la del protagonista
cerca_mira:
	cp b			;8744   ; menos que B (de 0 a B - 1): toca
	ret c			;8745   ; C
	cp c			;8746   ; C o mas (de C - 0x100 a -1)?
	jr c,L_874B		;8747   ; no: a NC
	scf			;8749   ; si: toca (C)
	ret			;874a   ; C
L_874B:
	xor a			;874b   ; NC: no
	ret			;874c
cerca_x:		; ¿Toca en X? A = la X de IY menos la del protagonista (IX): C si queda entre C - 0x100 y B - 1, como cerca_y
	ld a,(iy+001h)		;874d   ; la X de IY...
	sub (ix+001h)		;8750   ; ...menos la de IX
	jr cerca_mira		;8753   ; a comparar
cerca_y2:		; Como cerca_y, con el sprite 2 del protagonista (+0x20)
	ld a,(iy+000h)		;8755   ; la Y de IY...
	sub (ix+020h)		;8758   ; ...menos la del sprite 2
	jr cerca_mira		;875b
cerca_x2:		; Como cerca_x, con el sprite 2 del protagonista (+0x21)
	ld a,(iy+001h)		;875d   ; la X de IY...
	sub (ix+021h)		;8760   ; ...menos la del sprite 2
	jr cerca_mira		;8763
pantalla_limpia:		; La pantalla apagada, la tabla de nombres y la RAM de 0xE100 a cero, los botones a 0, los dibujos de las casillas 0x30-0x7F (0x5180) y sus colores (0x6180) en los tres tercios, y los de los sprites
	call 00041h		;8765   ; DISSCR
	call nombres_borra		;8768   ; la tabla de nombres a 0x10
	call ram_borra		;876b   ; la RAM de 0xE100 a cero
	xor a			;876e   ; los botones a 0
	ld (0e026h),a		;876f   ; los botones a 0
	ld (0e020h),a		;8772
	ld (0e022h),a		;8775
	ld (0e024h),a		;8778   ; 0xE024
	ld (0e180h),a		;877b   ; la palanca
	ld de,00180h		;877e   ; los dibujos, en los tres tercios...
	call casillas_pon		;8781   ; en el primer tercio
	ld de,00980h		;8784   ; el segundo
	call casillas_pon		;8787
	ld de,01180h		;878a   ; el tercero
	call casillas_pon		;878d
	ld de,02180h		;8790   ; ...y los colores
	call colores_pon		;8793   ; en el primer tercio
	ld de,02980h		;8796   ; el segundo
	call colores_pon		;8799
	ld de,03180h		;879c   ; el tercero
	call colores_pon		;879f
	jp sprites_dibujos		;87a2   ; los dibujos de los sprites
marcador_pon:		; El marcador de arriba: HISCORE: en la fila 0 y SCORE: (sus seis ultimas letras) en la 1, columna 17; el 0 fijo detras de las cifras (columna 31); el dibujo del ninja (0xFE) y "=" con las vidas, el del enemigo (0xFF) y "=" con los derrotados (0xE1B8), las marcas de la fase, las de 0xE053 y la luna
	ld de,01811h		;87a5   ; HISCORE: (0x9073)...
	ld hl,09073h		;87a8   ; HISCORE:
	ld bc,00008h		;87ab
	call 0005ch		;87ae   ; LDIRVM
	ld de,01833h		;87b1   ; ...y SCORE: (0x9075)
	ld hl,09075h		;87b4   ; SCORE:
	ld bc,00006h		;87b7
	call 0005ch		;87ba   ; LDIRVM
	ld hl,0181fh		;87bd   ; un 0 detras del record...
	xor a			;87c0   ; la casilla 0: un "0"
	call 0004dh		;87c1   ; WRTVRM
	ld hl,0183fh		;87c4   ; ...y de los puntos: en pantalla, los puntos x 10
	xor a			;87c7
	call 0004dh		;87c8   ; WRTVRM
	ld hl,0180dh		;87cb   ; el ninja (0xFE) y "="
	ld a,0feh		;87ce   ; la casilla 0xFE
	call 0004dh		;87d0   ; WRTVRM
	inc hl			;87d3
	ld a,00dh		;87d4   ; "="
	call 0004dh		;87d6   ; WRTVRM
	ld hl,0182dh		;87d9   ; el enemigo (0xFF) y "="
	ld a,0ffh		;87dc   ; la casilla 0xFF
	call 0004dh		;87de   ; WRTVRM
	inc hl			;87e1
	ld a,00dh		;87e2   ; "="
	call 0004dh		;87e4   ; WRTVRM
	call derrotados_pinta		;87e7   ; los derrotados
	call fase_marcas		;87ea   ; las marcas de la fase
	call marcas_e053		;87ed   ; las de 0xE053
	call luna_pinta		;87f0   ; la luna
vidas_pinta:		; Las vidas (0xE00B, BCD) en la fila 0, columna 15: dos cifras
	ld a,(0e00bh)		;87f3   ; la cifra alta
	and 0f0h		;87f6   ; la cifra alta
	rrca			;87f8
	rrca			;87f9
	rrca			;87fa
	rrca			;87fb
	ld hl,0180fh		;87fc   ; la fila 0, columna 15
	call 0004dh		;87ff   ; WRTVRM
	inc hl			;8802   ; la siguiente
	ld a,(0e00bh)		;8803   ; la baja
	and 00fh		;8806   ; la baja
	call 0004dh		;8808   ; WRTVRM
	ret			;880b
derrotados_pinta:		; Los enemigos derrotados (0xE1B8, BCD) en la fila 1, columna 15
	ld a,(0e1b8h)		;880c
	and 0f0h		;880f   ; la cifra alta
	rrca			;8811
	rrca			;8812
	rrca			;8813
	rrca			;8814
	ld hl,0182fh		;8815   ; la fila 1, columna 15
	call 0004dh		;8818   ; WRTVRM
	inc hl			;881b
	ld a,(0e1b8h)		;881c   ; la baja
	and 00fh		;881f
	call 0004dh		;8821   ; WRTVRM
	ret			;8824
fase_marcas:		; Una marca por fase (la fase + 1) en las filas 0 y 1 desde la columna 0: las casillas 0xFC y 0xFD
	ld a,(0e00ah)		;8825   ; la fase...
	inc a			;8828   ; ...+ 1
	ld b,a			;8829
	ld c,a			;882a
	ld hl,01800h		;882b   ; la fila 0
fase_marcas_arriba:
	ld a,0fch		;882e   ; la de arriba
	call 0004dh		;8830   ; WRTVRM
	inc hl			;8833
	djnz fase_marcas_arriba		;8834
	ld b,c			;8836   ; otra vez
	ld hl,01820h		;8837   ; la fila 1
fase_marcas_abajo:
	ld a,0fdh		;883a   ; la de abajo
	call 0004dh		;883c   ; WRTVRM
	inc hl			;883f
	djnz fase_marcas_abajo		;8840
	ret			;8842
marcas_e053:		; 0xE053 marcas (las casillas 0x72 y 0x76) en las filas 0 y 1 desde la columna 9
	ld a,(0e053h)		;8843   ; cuantas
	and a			;8846
	ret z			;8847   ; ninguna
	ld b,a			;8848
	ld c,a			;8849
	ld hl,01809h		;884a   ; la fila 0, columna 9
marcas_e053_arriba:
	ld a,072h		;884d   ; la de arriba
	call 0004dh		;884f   ; WRTVRM
	inc hl			;8852
	djnz marcas_e053_arriba		;8853
	ld b,c			;8855
	ld hl,01829h		;8856   ; la fila 1
marcas_e053_abajo:
	ld a,076h		;8859   ; la de abajo
	call 0004dh		;885b   ; WRTVRM
	inc hl			;885e
	djnz marcas_e053_abajo		;885f
	ret			;8861
luna:		; La luna, el tiempo de la fase: con el primer Iga en otro slot (0xE060), siempre el mismo dibujo (0x890A) y no cambia; si no, cada 0xF0 cuadros (0xE01F) una cuenta (0xE1B9) y, cada 5 - la vuelta (2 como poco), la luna cambia (0xE1BA): crece de 0 a 4 y despues (0xE1BB = 1) mengua; cuando se acaba, el ninja muere (0xE183 = 2)
	ld a,(0e060h)		;8862   ; el primer Iga?
	and a			;8865
	jr z,luna_cuenta		;8866   ; no
	ld de,0890ah		;8868   ; el dibujo de siempre
	jp luna_pinta_va		;886b   ; a pintar
luna_cuenta:
	ld a,(0e01fh)		;886e   ; 0xF0 cuadros?
	cp 0f0h		;8871
	ret c			;8873   ; aun no
	xor a			;8874   ; la cuenta a 0
	ld (0e01fh),a		;8875
	ld a,(0e1b9h)		;8878   ; una mas
	inc a			;887b
	ld (0e1b9h),a		;887c   ; apuntada
	ld a,(0e009h)		;887f   ; 5 - la vuelta...
	ld b,a			;8882
	ld a,005h		;8883
	sub b			;8885   ; 5 - la vuelta
	cp 002h		;8886   ; ...2 como poco
	jr nc,luna_cambia		;8888
	ld a,002h		;888a   ; 2
luna_cambia:
	ld b,a			;888c
	ld a,(0e1b9h)		;888d
	cp b			;8890   ; tantas?
	ret c			;8891   ; aun no
	xor a			;8892   ; la cuenta a 0
	ld (0e1b9h),a		;8893   ; a cero
	ld a,(0e1bbh)		;8896   ; menguando?
	and a			;8899
	jr z,luna_crece		;889a   ; no: crece
	ld a,(0e1bah)		;889c   ; una menos
	dec a			;889f
	ld (0e1bah),a		;88a0   ; apuntada
	and a			;88a3
	jr nz,luna_pinta		;88a4   ; aun queda
	call luna_pinta		;88a6   ; acabada: el ninja muere
	ld a,002h		;88a9
	ld (0e183h),a		;88ab   ; 0xE183 = 2
	ret			;88ae
luna_crece:
	ld a,(0e1bah)		;88af   ; una mas
	inc a			;88b2
	ld (0e1bah),a		;88b3   ; apuntada
	cp 005h		;88b6   ; 4 (llena)?
	jr c,luna_pinta		;88b8   ; no
	dec a			;88ba
	ld (0e1bah),a		;88bb   ; se queda en 4
	ld a,001h		;88be   ; ya mengua
	ld (0e1bbh),a		;88c0   ; 0xE1BB = 1
luna_pinta:		; El dibujo de la luna (0xE1BA, 0-4: 0x88EC, 0x88F2...) en la fila 0, columna 7
	ld a,(0e1bah)		;88c3
	ld de,088ech		;88c6   ; 0: el cielo vacio
	cp 000h		;88c9
	jr z,luna_pinta_va		;88cb
	ld de,088f2h		;88cd   ; 1
	cp 001h		;88d0
	jr z,luna_pinta_va		;88d2
	ld de,088f8h		;88d4   ; 2
	cp 002h		;88d7
	jr z,luna_pinta_va		;88d9
	ld de,088feh		;88db   ; 3
	cp 003h		;88de
	jr z,luna_pinta_va		;88e0
	ld de,08904h		;88e2   ; 4: llena
luna_pinta_va:
	ld hl,01807h		;88e5   ; la fila 0, columna 7
	call dibujo_vram		;88e8   ; en la VRAM
	ret			;88eb

; ----------------------------------------------------------------------
; DATOS luna_dibujos: Los dibujos de la luna, de 2 x 2 casillas: el cielo
;   vacio (0x88EC), cuatro lunas (0x88F2-0x8904) y el de con el primer Iga
;   (0x890A: las casillas 0xFC y 0xFD); y un "ret" suelto (0x8910)
;   0x88ec..0x8911  (37 bytes)
DATA_luna_dibujos:
	defb 002h,002h,010h,010h,010h,010h,002h,002h,0e0h,0e1h,0e4h,0e5h,002h,002h,0e2h,0e3h	; 88ec  ................
	defb 0e6h,0e7h,002h,002h,0e8h,0e9h,0ech,0edh,002h,002h,0eah,0ebh,0eeh,0efh,002h,002h	; 88fc  ................
	defb 0fch,0fch,0fdh,0fdh,0c9h	; 890c

; ======================================================================
; CODIGO 0x8911..0x8930  (31 bytes)
; ======================================================================


ram_borra:		; 0x1200 bytes de 0xE100 a cero; y 16 objetos fuera
	ld hl,0e100h		;8911   ; desde 0xE100...
	ld bc,01200h		;8914   ; ...0x1200 bytes...
ram_borra_byte:
	ld (hl),000h		;8917   ; ...a cero
	inc hl			;8919
	dec bc			;891a
	ld a,c			;891b
	or b			;891c
	jr nz,ram_borra_byte		;891d
objetos_fuera:		; 16 objetos de 16 bytes desde 0xE300 fuera (Y 0xEC) y los sprites
	ld hl,0e300h		;891f   ; 16 objetos...
	ld de,00010h		;8922
	ld b,010h		;8925   ; 16
objetos_fuera_y:
	ld (hl),0ech		;8927   ; ...fuera
	add hl,de			;8929
	djnz objetos_fuera_y		;892a
	call sprites_rota		;892c   ; los sprites
	ret			;892f

; ----------------------------------------------------------------------
; DATOS codigo_suelto_8930: Codigo que nada llama: 0x100 bytes de 0xE400 a
;   cero, 0x80 de 0xE380, ocho objetos fuera, y 0x2C0 bytes de 0xE740 a la
;   tabla de nombres (0x1840)
;   0x8930..0x8963  (51 bytes)
DATA_codigo_suelto_8930:
	defb 021h,000h,0e4h,006h,000h,036h,000h,023h,010h,0fbh,0c9h,021h,080h,0e3h,006h,080h	; 8930  !....6.#...!....
	defb 036h,000h,023h,010h,0fbh,021h,080h,0e3h,011h,010h,000h,006h,008h,036h,0ech,019h	; 8940  6.#..!.......6..
	defb 010h,0fbh,0cdh,03eh,08bh,0c9h,021h,040h,0e7h,011h,040h,018h,001h,0c0h,002h,0cdh	; 8950  ...>..!@..@.....
	defb 05ch,000h,0c9h	; 8960

; ======================================================================
; CODIGO 0x8963..0x8a02  (159 bytes)
; ======================================================================


pantalla_abre:		; La pantalla de la fase (0xE740, en la RAM) aparece en la de nombres desde los dos lados hacia el centro: dos columnas (la de la izquierda y la de la derecha) cada 2 cuadros, 16 veces, 22 filas
	ld hl,0e740h		;8963   ; la columna de la izquierda en la RAM...
	ld (0e1a8h),hl		;8966
	ld hl,0e75fh		;8969   ; ...la de la derecha...
	ld (0e1aah),hl		;896c
	ld hl,01840h		;896f   ; ...y las dos en la VRAM (fila 2)
	ld (0e1ach),hl		;8972
	ld hl,0185fh		;8975   ; la columna 31 de la VRAM
	ld (0e1aeh),hl		;8978
	ld b,010h		;897b   ; 16 pasos
L_897D:
	ld hl,(0e1a8h)		;897d   ; los punteros de este paso
	ld (0e1a0h),hl		;8980
	ld hl,(0e1aah)		;8983
	ld (0e1a2h),hl		;8986
	ld hl,(0e1ach)		;8989
	ld (0e1a4h),hl		;898c
	ld hl,(0e1aeh)		;898f
	ld (0e1a6h),hl		;8992
	ld c,016h		;8995   ; 22 filas
	xor a			;8997   ; la cuenta a 0
	ld (0e010h),a		;8998
pantalla_abre_espera:
	ld a,(0e010h)		;899b   ; 2 cuadros
	cp 002h		;899e   ; 2?
	jr c,pantalla_abre_espera		;89a0
	xor a			;89a2   ; la cuenta a 0
	ld (0e010h),a		;89a3
pantalla_abre_fila:
	ld hl,(0e1a4h)		;89a6   ; la de la izquierda
	ld de,(0e1a0h)		;89a9
	ld a,(de)			;89ad   ; la casilla de la izquierda
	call 0004dh		;89ae   ; WRTVRM
	ld hl,(0e1a6h)		;89b1   ; la de la derecha
	ld de,(0e1a2h)		;89b4
	ld a,(de)			;89b8   ; la de la derecha
	call 0004dh		;89b9   ; WRTVRM
	ld hl,(0e1a4h)		;89bc   ; la fila siguiente
	ld de,00020h		;89bf   ; una fila abajo, en la VRAM
	add hl,de			;89c2
	ld (0e1a4h),hl		;89c3
	ld hl,(0e1a6h)		;89c6
	add hl,de			;89c9
	ld (0e1a6h),hl		;89ca
	ld de,00020h		;89cd   ; y en la RAM
	ld hl,(0e1a0h)		;89d0
	add hl,de			;89d3
	ld (0e1a0h),hl		;89d4
	ld hl,(0e1a2h)		;89d7
	add hl,de			;89da
	ld (0e1a2h),hl		;89db
	dec c			;89de   ; una fila menos
	jr nz,pantalla_abre_fila		;89df
	ld hl,(0e1a8h)		;89e1   ; la izquierda, una a la derecha...
	inc hl			;89e4
	ld (0e1a8h),hl		;89e5
	ld hl,(0e1aah)		;89e8   ; ...y la derecha, una a la izquierda
	dec hl			;89eb
	ld (0e1aah),hl		;89ec
	ld hl,(0e1ach)		;89ef
	inc hl			;89f2
	ld (0e1ach),hl		;89f3
	ld hl,(0e1aeh)		;89f6
	dec hl			;89f9
	ld (0e1aeh),hl		;89fa
	dec b			;89fd   ; un paso menos
	jp nz,L_897D		;89fe
	ret			;8a01

; ----------------------------------------------------------------------
; DATOS codigo_suelto_8A02: Codigo que nada llama: otra forma de abrir la
;   pantalla, desde el centro (0x1850 y 0x184F) hacia los lados, con casillas
;   en blanco
;   0x8a02..0x8a57  (85 bytes)
DATA_codigo_suelto_8A02:
	defb 021h,050h,018h,022h,0a0h,0e1h,006h,010h,021h,04fh,018h,022h,0a2h,0e1h,011h,020h	; 8a02  !P."....!O."... 
	defb 000h,0afh,032h,010h,0e0h,00eh,016h,02ah,0a0h,0e1h,0edh,05bh,0a2h,0e1h,03ah,010h	; 8a12  ..2....*...[..:.
	defb 0e0h,0feh,002h,038h,0f9h,0afh,032h,010h,0e0h,03eh,010h,0cdh,04dh,000h,0ebh,0cdh	; 8a22  ...8..2..>..M...
	defb 04dh,000h,0d5h,011h,020h,000h,019h,0d1h,0ebh,0d5h,011h,020h,000h,019h,0d1h,00dh	; 8a32  M... ...... ....
	defb 020h,0e7h,02ah,0a0h,0e1h,023h,022h,0a0h,0e1h,0edh,05bh,0a2h,0e1h,01bh,0edh,053h	; 8a42   .*..#"...[....S
	defb 0a2h,0e1h,010h,0c1h,0c9h	; 8a52

; ======================================================================
; CODIGO 0x8a57..0x8f56  (1279 bytes)
; ======================================================================


pantalla_cierra:		; La zona de juego (filas 2-23) se borra columna a columna, de izquierda a derecha, una cada 2 cuadros
	ld hl,01840h		;8a57   ; la fila 2, columna 0
	ld (0e1a0h),hl		;8a5a
	ld b,020h		;8a5d   ; 32 columnas
	xor a			;8a5f   ; la cuenta a 0
	ld (0e010h),a		;8a60
	ld de,00020h		;8a63
pantalla_cierra_columna:
	ld c,016h		;8a66   ; 22 filas
	ld hl,(0e1a0h)		;8a68
pantalla_cierra_espera:
	ld a,(0e010h)		;8a6b
	cp 002h		;8a6e   ; 2 cuadros?
	jr c,pantalla_cierra_espera		;8a70
	xor a			;8a72   ; la cuenta a 0
	ld (0e010h),a		;8a73
pantalla_cierra_fila:
	ld a,010h		;8a76   ; el espacio
	call 0004dh		;8a78   ; WRTVRM
	add hl,de			;8a7b   ; la fila siguiente
	dec c			;8a7c
	jr nz,pantalla_cierra_fila		;8a7d
	ld hl,(0e1a0h)		;8a7f
	inc hl			;8a82   ; la columna siguiente
	ld (0e1a0h),hl		;8a83
	djnz pantalla_cierra_columna		;8a86
	ret			;8a88
nombres_borra:		; La tabla de nombres llena de la casilla 0x10 (el espacio)
	ld a,010h		;8a89   ; el espacio...
	ld hl,01800h		;8a8b   ; ...en la tabla de nombres...
	ld bc,00300h		;8a8e   ; ...0x300 casillas
	call 00056h		;8a91   ; FILVRM
	ret			;8a94
letras_pon:		; Las letras (0x5000, 0x180 bytes) a la VRAM en DE; y DE al tercio siguiente
	ld hl,05000h		;8a95
tercio_copia:
	push bc			;8a98
	ld bc,00180h		;8a99   ; 0x180 bytes
tercio_copia_bc:
	call 0005ch		;8a9c   ; LDIRVM
	ld bc,00800h		;8a9f   ; al tercio siguiente
	add hl,bc			;8aa2
	ex de,hl			;8aa3   ; en DE
	pop bc			;8aa4
	ret			;8aa5
casillas_pon:		; Los dibujos de las casillas 0x30-0xFF (0x6180, 0x680 bytes) en DE
	push bc			;8aa6
	ld hl,06180h		;8aa7   ; los dibujos
	ld bc,00680h		;8aaa   ; 0x680 bytes
	jr tercio_copia_bc		;8aad
colores_pon:		; Sus colores (0x7180) en DE
	push bc			;8aaf
	ld hl,07180h		;8ab0   ; los colores
	ld bc,00680h		;8ab3
	jr tercio_copia_bc		;8ab6
colores_ocho:		; 8 bytes de colores a A en HL; y HL al tercio siguiente
	push bc			;8ab8
	ld bc,00008h		;8ab9
	call 00056h		;8abc   ; FILVRM
	ld de,00800h		;8abf   ; al tercio siguiente
	add hl,de			;8ac2
	pop bc			;8ac3
	ret			;8ac4
casillas_titulo:		; Las casillas del titulo: 0x6000 y 0x6800 en la tabla de dibujos, 0x7000 y 0x7800 en la de colores, en los tres tercios
	ld b,003h		;8ac5
	ld de,00180h		;8ac7   ; las casillas 0x30-0x5F
casillas_titulo_1:
	ld hl,06000h		;8aca
	call tercio_copia		;8acd
	djnz casillas_titulo_1		;8ad0
	ld b,003h		;8ad2
	ld de,00300h		;8ad4   ; las 0x60-0x8F
casillas_titulo_2:
	ld hl,06800h		;8ad7
	call tercio_copia		;8ada
	djnz casillas_titulo_2		;8add
	ld b,003h		;8adf
	ld de,02180h		;8ae1   ; sus colores
casillas_titulo_3:
	ld hl,07000h		;8ae4
	call tercio_copia		;8ae7
	djnz casillas_titulo_3		;8aea
	ld b,003h		;8aec
	ld de,02300h		;8aee   ; los de las otras
casillas_titulo_4:
	ld hl,07800h		;8af1
	call tercio_copia		;8af4
	djnz casillas_titulo_4		;8af7
	ret			;8af9
sprites_dibujos:		; Los dibujos de los sprites (0x5800, 0x800 bytes) a 0x3800
	ld de,03800h		;8afa
	ld hl,05800h		;8afd
	ld bc,00800h		;8b00   ; 0x800 bytes
	jp 0005ch		;8b03   ; LDIRVM
sprites_dibujos_otros:		; Otros dibujos (0x5400, 0x180 bytes) a 0x3800: los del modo de 0xE1B7
	ld de,03800h		;8b06
	ld hl,05400h		;8b09
	ld bc,00180h		;8b0c   ; 0x180 bytes
	jp 0005ch		;8b0f   ; LDIRVM
sonido_reinicia:		; 0xE007 = 0xFF: la interrupcion pone el sonido a cero (0xB07E)
	ld a,0ffh		;8b12
	ld (0e007h),a		;8b14   ; 0xE007 = 0xFF
	ret			;8b17
sprites_vram:		; Los 16 objetos de 0xE300 (16 bytes cada uno: los 4 primeros son sus atributos) a 0xE100 y a la VRAM (0x1B00, 0x40 bytes)
	ld hl,0e300h		;8b18   ; desde 0xE300
	ld de,0e100h		;8b1b   ; a 0xE100
	ld b,010h		;8b1e   ; 16
	call sprites_vram_uno		;8b20
	jr L_8B32		;8b23
sprites_vram_uno:
	push bc			;8b25
	ld bc,00004h		;8b26   ; cuatro bytes
	ldir		;8b29   ; los atributos
	ld bc,0000ch		;8b2b   ; el siguiente (+16)
	add hl,bc			;8b2e
	pop bc			;8b2f
	djnz sprites_vram_uno		;8b30
L_8B32:
	ld de,01b00h		;8b32   ; la tabla de atributos
	ld hl,0e100h		;8b35
	ld bc,00040h		;8b38   ; 0x40 bytes
	jp 0005ch		;8b3b   ; LDIRVM
sprites_rota:		; Cada cuadro: los sprites fuera; el ninja (dos sprites); y los objetos de 0xE320 que estan (+4) empezando cada vez por uno distinto (0xE1BC): con mas de cuatro en una linea, el que no se ve cambia
	ld hl,0e100h		;8b3e   ; 0x40 bytes...
	ld b,040h		;8b41
L_8B43:
	ld (hl),0ech		;8b43   ; ...fuera (Y 0xEC)
	inc hl			;8b45
	djnz L_8B43		;8b46
	ld hl,0e300h		;8b48   ; el ninja: dos sprites
	ld de,0e100h		;8b4b
	ld b,002h		;8b4e   ; dos
	call sprites_vram_uno		;8b50
	ld iy,0e320h		;8b53   ; los 14 objetos: cuantos hay?
	ld bc,00e00h		;8b57
	ld de,00010h		;8b5a   ; 16 bytes cada uno
L_8B5D:
	ld a,(iy+004h)		;8b5d   ; esta?
	and a			;8b60
	jr z,L_8B64		;8b61
	inc c			;8b63   ; uno mas
L_8B64:
	add iy,de		;8b64
	djnz L_8B5D		;8b66
	ld a,c			;8b68   ; ninguno: a la VRAM
	and a			;8b69
	jp z,L_8B32		;8b6a
	ld a,(0e1bch)		;8b6d   ; el primero, otro cada vez
	inc a			;8b70   ; uno mas
	ld (0e1bch),a		;8b71
	cp c			;8b74   ; pasa de los que hay?
	jr c,sprites_rota_busca		;8b75
	xor a			;8b77   ; vuelta al primero
	ld (0e1bch),a		;8b78
sprites_rota_busca:
	ld iy,0e320h		;8b7b
	ld a,(0e1bch)		;8b7f   ; cuantos saltar
	and a			;8b82
	jr z,sprites_rota_copia		;8b83
	ld b,a			;8b85
	ld de,00010h		;8b86
sprites_rota_salta:
	ld a,(iy+004h)		;8b89
	and a			;8b8c
	jr z,sprites_rota_vacio		;8b8d
	add iy,de		;8b8f   ; el siguiente
	djnz sprites_rota_salta		;8b91
	jr sprites_rota_copia		;8b93
sprites_rota_vacio:
	add iy,de		;8b95
	jr sprites_rota_salta		;8b97
sprites_rota_copia:
	ld de,0e108h		;8b99   ; desde el sprite 2
	ld b,c			;8b9c   ; los que hay
L_8B9D:
	ld a,(iy+004h)		;8b9d
	and a			;8ba0
	jr z,sprites_rota_hueco		;8ba1
	push bc			;8ba3   ; sus cuatro bytes
	push iy		;8ba4
	pop hl			;8ba6
	ld bc,00004h		;8ba7   ; cuatro bytes
	ldir		;8baa
	ld bc,0000ch		;8bac
	add hl,bc			;8baf
	push hl			;8bb0
	pop iy		;8bb1
	ld a,h			;8bb3   ; el final (0xE400)?
	cp 0e4h		;8bb4
	jr z,sprites_rota_vuelta		;8bb6
sprites_rota_sigue:
	pop bc			;8bb8   ; el siguiente
	djnz L_8B9D		;8bb9
	jp L_8B32		;8bbb   ; a la VRAM
sprites_rota_hueco:
	push bc			;8bbe
	push iy		;8bbf
	pop hl			;8bc1
	ld bc,00010h		;8bc2   ; el siguiente objeto
	add hl,bc			;8bc5
	push hl			;8bc6
	pop iy		;8bc7
	pop bc			;8bc9
	ld a,h			;8bca
	cp 0e4h		;8bcb   ; el final?
	jr nz,L_8B9D		;8bcd
	ld iy,0e320h		;8bcf   ; vuelta al primero
	jr L_8B9D		;8bd3
sprites_rota_vuelta:
	ld iy,0e320h		;8bd5   ; vuelta al primero
	jr sprites_rota_sigue		;8bd9
puntos_pinta:		; Las seis cifras de los puntos (0xE001) en la fila 1 y del record (0xE02E) en la fila 0, columna 25
	ld hl,0e001h		;8bdb
	ld de,01839h		;8bde   ; la fila 1, columna 25
	ld bc,00006h		;8be1
	call 0005ch		;8be4   ; LDIRVM
	ld hl,0e02eh		;8be7   ; el record
	ld de,01819h		;8bea   ; la fila 0, columna 25
	ld bc,00006h		;8bed
	jp 0005ch		;8bf0   ; LDIRVM
puntos_suma:		; Jugando, los puntos + A (BCD, las dos ultimas cifras, 0xE00E) con su acarreo; al pasar de 999999 el record se queda con los puntos; desde 1.000 (0xE00D 0x10 o mas; en pantalla 10.000), una vida mas, una vez (0xE03A); y las cifras y el record
	ld b,a			;8bf3   ; lo que se suma
	ld a,(0e000h)		;8bf4   ; jugando?
	and a			;8bf7
	ret z			;8bf8   ; no: nada
	ld a,(0e00eh)		;8bf9   ; las dos ultimas
	add a,b			;8bfc
	daa			;8bfd   ; en BCD
	ld (0e00eh),a		;8bfe   ; apuntadas
	jr nc,puntos_mira		;8c01   ; sin acarreo
	ld a,001h		;8c03   ; acarreo
puntos_suma_cien:
	ld b,a			;8c05
	ld a,(0e00dh)		;8c06   ; las centenas
	add a,b			;8c09
	daa			;8c0a
	ld (0e00dh),a		;8c0b   ; apuntadas
	jr nc,puntos_mira		;8c0e
	ld a,001h		;8c10   ; acarreo
	ld b,a			;8c12
	ld a,(0e00ch)		;8c13   ; las decenas de millar
	add a,b			;8c16
	daa			;8c17
	ld (0e00ch),a		;8c18   ; apuntadas
	jr nc,puntos_mira		;8c1b
	ld a,(0e00eh)		;8c1d   ; se pasa: el record = los puntos (pero ya han dado la vuelta: puntos y record, casi a cero)
	ld (0e036h),a		;8c20   ; el record: los puntos
	ld a,(0e00dh)		;8c23
	ld (0e035h),a		;8c26
	ld a,(0e00ch)		;8c29
	ld (0e034h),a		;8c2c
puntos_mira:
	ld a,(0e00dh)		;8c2f   ; 1.000 (10.000 en pantalla)?
	cp 010h		;8c32   ; 0x10?
	jr c,L_8C4B		;8c34
	ld a,(0e03ah)		;8c36   ; ya dada?
	and a			;8c39
	jr nz,L_8C4B		;8c3a
	inc a			;8c3c   ; dada
	ld (0e03ah),a		;8c3d   ; apuntada
	ld a,(0e00bh)		;8c40   ; una vida mas
	inc a			;8c43
	daa			;8c44
	ld (0e00bh),a		;8c45   ; apuntadas
	call vidas_pinta		;8c48   ; en el marcador
L_8C4B:
	call puntos_cifras		;8c4b   ; las cifras
	call record_mira		;8c4e   ; el record
	ret			;8c51
puntos_cifras:		; Los tres bytes BCD de los puntos (0xE00C) en seis cifras (0xE001), una por byte
	ld hl,0e001h		;8c52   ; las cifras
	ld de,0e00ch		;8c55   ; los bytes BCD
	ld b,003h		;8c58   ; tres
cifras_bcd:		; B bytes BCD de DE a cifras en HL (dos por byte)
	ld a,(de)			;8c5a   ; un byte
	ld c,a			;8c5b   ; guardado
	and 0f0h		;8c5c   ; la cifra alta
	rrca			;8c5e
	rrca			;8c5f
	rrca			;8c60
	rrca			;8c61
	ld (hl),a			;8c62   ; apuntada
	inc hl			;8c63   ; la siguiente
	ld a,c			;8c64   ; la baja
	and 00fh		;8c65
	ld (hl),a			;8c67   ; la baja
	inc hl			;8c68   ; la siguiente
	inc de			;8c69   ; el siguiente
	djnz cifras_bcd		;8c6a   ; tres bytes
	ret			;8c6c
record_mira:		; Si los puntos (0xE00C) pasan del record (0xE034), son el record nuevo y sus cifras (0xE02E)
	ld de,0e034h		;8c6d   ; el record
	ld hl,0e00ch		;8c70   ; los puntos
	ld a,(de)			;8c73   ; el byte alto...
	ld b,a			;8c74
	ld a,(hl)			;8c75   ; ...contra el de los puntos
	cp b			;8c76   ; menos: nada
	ret c			;8c77   ; menor: nada
	jr nz,record_nuevo_3		;8c78   ; mayor: record nuevo
	inc de			;8c7a   ; iguales: el siguiente
	inc hl			;8c7b
	ld a,(de)			;8c7c
	ld b,a			;8c7d
	ld a,(hl)			;8c7e
	cp b			;8c7f
	ret c			;8c80   ; menor: nada
	jr nz,record_nuevo_2		;8c81   ; mas: record
	inc de			;8c83   ; el bajo
	inc hl			;8c84
	ld a,(de)			;8c85
	ld b,a			;8c86
	ld a,(hl)			;8c87
	cp b			;8c88
	ret c			;8c89   ; menor: nada
	jr record_nuevo		;8c8a   ; igual o mas: record
record_nuevo_3:
	inc de			;8c8c
	inc hl			;8c8d
record_nuevo_2:
	inc de			;8c8e
	inc hl			;8c8f
record_nuevo:		; Los tres bytes, hacia atras
	ld bc,00003h		;8c90   ; tres bytes...
	lddr		;8c93   ; ...hacia atras
	ld hl,0e02eh		;8c95   ; sus cifras
	ld de,0e034h		;8c98   ; el record
	ld b,003h		;8c9b   ; tres bytes
	jr cifras_bcd		;8c9d
espera_musica:		; Espera 8 cuadros, despues hasta que la musica acabe (0xE2BD y 0xE2BE a 0; en el titulo, el boton la corta) y despues 16 cuadros mas
	xor a			;8c9f   ; la cuenta a 0
	ld (0e011h),a		;8ca0
L_8CA3:
	ld a,(0e011h)		;8ca3   ; un cuadro mas
	cp 008h		;8ca6   ; 8?
	jr c,L_8CA3		;8ca8
L_8CAA:
	call sprites_rota		;8caa   ; los sprites
	ld a,(0e000h)		;8cad   ; jugando?
	and a			;8cb0
	jr nz,espera_musica_mira		;8cb1
	ld a,(0e026h)		;8cb3   ; el boton?
	and a			;8cb6
	ret nz			;8cb7
espera_musica_mira:
	ld a,(0e2bdh)		;8cb8   ; sonando?
	and a			;8cbb
	jr nz,L_8CAA		;8cbc
	ld a,(0e2beh)		;8cbe   ; pedida?
	and a			;8cc1
	jr nz,L_8CAA		;8cc2
	ld (0e011h),a		;8cc4   ; la cuenta a 0
	call sonido_reinicia		;8cc7   ; el sonido a cero
L_8CCA:
	ld a,(0e011h)		;8cca   ; 16 cuadros mas
	cp 010h		;8ccd
	jr c,L_8CCA		;8ccf
	ret			;8cd1
interrupcion:		; La interrupcion (H.TIMI): el sonido a cero si se pidio (0xE007); sin nada sonando, B y C callados; el motor de sonido; 16 cuentas de cuadros (0xE010-0xE01F); jugando, F1 (0xE1B3: el ninja cae) y STOP (0xE1B5: el modo de 0xE1B7), los botones (0xE020: el 2 o GRAPH; 0xE022: el 1 o la barra) y la palanca
	ld a,(0e007h)		;8cd2   ; se pidio el sonido a cero?
	cp 0ffh		;8cd5
	jr nz,interrupcion_sonido		;8cd7
	call sonido_cero		;8cd9   ; a cero
	xor a			;8cdc
	ld (0e007h),a		;8cdd
interrupcion_sonido:
	ld a,(0e2bdh)		;8ce0   ; el canal de musica 1...
	ld b,a			;8ce3
	ld a,(0e2c1h)		;8ce4   ; ...y el 2
	add a,b			;8ce7   ; sonando alguno?
	and a			;8ce8   ; un efecto?
	jr nz,interrupcion_motor		;8ce9
	ld e,000h		;8ceb   ; sin efecto: los canales B y C a volumen 0
	ld a,009h		;8ced   ; ...a volumen 0
	call 00093h		;8cef   ; WRTPSG
	ld e,000h		;8cf2   ; el C...
	ld a,00ah		;8cf4
	call 00093h		;8cf6   ; ...WRTPSG
interrupcion_motor:
	call sonido		;8cf9   ; el motor de sonido
	ld hl,0e010h		;8cfc   ; 16 cuentas...
	ld b,010h		;8cff
L_8D01:
	inc (hl)			;8d01   ; ...una mas
	inc hl			;8d02
	djnz L_8D01		;8d03
	ld a,(0e000h)		;8d05   ; jugando?
	and a			;8d08
	jr z,interrupcion_quieto		;8d09
	ld a,006h		;8d0b   ; la fila 6: F1 (bit 5)?
	call 00141h		;8d0d
	bit 5,a		;8d10
	jr z,tecla_f1		;8d12
	xor a			;8d14   ; suelta
	ld (0e1b4h),a		;8d15
	jr tecla_stop		;8d18
tecla_f1:
	ld a,(0e1b4h)		;8d1a   ; ya sostenida?
	and a			;8d1d
	jr nz,tecla_stop		;8d1e
	inc a			;8d20   ; recien pulsada: el ninja cae (0xE1B3)
	ld (0e1b3h),a		;8d21
	ld (0e1b4h),a		;8d24
tecla_stop:
	ld a,007h		;8d27   ; la fila 7: STOP (bit 4)?
	call 00141h		;8d29
	bit 4,a		;8d2c
	jr z,tecla_stop_pulsada		;8d2e
	xor a			;8d30   ; suelta
	ld (0e1b6h),a		;8d31
	jr botones		;8d34
tecla_stop_pulsada:
	ld a,(0e1b6h)		;8d36
	and a			;8d39
	jr nz,botones		;8d3a
	inc a			;8d3c   ; recien pulsada: 0xE1B5
	ld (0e1b5h),a		;8d3d
	ld (0e1b6h),a		;8d40
botones:
	ld de,0e020h		;8d43   ; el boton 2 del mando (GTTRIG 3)
	ld hl,0e021h		;8d46
	ld a,003h		;8d49
	call boton_mando		;8d4b
	ld de,0e022h		;8d4e   ; el boton 1 (GTTRIG 1)
	ld hl,0e02dh		;8d51
	ld a,001h		;8d54
	call boton_mando		;8d56
	ld a,001h		;8d59   ; y sostenido
	call 000d8h		;8d5b
	ld (0e19dh),a		;8d5e
	ld de,0e020h		;8d61   ; GRAPH y la barra
	ld hl,0e02bh		;8d64
	call botones_teclado		;8d67
palanca:		; La palanca: los cursores o el mando 1 (GTSTCK 0 y 1), en 0xE180
	xor a			;8d6a
	call 000d5h		;8d6b   ; GTSTCK 0: los cursores
	ld (0e181h),a		;8d6e
	ld a,001h		;8d71
	call 000d5h		;8d73   ; GTSTCK 1: el mando 1
	ld c,a			;8d76
	ld a,(0e181h)		;8d77
	or c			;8d7a   ; uno u otro: un OR de dos numeros de direccion (1-8, no bits): con los dos a la vez sale otra
	ld (0e180h),a		;8d7b
	ret			;8d7e
interrupcion_quieto:		; Fuera de partida: en la demostracion (0xE027), cada 16 cuadros una entrada de la lista de 0xE037 (desde 0x5200): la mitad baja la palanca, la alta los botones (0x10 el 1, 0x20 el 2, otra los dos); en el titulo, el boton de empezar (0xE026) y la palanca
	ld a,(0e027h)		;8d7f   ; la demostracion?
	and a			;8d82
	jr z,interrupcion_titulo		;8d83
	ld a,(0e016h)		;8d85   ; cada 16 cuadros
	cp 010h		;8d88
	jr c,boton_empezar		;8d8a
	xor a			;8d8c
	ld (0e016h),a		;8d8d
	ld hl,(0e037h)		;8d90   ; la lista
	ld a,(hl)			;8d93
	inc hl			;8d94
	ld (0e037h),hl		;8d95
	ld b,a			;8d98
	and 00fh		;8d99   ; la palanca
	ld (0e180h),a		;8d9b
	ld a,b			;8d9e
	and 0f0h		;8d9f   ; los botones
	and a			;8da1
	jr z,boton_empezar		;8da2
	cp 010h		;8da4   ; 0x10: el boton 2 (0xE020)
	jr nz,L_8DAD		;8da6
	ld (0e020h),a		;8da8
	jr boton_empezar		;8dab
L_8DAD:
	cp 020h		;8dad   ; 0x20: el 1 (0xE022)
	jr nz,L_8DB6		;8daf
	ld (0e022h),a		;8db1
	jr boton_empezar		;8db4
L_8DB6:
	ld (0e020h),a		;8db6   ; otro: los dos
	ld (0e022h),a		;8db9
	jr boton_empezar		;8dbc
interrupcion_titulo:
	call boton_empezar		;8dbe
	jr palanca		;8dc1
boton_empezar:		; El boton de empezar (0xE026): la barra o el boton 1 del mando
	ld de,0e026h		;8dc3
	ld hl,0e025h		;8dc6
	call barra_lee		;8dc9
	ld a,(de)			;8dcc
	ld (0e181h),a		;8dcd
	ld hl,0e021h		;8dd0
	ld a,001h		;8dd3
	call boton_mando		;8dd5
	ld a,(de)			;8dd8   ; ...o lo del mando
	ld b,a			;8dd9
	ld a,(0e181h)		;8dda   ; una...
	or b			;8ddd   ; ...u otro
	ld (de),a			;8dde
	ret			;8ddf
boton_mando:		; GTTRIG A: lo recien pulsado en (DE) y lo sostenido en (HL)
	call 000d8h		;8de0   ; GTTRIG
	and a			;8de3
boton_mira:
	jr nz,boton_pulsado		;8de4   ; pulsado?
boton_suelto:
	ld (hl),000h		;8de6   ; suelto
	ret			;8de8
boton_pulsado:
	ld a,(hl)			;8de9   ; ya sostenido?
	and a			;8dea
	ret nz			;8deb
	inc a			;8dec   ; recien pulsado
	ld (hl),a			;8ded   ; sostenido
	ld (de),a			;8dee   ; recien pulsado
	ret			;8def
barra_lee:		; La barra (fila 8, bit 0): lo mismo
	ld a,008h		;8df0   ; la fila 8...
	call 00141h		;8df2   ; SNSMAT
	rrca			;8df5   ; el bit 0: pulsada = 0
	jr nc,boton_pulsado		;8df6
	jr boton_suelto		;8df8
botones_teclado:		; La barra como boton 1 y GRAPH (fila 6, bit 2) como boton 2
	ld a,006h		;8dfa   ; la fila 6
	call 00141h		;8dfc   ; SNSMAT
	cpl			;8dff   ; pulsada = 1
	bit 2,a		;8e00   ; GRAPH (bit 2)
	call boton_mira		;8e02
	inc hl			;8e05   ; los siguientes
	inc de			;8e06
	inc de			;8e07
	ld a,008h		;8e08   ; la fila 8
	call 00141h		;8e0a   ; SNSMAT
	cpl			;8e0d
	push af			;8e0e
	rrca			;8e0f   ; la barra: el bit 0
	jr nc,barra_suelta		;8e10
	ld a,0ffh		;8e12
	jr barra_sostenida		;8e14
barra_suelta:
	xor a			;8e16
barra_sostenida:
	ld b,a			;8e17
	ld a,(0e19dh)		;8e18   ; con el boton 1 del mando, sostenido
	or b			;8e1b
	ld (0e19dh),a		;8e1c
	pop af			;8e1f
	bit 0,a		;8e20
	jr boton_mira		;8e22
presentacion:		; La presentacion de CASIO: cada 3 cuadros, dos CASIO entran por los lados (filas 11 y 12) y, desde el paso 9, otros dos bajan y suben hacia el centro; con el paso 21, la musica 4 y SOFTWARE (0x8B14) debajo; 128 cuadros o el boton y la pantalla en blanco
	ld a,001h		;8e24   ; el paso 1
	ld (0e187h),a		;8e26
	ld hl,0180ch		;8e29   ; el que baja: la fila 0, columna 12
	ld (0e189h),hl		;8e2c
	ld hl,01aech		;8e2f   ; el que sube: la fila 23
	ld (0e18bh),hl		;8e32
presentacion_cuadro:
	ld a,(0e014h)		;8e35   ; 3 cuadros
	cp 003h		;8e38
	jr c,presentacion_cuadro		;8e3a
	xor a			;8e3c
	ld (0e014h),a		;8e3d
	call presentacion_lineas		;8e40
	call presentacion_lados		;8e43
	ld hl,0e187h		;8e46   ; un paso mas
	inc (hl)			;8e49
	ld a,(hl)			;8e4a
	cp 015h		;8e4b   ; 21?
	jr nc,presentacion_junta		;8e4d
	cp 009h		;8e4f   ; desde el 9...
	jr c,presentacion_sigue		;8e51
	ld hl,(0e189h)		;8e53   ; ...el de arriba baja una fila...
	ld bc,00020h		;8e56
	add hl,bc			;8e59
	ld (0e189h),hl		;8e5a
	ld hl,(0e18bh)		;8e5d   ; ...y el de abajo sube
	sbc hl,bc		;8e60
	ld (0e18bh),hl		;8e62
presentacion_sigue:
	jr presentacion_cuadro		;8e65
presentacion_junta:
	ld a,004h		;8e67   ; la musica 4
	call musica_pide		;8e69   ; pide la musica
	ld hl,08f72h		;8e6c
	ld de,019cch		;8e6f   ; ...en la fila 14, columna 12
	ld bc,00007h		;8e72
	call 0005ch		;8e75   ; LDIRVM
presentacion_espera:
	ld a,(0e026h)		;8e78   ; el boton?
	and a			;8e7b
	jr nz,L_8E85		;8e7c
	ld a,(0e014h)		;8e7e   ; 128 cuadros?
	cp 080h		;8e81
	jr c,presentacion_espera		;8e83
L_8E85:
	xor a			;8e85
	ld (0e026h),a		;8e86
	call sonido_reinicia		;8e89
	call nombres_borra		;8e8c
	ret			;8e8f
presentacion_lineas:		; Desde el paso 9: el CASIO que baja (las dos filas de 0x8F57 y 0x8F60 con una en blanco, 0x8F69, encima) y el que sube (con la blanca debajo)
	ld a,(0e187h)		;8e90   ; el paso 9?
	cp 009h		;8e93
	ret c			;8e95
	ld bc,00008h		;8e96   ; la fila de abajo del que baja...
	ld hl,08f60h		;8e99
	ld de,(0e189h)		;8e9c
	call 0005ch		;8ea0
	ld de,00020h		;8ea3
	and a			;8ea6
	sbc hl,de		;8ea7
	ex de,hl			;8ea9
	ld hl,08f57h		;8eaa   ; ...la de arriba...
	ld bc,00008h		;8ead
	call 0005ch		;8eb0
	ld de,00020h		;8eb3
	and a			;8eb6
	sbc hl,de		;8eb7
	ex de,hl			;8eb9
	ld hl,08f69h		;8eba   ; ...y la blanca encima
	ld bc,00008h		;8ebd
	call 0005ch		;8ec0
	ld bc,00008h		;8ec3   ; el que sube: la de arriba...
	ld hl,08f57h		;8ec6
	ld de,(0e18bh)		;8ec9
	call 0005ch		;8ecd
	ld de,00020h		;8ed0
	add hl,de			;8ed3
	ex de,hl			;8ed4
	ld hl,08f60h		;8ed5   ; ...la de abajo...
	ld bc,00008h		;8ed8
	call 0005ch		;8edb
	ld de,00020h		;8ede
	add hl,de			;8ee1
	ex de,hl			;8ee2
	ld hl,08f69h		;8ee3   ; ...y la blanca debajo
	ld bc,00008h		;8ee6
	call 0005ch		;8ee9   ; LDIRVM
	ret			;8eec
presentacion_lados:		; Los dos CASIO de los lados en las filas 11 y 12: uno entra por la derecha casilla a casilla y el otro por la izquierda, leido desde el final
	ld a,(0e187h)		;8eed   ; el paso
	ld c,a			;8ef0
	cp 009h		;8ef1   ; ...no mas de 9
	jr c,presentacion_arriba		;8ef3
	ld c,009h		;8ef5   ; 9 como mucho
presentacion_arriba:
	ld hl,01980h		;8ef7   ; en la fila 12, columna 0, menos el paso
	ld b,a			;8efa   ; la columna, hacia la izquierda
	ld a,l			;8efb
	sub b			;8efc
	ld l,a			;8efd
	ex de,hl			;8efe
	ld hl,08f57h		;8eff   ; la fila de arriba de CASIO...
	ld b,000h		;8f02
	call 0005ch		;8f04
	ld de,00020h		;8f07
	add hl,de			;8f0a
	ex de,hl			;8f0b
	ld hl,08f60h		;8f0c
	ld a,(0e187h)		;8f0f
	cp 009h		;8f12
	jr c,L_8F18		;8f14
	ld a,009h		;8f16
L_8F18:
	ld c,a			;8f18   ; C casillas
	call 0005ch		;8f19   ; LDIRVM
	ld hl,01960h		;8f1c   ; el otro: la fila 11
	ld a,(0e187h)		;8f1f
	ld c,a			;8f22
	cp 009h		;8f23   ; 9 o mas?
	jr c,L_8F2D		;8f25
	sub 009h		;8f27   ; pasado el 9, se mueve
	add a,l			;8f29
	ld l,a			;8f2a
	ld c,009h		;8f2b   ; 9
L_8F2D:
	ex de,hl			;8f2d   ; DE: la VRAM
	ld hl,08f5fh		;8f2e   ; la fila de arriba, desde el final
	ld a,l			;8f31
	sub c			;8f32   ; - C
	jr nc,L_8F36		;8f33
	dec h			;8f35
L_8F36:
	ld l,a			;8f36
	call 0005ch		;8f37   ; LDIRVM
	ld de,00020h		;8f3a   ; una fila abajo
	add hl,de			;8f3d
	ex de,hl			;8f3e
	ld a,(0e187h)		;8f3f   ; el paso
	ld c,a			;8f42
	cp 009h		;8f43
	jr c,L_8F49		;8f45
	ld c,009h		;8f47
L_8F49:
	ld hl,08f68h		;8f49
	ld a,l			;8f4c
	sub c			;8f4d
	jr nc,L_8F51		;8f4e
	dec h			;8f50
L_8F51:
	ld l,a			;8f51
	call 0005ch		;8f52   ; LDIRVM
	ret			;8f55

; ----------------------------------------------------------------------
; DATOS presentacion_datos: Las filas del logotipo de CASIO (0x8F57, 0x8F60),
;   la blanca (0x8F69), SOFTWARE (0x8F72); el nombre del juego en casillas
;   (0x8F79: dos filas de 10 y tres de 16); los textos: GAME START (0x9026),
;   CASIO en casillas (0x9030), PUSH TRIG:1 OR SPACE (0x9049), COPYRIGHT 1986
;   (c) CASIO (0x905D), HISCORE: (0x9073; SCORE:, 0x9075), GAME OVER (0x907B)
;   y los creditos del final (0x9084: STAFF, K;ARISAWA, K;ASAHINA, T;SATHO,
;   T;TSUJITANI, K;OHSAWA, A;HASEGAWA, M;K, PRODUCER, T;MORIYAMA); y 44 bytes
;   de restos de otro programa (0x90D4): unos puntos con tope en 999999 y una
;   vida mas con 0xE00D 0x30 (0xE1D3)
;   0x8f56..0x9100  (426 bytes)
DATA_presentacion_datos:
	defb 010h,030h,032h,034h,036h,038h,03ah,03ch,03eh,010h,031h,033h,035h,037h,039h,03bh	; 8f56  .02468:<>.13579;
	defb 03dh,03fh,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,080h,081h,082h,083h	; 8f66  =?..............
	defb 084h,085h,086h,040h,042h,044h,046h,048h,04ah,04ch,04eh,050h,052h,041h,043h,045h	; 8f76  ...@BDFHJLNPRACE
	defb 047h,049h,04bh,04dh,04fh,051h,053h,054h,055h,056h,057h,060h,061h,062h,063h,07ch	; 8f86  GIKMOQSTUVW`abc|
	defb 010h,010h,07dh,07eh,07fh,010h,010h,058h,059h,05ah,05bh,064h,065h,066h,067h,06ch	; 8f96  ..}~...XYZ[defgl
	defb 06dh,06eh,06fh,074h,075h,076h,077h,05ch,05dh,05eh,05fh,068h,069h,06ah,06bh,070h	; 8fa6  mnotuvw\]^_hijkp
	defb 071h,072h,073h,078h,079h,07ah,07bh,040h,041h,042h,043h,06dh,051h,052h,053h,06dh	; 8fb6  qrsxyz{@ABCmQRSm
	defb 061h,062h,06dh,06dh,044h,048h,04ch,07fh,06dh,045h,046h,047h,054h,055h,056h,057h	; 8fc6  abmmDHL.mEFGTUVW
	defb 06dh,065h,066h,06dh,06dh,04fh,050h,05bh,077h,06dh,049h,04ah,04bh,058h,059h,05ah	; 8fd6  mefmmOP[wmIJKXYZ
	defb 06dh,06dh,069h,06ah,06dh,06dh,05fh,060h,064h,06eh,06dh,04dh,04eh,06dh,05ch,05dh	; 8fe6  mmijmm_`dnmMNm\]
	defb 05eh,06dh,06dh,067h,06bh,06dh,068h,06ch,063h,06dh,077h,070h,071h,072h,073h,074h	; 8ff6  ^mmgkmhlcmwpqrst
	defb 075h,076h,075h,078h,079h,07ah,07bh,07ch,07dh,07eh,07ch,06fh,07bh,064h,06ch,0e8h	; 9006  uvuxyz{|}~|o{dl.
	defb 0eah,071h,073h,078h,07fh,068h,065h,0e9h,070h,072h,074h,07ch,01fh,026h,015h,022h	; 9016  .qsx.he.prt|.&."
	defb 017h,011h,01dh,015h,010h,023h,024h,011h,022h,024h,08ah,08bh,08ch,08dh,08eh,08fh	; 9026  .....#$."$......
	defb 024h,018h,015h,010h,023h,024h,01fh,01eh,015h,010h,01fh,016h,010h,027h,019h,023h	; 9036  $...#$.......'.#
	defb 014h,01fh,01dh,020h,025h,023h,018h,010h,024h,022h,019h,017h,00ah,001h,010h,01fh	; 9046  ... %#..$"......
	defb 022h,010h,023h,020h,011h,013h,015h,013h,01fh,020h,029h,022h,019h,017h,018h,024h	; 9056  ".# ..... )"...$
	defb 010h,001h,009h,008h,006h,010h,089h,010h,013h,011h,023h,019h,01fh,018h,019h,023h	; 9066  ..........#....#
	defb 013h,01fh,022h,015h,00ah,017h,011h,01dh,015h,010h,01fh,026h,015h,022h,023h,024h	; 9076  .."........&."#$
	defb 011h,016h,016h,01bh,00bh,011h,022h,019h,023h,011h,027h,011h,01bh,00bh,011h,023h	; 9086  ......".#.'....#
	defb 011h,018h,019h,01eh,011h,024h,00bh,023h,011h,024h,018h,01fh,024h,00bh,024h,023h	; 9096  .....$.#.$..$.$#
	defb 025h,01ah,019h,024h,011h,01eh,019h,01bh,00bh,01fh,018h,023h,011h,027h,011h,011h	; 90a6  %..$.......#.'..
	defb 00bh,018h,011h,023h,015h,017h,011h,027h,011h,01dh,00bh,01bh,020h,022h,01fh,014h	; 90b6  ...#...'.... "..
	defb 025h,013h,015h,022h,024h,00bh,01dh,01fh,022h,019h,029h,011h,01dh,011h,090h,0e1h	; 90c6  %.."$...".).....
	defb 03eh,001h,047h,03ah,00ch,0e0h,080h,027h,032h,00ch,0e0h,030h,009h,021h,00ch,0e0h	; 90d6  >.G:...'2..0.!..
	defb 006h,003h,036h,099h,010h,0fch,03ah,0d3h,0e1h,0a7h,020h,014h,03ah,00dh,0e0h,0feh	; 90e6  ..6...:... .:...
	defb 030h,038h,00dh,032h,0d3h,0e1h,03ah,00bh,0e0h,03ch	; 90f6  08.2..:..<

; ======================================================================
; CODIGO 0x9100..0x9697  (1431 bytes)
; ======================================================================


shuriken:		; El shuriken (IX+0x20, un sprite): con el boton 1 (0xE022) sale uno, si no hay otro: el efecto A 4, a la altura del ninja (+5, +4 mas agachado), dibujo 0xA4, color 15, hacia donde mira (+0xB -> +0x25); va 4 puntos por cuadro y cambia de dibujo (0xA4 / 0xA8) cada 2; en el borde, fuera
	ld a,(ix+024h)		;9100   ; ya va uno?
	and a			;9103
	jr nz,shuriken_mueve		;9104
	ld a,(0e022h)		;9106   ; el boton 1?
	and a			;9109
	ret z			;910a
	xor a			;910b   ; gastado
	ld (0e022h),a		;910c
	ld a,004h		;910f   ; el efecto A 4
	call efecto_a_pide		;9111
	ld (ix+024h),001h		;9114   ; en marcha
	ld a,(ix+00bh)		;9118   ; hacia donde mira el ninja
	ld (ix+025h),a		;911b
	ld a,(ix+000h)		;911e   ; la Y del ninja + 5
	add a,005h		;9121
	ld (ix+020h),a		;9123
	ld a,(ix+001h)		;9126   ; su X
	ld (ix+021h),a		;9129
	ld (ix+022h),0a4h		;912c   ; dibujo 0xA4, color 15
	ld (ix+023h),00fh		;9130
	ld a,(ix+00ah)		;9134   ; agachado?
	and a			;9137
	jr z,shuriken_mueve		;9138
	ld a,(ix+020h)		;913a   ; 4 mas abajo
	add a,004h		;913d
	ld (ix+020h),a		;913f
shuriken_mueve:
	ld a,(ix+025h)		;9142   ; a la izquierda?
	and a			;9145
	jr z,shuriken_derecha		;9146
	ld a,(ix+021h)		;9148   ; en el borde?
	cp 005h		;914b
	jr c,shuriken_fuera		;914d
	sub 004h		;914f   ; 4 a la izquierda
	ld (ix+021h),a		;9151
	jr shuriken_dibujo		;9154
shuriken_derecha:
	ld a,(ix+021h)		;9156   ; en el borde?
	cp 0ebh		;9159
	jr nc,shuriken_fuera		;915b
	add a,004h		;915d   ; 4 a la derecha
	ld (ix+021h),a		;915f
shuriken_dibujo:
	ld a,(0e012h)		;9162   ; cada 2 cuadros...
	and 002h		;9165
	rlca			;9167
	add a,0a4h		;9168   ; ...0xA4 o 0xA8
	ld (ix+022h),a		;916a
	ret			;916d
shuriken_fuera:
	ld (ix+020h),0ech		;916e   ; fuera
	xor a			;9172   ; y el boton gastado
	ld (ix+024h),a		;9173
	ld (ix+025h),a		;9176
	ld (0e022h),a		;9179
	ret			;917c
objeto_cogido:		; Lo que el ninja ha cogido (+0x17): 4, una vida mas; 2, todos los enemigos en pantalla con su paso por debajo de 5 pasan al 8 y tres cuentas (0xE1C0, 0xE1C1, 0xE1CA) a 0xF0; los demas, un poder (+0x18) que dura 5 x 256 cuadros (+0x19, +0x1A), con el ninja de su color (15, 9, 11, 3 o 13) parpadeando al final; despues, el ninja, los enemigos y sus balas
	ld a,(ix+017h)		;917d   ; algo cogido?
	and a			;9180
	jr z,poder_mira		;9181
	cp 004h		;9183   ; el 4?
	jr nz,objeto_cogido_2		;9185
	ld a,(0e00bh)		;9187   ; una vida mas
	inc a			;918a
	daa			;918b
	ld (0e00bh),a		;918c
	call vidas_pinta		;918f   ; en el marcador
	ld (ix+017h),000h		;9192
	jp ninja_todo		;9196
objeto_cogido_2:
	cp 002h		;9199   ; el 2?
	jr nz,poder_empieza		;919b
	ld hl,0e364h		;919d   ; los 10 enemigos (0xE360, +4)...
	ld de,00010h		;91a0
	ld b,00ah		;91a3
L_91A5:
	ld a,(hl)			;91a5   ; esta?
	and a			;91a6
	jr z,objeto_cogido_2_sigue		;91a7
	inc hl			;91a9
	ld a,(hl)			;91aa
	dec hl			;91ab
	cp 005h		;91ac   ; su paso por debajo de 5?
	jr nc,objeto_cogido_2_sigue		;91ae
	inc hl			;91b0   ; al 8
	ld (hl),008h		;91b1
	dec hl			;91b3
objeto_cogido_2_sigue:
	add hl,de			;91b4
	djnz L_91A5		;91b5
	ld (ix+017h),000h		;91b7
	ld a,0f0h		;91bb   ; tres cuentas a 0xF0
	ld (0e1c0h),a		;91bd
	ld (0e1c1h),a		;91c0
	ld (0e1cah),a		;91c3
	jr ninja_todo		;91c6
poder_empieza:
	ld (ix+018h),a		;91c8   ; el poder
	ld (ix+017h),000h		;91cb
	ld (ix+019h),000h		;91cf   ; su cuenta a 0
	ld (ix+01ah),000h		;91d3
	jr poder_cuenta		;91d7
poder_mira:
	ld a,(ix+018h)		;91d9   ; un poder?
	and a			;91dc
	jr z,ninja_todo		;91dd
poder_cuenta:
	inc (ix+019h)		;91df   ; uno mas
	jr nz,poder_acaba		;91e2
	inc (ix+01ah)		;91e4
poder_acaba:
	ld a,(ix+01ah)		;91e7   ; 5 x 256 cuadros?
	cp 005h		;91ea
	jr c,poder_parpadea		;91ec
	ld (ix+018h),000h		;91ee   ; acabado: el ninja de color 5
	ld (ix+019h),000h		;91f2
	ld (ix+01ah),000h		;91f6
	ld (ix+003h),005h		;91fa
	jr ninja_todo		;91fe
poder_parpadea:
	cp 004h		;9200   ; el ultimo tramo: cada 2 cuadros...
	jr c,poder_parpadea_lento		;9202
	ld a,(0e012h)		;9204
	and 002h		;9207
	jr poder_color		;9209
poder_parpadea_lento:
	ld a,(0e012h)		;920b   ; ...si no, cada 8
	and 008h		;920e
poder_color:
	and a			;9210
	jr nz,poder_su_color		;9211
	ld (ix+003h),a		;9213   ; color 0
	jr ninja_todo		;9216
poder_su_color:
	ld a,(ix+018h)		;9218   ; el color del poder: 1, 15...
	ld b,00fh		;921b
	cp 001h		;921d
	jr z,L_9235		;921f
	ld b,009h		;9221   ; 2, 9
	cp 002h		;9223
	jr z,L_9235		;9225
	ld b,00bh		;9227   ; 3, 11
	cp 003h		;9229
	jr z,L_9235		;922b
	ld b,003h		;922d   ; 5, 3
	cp 005h		;922f
	jr z,L_9235		;9231
	ld b,00dh		;9233   ; los demas, 13
L_9235:
	ld (ix+003h),b		;9235
ninja_todo:
	call ninja_cae_suelo		;9238   ; el ninja
	call cofre_abre		;923b   ; los enemigos
	call ninja_coge		;923e   ; sus balas
	ret			;9241
ninja_mueve:		; El ninja segun la palanca (0xE180: 1 arriba, 2 arriba y derecha... 8 arriba e izquierda): saltando (+9 = 2 o 3) sigue el salto; en una escalera (+6: 2, 4, 6 u 8) sigue por ella; las diagonales suben o bajan escaleras (las casillas 0x30-0x35 del mapa); a los lados anda, y pasada la mitad de la pantalla el mapa corre (0xE190, 0xE195) y los enemigos con el; abajo, agachado (+0xA)
	ld (ix+00ah),000h		;9242   ; de pie...
	ld (ix+00dh),000h		;9246   ; ...y quieto
	ld a,(ix+009h)		;924a   ; saltando?
	cp 002h		;924d   ; a la derecha?
	jp z,ninja_derecha		;924f
	cp 003h		;9252   ; a la izquierda?
	jp z,ninja_izquierda		;9254
	ld a,(0e180h)		;9257   ; la palanca
	and a			;925a   ; suelta?
	jr z,ninja_mueve_fin		;925b
	cp 001h		;925d   ; arriba: nada
	jr z,ninja_mueve_fin		;925f
	cp 002h		;9261   ; 2: arriba y a la derecha
	jp z,ninja_sube_der		;9263
	cp 008h		;9266   ; 8: arriba y a la izquierda
	jp z,ninja_sube_izq		;9268
	cp 004h		;926b   ; 4: abajo y a la derecha
	jp z,ninja_baja_der		;926d
	cp 005h		;9270   ; 5: abajo
	jp z,ninja_agacha		;9272
	cp 006h		;9275   ; 6: abajo y a la izquierda
	jp z,ninja_baja_izq		;9277
	cp 007h		;927a   ; 7: a la izquierda
	jp z,ninja_izquierda		;927c
	cp 003h		;927f   ; 3: a la derecha
	jp z,ninja_derecha		;9281
ninja_mueve_fin:
	ret			;9284
ninja_sube_der:		; Arriba y a la derecha: si hay escalera (0x32-0x35 en el mapa), sube 8 por ella (+6 = 2); arriba del todo (0x31), fuera de ella
	ld a,(ix+009h)		;9285   ; cayendo?
	cp 001h		;9288   ; cayendo: andar
	jp z,ninja_derecha		;928a
	call casilla_der		;928d   ; la casilla de delante
	cp 060h		;9290   ; desde 0x60, nada
	jr nc,L_92C7		;9292
	cp 030h		;9294   ; escalera?
	jr c,L_92C7		;9296
	cp 032h		;9298   ; 0x30-0x31: subir
	jr c,ninja_sube_der_paso		;929a
	cp 036h		;929c   ; 0x36 o mas: nada
	jr nc,L_92C4		;929e
	jr L_92C7		;92a0
ninja_sube_der_paso:
	call ninja_paso		;92a2   ; algo encima?
	jp c,ninja_mira_der		;92a5   ; espera: mirando a la derecha
	ld (ix+006h),002h		;92a8   ; en la escalera, subiendo a la derecha
	ld a,(ix+000h)		;92ac   ; 8 arriba
	sub 008h		;92af   ; 8 arriba
	ld (ix+000h),a		;92b1
	ld (ix+010h),a		;92b4   ; los dos sprites
	ld a,(hl)			;92b7   ; la casilla
	cp 031h		;92b8   ; el final de la escalera?
	jp nz,mapa_corre_der_paso		;92ba   ; no: el mapa corre
	ld (ix+006h),000h		;92bd   ; fuera de ella
	jp mapa_corre_der_paso		;92c1
L_92C4:
	jp ninja_mueve_fin		;92c4
L_92C7:
	jr ninja_derecha		;92c7
ninja_baja_der:		; Abajo y a la derecha: si hay escalera debajo (0x33-0x35), baja 8 por ella (+6 = 4); abajo del todo (0x35), fuera de ella
	ld a,(ix+009h)		;92c9   ; cayendo?
	cp 001h		;92cc
	jp z,ninja_derecha		;92ce
	call casilla_der		;92d1   ; la casilla de debajo
	add hl,de			;92d4   ; dos filas mas abajo
	add hl,de			;92d5
	ld a,(hl)			;92d6
	cp 033h		;92d7   ; 0x33-0x35?
	jr c,L_92FF		;92d9
	cp 036h		;92db
	jr nc,L_92FF		;92dd
	call ninja_paso		;92df   ; espera?
	jp c,ninja_mira_der		;92e2
	ld (ix+006h),004h		;92e5   ; bajando a la derecha
	ld a,(ix+000h)		;92e9
	add a,008h		;92ec   ; 8 abajo
	ld (ix+000h),a		;92ee
	ld (ix+010h),a		;92f1   ; los dos sprites
	ld a,(hl)			;92f4
	cp 035h		;92f5   ; el final de la escalera?
	jr nz,mapa_corre_der_paso		;92f7
	ld (ix+006h),000h		;92f9   ; fuera de ella
	jr mapa_corre_der_paso		;92fd
L_92FF:
	jp ninja_agacha		;92ff   ; no: agachado
ninja_derecha:		; A la derecha: en una escalera, sigue por ella; en el borde (0xEC), nada; pasada la X 0x74, desde la fase 2 y con el mapa sin acabar (0xE190 < 0x3F), corre el mapa; si no, anda un punto (cayendo, uno de cada dos cuadros)
	ld a,(ix+006h)		;9302   ; en la escalera?
	cp 002h		;9305   ; subiendo?
	jp z,ninja_sube_der		;9307
	cp 004h		;930a   ; bajando?
	jp z,ninja_baja_der		;930c
	cp 006h		;930f
	jp z,ninja_sube_der		;9311
	cp 008h		;9314
	jp z,ninja_baja_der		;9316
	ld a,(ix+001h)		;9319   ; en el borde?
	cp 0ech		;931c   ; en el borde?
	jp nc,ninja_anda_der_fin		;931e
	cp 074h		;9321   ; pasada la mitad?
	jr c,ninja_anda_der		;9323   ; antes de la mitad: anda
	ld a,(0e00ah)		;9325
	cp 006h		;9328
	jr z,ninja_anda_der		;932a   ; la 6: anda
	cp 002h		;932c   ; las fases 0 y 1: el mapa corre siempre
	jr c,mapa_corre_der		;932e
	ld a,(0e190h)		;9330   ; el final del mapa?
	cp 03fh		;9333   ; el final?
	jr c,mapa_corre_der		;9335
ninja_anda_der:
	call libre_der		;9337   ; libre a la derecha?
	jp nc,ninja_anda_der_fin		;933a   ; no: quieto
	ld a,(ix+009h)		;933d   ; cayendo?
	cp 001h		;9340   ; cayendo?
	jr nz,ninja_anda_der_paso		;9342
	inc (ix+00fh)		;9344   ; uno de cada dos cuadros
	ld a,(ix+00fh)		;9347   ; cada dos
	cp 002h		;934a
	jp c,ninja_mira_der		;934c
	ld (ix+00fh),000h		;934f   ; a cero
ninja_anda_der_paso:
	inc (ix+001h)		;9353   ; un punto a la derecha
	inc (ix+011h)		;9356   ; el segundo sprite
	call ninja_suelo		;9359   ; su dibujo
	jp ninja_anda_der_fin		;935c   ; andando
mapa_corre_der:
	call ninja_paso		;935f   ; algo encima?
	jp c,ninja_mira_der		;9362   ; espera
	ld a,(ix+006h)		;9365   ; en una escalera: no
	and a			;9368
	jp nz,ninja_mira_der		;9369   ; en la escalera: no
	call libre_der		;936c   ; libre?
	jp nc,ninja_anda_der_fin		;936f   ; no: quieto
mapa_corre_der_paso:		; El mapa una columna a la izquierda (0xE190, de 0x20 a 0x40: cada 0x20, la posicion 0xE051 + 1 y otro trozo); 0xE195 + 1; y los enemigos, 8 a la izquierda
	ld a,(0e190h)		;9372   ; una columna mas
	inc a			;9375
	ld (0e190h),a		;9376   ; apuntada
	cp 040h		;9379   ; 0x40?
	jr c,mapa_corre_cuenta		;937b   ; no
	ld a,020h		;937d   ; vuelta a 0x20...
	ld (0e190h),a		;937f   ; 0x20
	ld hl,0e051h		;9382   ; ...la posicion siguiente...
	inc (hl)			;9385   ; la posicion siguiente
	call mapa_avanza		;9386   ; ...y su trozo
mapa_corre_cuenta:
	ld hl,0e195h		;9389
	inc (hl)			;938c   ; 0xE195 + 1
	ld iy,0e360h		;938d   ; los 10 enemigos
	ld b,00ah		;9391   ; 10
	ld de,00010h		;9393
otros_corren_izq:
	ld a,(iy+004h)		;9396   ; esta?
	and a			;9399   ; esta?
	jr z,otros_corren_sig		;939a
	ld a,(iy+001h)		;939c   ; 8 a la izquierda
	sub 008h		;939f
	ld (iy+001h),a		;93a1   ; apuntada
otros_corren_sig:
	add iy,de		;93a4   ; el siguiente
	djnz otros_corren_izq		;93a6
mapa_pinta:
	call mapa_pantalla		;93a8   ; el mapa a la pantalla
	call ninja_suelo		;93ab   ; el dibujo del ninja
	ret			;93ae
ninja_baja_izq:		; Abajo y a la izquierda: escalera debajo (0x30-0x32): baja 8 (+6 = 6); abajo del todo (0x32), fuera
	ld a,(ix+009h)		;93af   ; cayendo?
	cp 001h		;93b2
	jp z,ninja_izquierda		;93b4
	call casilla_der		;93b7   ; la casilla...
	add hl,de			;93ba   ; ...dos filas abajo y dos a la izquierda
	add hl,de			;93bb
	dec hl			;93bc
	dec hl			;93bd
	ld a,(hl)			;93be
	cp 030h		;93bf   ; 0x30-0x32?
	jr c,ninja_baja_izq_no		;93c1
	cp 033h		;93c3
	jr nc,ninja_baja_izq_no		;93c5
	call ninja_paso		;93c7   ; espera?
	jp c,ninja_mira_izq		;93ca
	ld (ix+006h),006h		;93cd   ; bajando a la izquierda
	ld a,(ix+000h)		;93d1
	add a,008h		;93d4   ; 8 abajo
	ld (ix+000h),a		;93d6
	ld (ix+010h),a		;93d9   ; los dos sprites
	ld a,(hl)			;93dc
	cp 032h		;93dd   ; el final de la escalera?
	jp nz,mapa_corre_izq_paso		;93df
	ld (ix+006h),000h		;93e2   ; fuera de ella
	jp mapa_corre_izq_paso		;93e6
ninja_baja_izq_no:
	jp ninja_agacha		;93e9   ; no: agachado
ninja_sube_izq:		; Arriba y a la izquierda: escalera (0x33-0x35): sube 8 (+6 = 8); arriba del todo (0x34), fuera
	ld a,(ix+009h)		;93ec   ; cayendo?
	cp 001h		;93ef
	jp z,ninja_izquierda		;93f1
	call casilla_der		;93f4   ; la casilla...
	dec hl			;93f7   ; ...dos a la izquierda
	dec hl			;93f8
	ld a,(hl)			;93f9
	cp 060h		;93fa   ; desde 0x60, nada
	jr nc,ninja_sube_izq_nada		;93fc
	cp 033h		;93fe   ; por debajo de 0x33, nada
	jr c,ninja_sube_izq_nada		;9400
	cp 036h		;9402   ; 0x33-0x35: subir
	jr c,ninja_sube_izq_paso		;9404
	cp 036h		;9406
	jr nc,ninja_sube_izq_no		;9408
	jr ninja_sube_izq_nada		;940a
ninja_sube_izq_paso:
	call ninja_paso		;940c   ; espera?
	jp c,ninja_mira_izq		;940f
	ld (ix+006h),008h		;9412   ; subiendo a la izquierda
	ld a,(ix+000h)		;9416
	sub 008h		;9419   ; 8 arriba
	ld (ix+000h),a		;941b
	ld (ix+010h),a		;941e   ; los dos sprites
	ld a,(hl)			;9421
	cp 034h		;9422   ; el final de la escalera?
	jp nz,mapa_corre_izq_paso		;9424
	ld (ix+006h),000h		;9427   ; fuera de ella
	jp mapa_corre_izq_paso		;942b
ninja_sube_izq_no:
	jp ninja_mueve_fin		;942e
ninja_sube_izq_nada:
	jr ninja_izquierda		;9431
ninja_izquierda:		; A la izquierda: como a la derecha, al reves: el mapa corre hacia atras hasta la posicion 1
	ld a,(ix+006h)		;9433   ; en la escalera?
	cp 006h		;9436
	jp z,ninja_baja_izq		;9438
	cp 008h		;943b
	jp z,ninja_sube_izq		;943d
	cp 002h		;9440
	jp z,ninja_baja_izq		;9442
	cp 004h		;9445
	jp z,ninja_sube_izq		;9447
	ld a,(ix+001h)		;944a   ; en el borde?
	cp 004h		;944d   ; en el borde?
	jp c,ninja_anda_izq_fin		;944f
	cp 075h		;9452   ; antes de la mitad?
	jr nc,ninja_anda_izq		;9454   ; pasada la mitad: anda
	ld a,(0e00ah)		;9456
	cp 006h		;9459   ; la 6: anda
	jr z,ninja_anda_izq		;945b
	cp 002h		;945d   ; las 0 y 1: anda
	jr c,ninja_anda_izq		;945f
	ld a,(0e190h)		;9461   ; el principio del mapa?
	cp 002h		;9464
	jr nc,mapa_corre_izq		;9466
ninja_anda_izq:
	call libre_izq		;9468   ; libre?
	jp nc,ninja_anda_izq_fin		;946b
	ld a,(ix+001h)		;946e   ; en el borde?
	cp 008h		;9471
	jp c,ninja_anda_izq_fin		;9473
	ld a,(ix+009h)		;9476   ; cayendo?
	cp 001h		;9479
	jr nz,ninja_anda_izq_paso		;947b
	inc (ix+00fh)		;947d   ; cada dos
	ld a,(ix+00fh)		;9480
	cp 002h		;9483
	jp c,ninja_mira_izq		;9485
	ld (ix+00fh),000h		;9488   ; a cero
ninja_anda_izq_paso:
	dec (ix+001h)		;948c   ; un punto a la izquierda
	dec (ix+011h)		;948f   ; el segundo sprite
	call ninja_suelo		;9492   ; el suelo
	jp ninja_anda_izq_fin		;9495
mapa_corre_izq:
	call ninja_paso		;9498   ; espera?
	jp c,ninja_mira_izq		;949b
	ld a,(ix+006h)		;949e   ; en la escalera: no
	and a			;94a1
	jp nz,ninja_mira_izq		;94a2
	call libre_izq		;94a5   ; libre?
	jp nc,ninja_anda_izq_fin		;94a8
mapa_corre_izq_paso:
	ld a,(0e190h)		;94ab   ; una columna menos
	dec a			;94ae
	ld (0e190h),a		;94af   ; apuntada
	cp 000h		;94b2   ; 0?
	jr nz,mapa_corre_izq_cuenta		;94b4
	ld a,020h		;94b6   ; vuelta a 0x20...
	ld (0e190h),a		;94b8   ; 0x20
	ld hl,0e051h		;94bb   ; ...la posicion de antes (la 1 como poco)
	dec (hl)			;94be   ; la posicion de antes...
	jr nz,L_94C2		;94bf
	inc (hl)			;94c1   ; ...la 1 como poco
L_94C2:
	call mapa_retrocede		;94c2   ; ...y su trozo
	ld a,(0e190h)		;94c5   ; la columna
mapa_corre_izq_cuenta:
	push af			;94c8
	ld hl,0e195h		;94c9
	dec (hl)			;94cc   ; 0xE195 - 1
	ld iy,0e360h		;94cd   ; los 10 enemigos
	ld b,00ah		;94d1
	ld de,00010h		;94d3
otros_corren_der:
	ld a,(iy+004h)		;94d6   ; esta?
	and a			;94d9   ; esta?
	jr z,otros_corren_der_sig		;94da
	ld a,(iy+001h)		;94dc   ; 8 a la derecha
	add a,008h		;94df
	ld (iy+001h),a		;94e1   ; apuntada
otros_corren_der_sig:
	add iy,de		;94e4   ; el siguiente
	djnz otros_corren_der		;94e6
	pop af			;94e8
	jp mapa_pinta		;94e9
ninja_agacha:		; Abajo: quieto, sin saltar ni en una escalera, agachado (+0xA = 1)
	ld a,(ix+009h)		;94ec   ; saltando?
	and a			;94ef
	ret nz			;94f0
	ld a,(ix+016h)		;94f1   ; cayendo?
	and a			;94f4
	ret nz			;94f5
	ld a,(ix+006h)		;94f6   ; en la escalera?
	and a			;94f9
	ret nz			;94fa
	ld (ix+00ah),001h		;94fb   ; agachado
	ret			;94ff
mapa_vram:		; 22 filas de 32 casillas del mapa de la RAM (HL; filas de 0x60) a la tabla de nombres desde la fila 2
	ld (0e1a0h),hl		;9500   ; el mapa
	ld de,01840h		;9503   ; la fila 2 de la VRAM
	ld (0e1a2h),de		;9506
	ld b,016h		;950a   ; 22 filas
mapa_vram_fila:
	push bc			;950c
	ld bc,00020h		;950d   ; 32 casillas
	ld hl,(0e1a0h)		;9510
	ld de,(0e1a2h)		;9513
	call 0005ch		;9517   ; LDIRVM
	ld hl,(0e1a0h)		;951a
	ld de,00060h		;951d   ; la fila siguiente del mapa (0x60)
	add hl,de			;9520
	ld (0e1a0h),hl		;9521
	ld hl,(0e1a2h)		;9524
	ld de,00020h		;9527   ; la de la VRAM (0x20)
	add hl,de			;952a
	ld (0e1a2h),hl		;952b
	pop bc			;952e
	djnz mapa_vram_fila		;952f   ; una fila menos
	ret			;9531
ninja_anda_der_fin:		; Andando (+0xD) con el paso de su dibujo (cada 8 cuadros) y mirando a la derecha (+0xB = 0)
	ld (ix+00dh),001h		;9532   ; andando
	ld a,(0e012h)		;9536   ; el paso: cada 8 cuadros
	and 008h		;9539
	ld (ix+00eh),a		;953b
ninja_mira_der:
	ld (ix+00bh),000h		;953e   ; mirando a la derecha
	ret			;9542
ninja_anda_izq_fin:		; Lo mismo, mirando a la izquierda (+0xB = 1)
	ld (ix+00dh),001h		;9543   ; andando
	ld a,(0e012h)		;9547   ; el paso
	and 008h		;954a
	ld (ix+00eh),a		;954c
ninja_mira_izq:
	ld (ix+00bh),001h		;954f   ; mirando a la izquierda
	ret			;9553
libre_der:		; C si la casilla de delante (a la derecha) deja pasar: por debajo de 0x36 o desde 0x60; si no y saltando, el salto pasa a caida (+9 = 1)
	call casilla_der		;9554   ; la casilla
libre_mira:
	cp 036h		;9557   ; por debajo de 0x36: si
	jr c,libre_si		;9559
	cp 060h		;955b   ; por debajo de 0x60: no
	jr c,libre_no		;955d
libre_si:
	scf			;955f   ; desde 0x60: si
	ret			;9560
libre_no:
	ld a,(ix+009h)		;9561   ; saltando?
	and a			;9564
	ret z			;9565
	ld (ix+009h),001h		;9566   ; el salto pasa a caida
	xor a			;956a   ; NC
	ret			;956b
casilla_izq:		; La casilla del mapa a la izquierda del ninja (X - 4)
	ld a,(ix+001h)		;956c   ; la X - 4
	sub 004h		;956f
	jr casilla_xy		;9571
casilla_der:		; La casilla del mapa a la derecha del ninja (X + 12): HL en 0xEA00 (filas de 0x60, la columna + 0xE190) y A, la casilla
	ld a,(ix+001h)		;9573   ; la X + 12
	add a,00ch		;9576
casilla_xy:
	srl a		;9578   ; / 8: la columna
	srl a		;957a
	srl a		;957c
	ld b,a			;957e
	ld a,(0e190h)		;957f   ; + la del mapa
	add a,b			;9582
	ld hl,0ea00h		;9583   ; el mapa
	add a,l			;9586
	jr nc,casilla_fila		;9587
	inc h			;9589
casilla_fila:
	ld l,a			;958a
	ld a,(ix+000h)		;958b   ; la Y - 8...
	sub 008h		;958e
	srl a		;9590   ; ...entre 8: la fila
	srl a		;9592
	srl a		;9594
	ld b,a			;9596
	and a			;9597
	jr z,casilla_lee		;9598
	ld de,00060h		;959a   ; filas de 0x60
casilla_fila_suma:
	add hl,de			;959d
	djnz casilla_fila_suma		;959e
casilla_lee:
	ld a,(hl)			;95a0   ; la casilla
	ret			;95a1
libre_izq:		; Como libre_der, a la izquierda
	ld (ix+00bh),001h		;95a2   ; mirando a la izquierda
	call casilla_izq		;95a6   ; la casilla
	ld a,(hl)			;95a9
	jp libre_mira		;95aa
ninja_coge:		; Lo que el ninja tiene encima en el mapa (salvo en la fase 6): 0xD4 con +0x14 = 1, 0xE1C5 (y su sitio en 0xE1C3); 0x72, 0xE1C8; 0x73, 500 puntos; 0x6B, 0x6C, 0xC4, 0x7E, 0xC9 y 0xCC, lo cogido 1-6 (+0x17); 0x6E, 0xE1C9 y una marca mas (0xE053); lo cogido se borra del mapa (dos casillas), el efecto A 1 y, con 0x72, un trozo nuevo del mapa segun la fase (0x9698)
	ld a,(0e00ah)		;95ad   ; la fase 6?
	cp 006h		;95b0
	ret z			;95b2
	ld hl,0ea00h		;95b3   ; el mapa: la columna...
	ld a,(ix+001h)		;95b6   ; la X + 8...
	add a,008h		;95b9
	srl a		;95bb   ; ...entre 8
	srl a		;95bd
	srl a		;95bf
	ld b,a			;95c1
	ld a,(0e190h)		;95c2   ; + la columna del mapa
	add a,b			;95c5
	add a,l			;95c6
	jr nc,L_95CA		;95c7
	inc h			;95c9
L_95CA:
	ld l,a			;95ca
	ld de,00060h		;95cb   ; ...y la fila
	ld a,(ix+000h)		;95ce   ; la Y - 12...
	sub 00ch		;95d1
	srl a		;95d3   ; ...entre 8
	srl a		;95d5
	srl a		;95d7
	and a			;95d9
	ret z			;95da   ; la fila 0: nada
	ld b,a			;95db
L_95DC:
	add hl,de			;95dc   ; filas de 0x60
	djnz L_95DC		;95dd
	ld a,(hl)			;95df   ; 0xD4?
	cp 0d4h		;95e0
	jr nz,coge_72		;95e2
	ld a,(ix+014h)		;95e4   ; con +0x14?
	cp 001h		;95e7
	ret nz			;95e9
	ld (0e1c3h),hl		;95ea   ; su sitio
	xor a			;95ed   ; la cuenta del cofre a 0
	ld (0e019h),a		;95ee
	inc a			;95f1   ; 0xE1C5 = 1
	ld (0e1c5h),a		;95f2
	ret			;95f5
coge_72:
	cp 072h		;95f6   ; 0x72?
	jr nz,coge_73		;95f8   ; no
	ld a,001h		;95fa
	ld (0e1c8h),a		;95fc   ; 0xE1C8 = 1
	jr coge_borra		;95ff
coge_73:
	cp 073h		;9601   ; 0x73: 500 puntos
	jr nz,coge_6b		;9603   ; no
	push hl			;9605
	ld a,050h		;9606
	call puntos_suma		;9608
	jr coge_borra_pop		;960b   ; a borrarlo
coge_6b:
	cp 06bh		;960d   ; 0x6B: el 1
	jr nz,coge_6c		;960f   ; no
	ld (ix+017h),001h		;9611
	jr coge_borra		;9615
coge_6c:
	cp 06ch		;9617   ; 0x6C: el 2
	jr nz,coge_c4		;9619   ; no
	ld (ix+017h),002h		;961b
	jr coge_borra		;961f
coge_c4:
	cp 0c4h		;9621   ; 0xC4: el 3
	jr nz,coge_7e		;9623   ; no
	ld (ix+017h),003h		;9625
	jr coge_borra		;9629
coge_7e:
	cp 07eh		;962b   ; 0x7E: el 4
	jr nz,coge_c9		;962d   ; no
	ld (ix+017h),004h		;962f
	jr coge_borra		;9633
coge_c9:
	cp 0c9h		;9635   ; 0xC9: el 5
	jr nz,coge_cc		;9637   ; no
	ld (ix+017h),005h		;9639
	jr coge_borra		;963d
coge_cc:
	cp 0cch		;963f   ; 0xCC: el 6
	jr nz,coge_6e		;9641   ; no
	ld (ix+017h),006h		;9643
	jr coge_borra		;9647
coge_6e:
	cp 06eh		;9649   ; 0x6E?
	ret nz			;964b   ; no: nada
	ld a,001h		;964c   ; 0xE1C9 = 1
	ld (0e1c9h),a		;964e
	ld a,(0e053h)		;9651   ; una marca mas
	inc a			;9654
	ld (0e053h),a		;9655
	ret			;9658
coge_borra_pop:
	pop hl			;9659
coge_borra:
	ld (hl),010h		;965a   ; borrado del mapa...
	ld de,00060h		;965c   ; la de debajo
	add hl,de			;965f
	ld (hl),010h		;9660   ; ...y la casilla de debajo
	call mapa_pantalla		;9662   ; a la pantalla
	ld a,001h		;9665   ; el efecto A 1
	call efecto_a_pide		;9667
	ld a,(0e1c8h)		;966a   ; con 0x72...
	and a			;966d   ; con el 0x72?
	ret z			;966e
	xor a			;966f
	ld (0e1c8h),a		;9670   ; gastado
	ld a,(0e00ah)		;9673   ; ...el sitio segun la fase: 2, 0xF0A1...
	ld hl,0f0a1h		;9676
	cp 002h		;9679
	jr z,coge_trozo		;967b
	ld hl,0f083h		;967d   ; ...3, 0xF083...
	cp 003h		;9680
	jr z,coge_trozo		;9682
	ld hl,0ededh		;9684   ; ...4, 0xEDED...
	cp 004h		;9687
	jr z,coge_trozo		;9689
	ld hl,0ee19h		;968b   ; ...las demas, 0xEE19
coge_trozo:
	ld de,09698h		;968e   ; el dibujo de 0x9698
	call dibujo_mapa		;9691   ; en el mapa
	jp mapa_pantalla		;9694   ; a la pantalla

; ----------------------------------------------------------------------
; DATOS coge_dibujo: Un byte y el dibujo que pone en el mapa al coger el 0x72
;   (0x9698: 4 x 4 casillas)
;   0x9697..0x96aa  (19 bytes)
DATA_coge_dibujo:
	defb 0c9h,004h,004h,070h,071h,070h,071h,074h,075h,074h,075h,078h,079h,06eh,07bh,07ch	; 9697  ...pqpqtutuxyn{|
	defb 07dh,07ch,07dh	; 96a7

; ======================================================================
; CODIGO 0x96aa..0x982d  (387 bytes)
; ======================================================================


ninja_paso:		; El ritmo del ninja: con el poder 3, un paso cada 4 cuadros (+0xF); si no, cada 8; cayendo, cada 16; C mientras espera
	ld a,(ix+009h)		;96aa   ; cayendo?
	cp 001h		;96ad   ; no
	jr nz,ninja_paso_poder		;96af
	ld a,(ix+018h)		;96b1   ; con el poder 3?
	cp 003h		;96b4   ; el poder 3
	jr z,ninja_paso_8		;96b6
	inc (ix+00fh)		;96b8   ; la cuenta...
	ld a,(ix+00fh)		;96bb
	cp 010h		;96be   ; ...16?
	ret c			;96c0
	jr ninja_paso_da		;96c1
ninja_paso_poder:
	ld a,(ix+018h)		;96c3   ; el poder 3?
	cp 003h		;96c6
	jr nz,ninja_paso_8		;96c8
	inc (ix+00fh)		;96ca   ; la cuenta...
	ld a,(ix+00fh)		;96cd
	cp 004h		;96d0   ; ...4?
	ret c			;96d2
ninja_paso_da:
	xor a			;96d3   ; a cero: NC
	ld (ix+00fh),a		;96d4
	ret			;96d7
ninja_paso_8:
	inc (ix+00fh)		;96d8   ; la cuenta...
	ld a,(ix+00fh)		;96db
	cp 008h		;96de   ; ...8?
	ret c			;96e0
	jr ninja_paso_da		;96e1
ninja_dibujo:		; Los dibujos del ninja (dos sprites): agachado, 0x48/0x4C o 0x20/0x24; saltando, 0x10/0x14 (3) o 0x38/0x3C (2); cayendo, 0x40/0x44 o 0x18/0x1C; de pie, 0x28-0x34 mirando a la derecha y 0x00-0x0C a la izquierda, con dos pasos
	ld a,(ix+00ah)		;96e3   ; agachado?
	and a			;96e6
	jr z,ninja_dibujo_salto		;96e7   ; no
	ld a,(ix+00bh)		;96e9   ; a la derecha?
	and a			;96ec
	jr nz,ninja_dibujo_agacha_izq		;96ed   ; a la izquierda
	ld (ix+002h),048h		;96ef   ; agachado a la derecha
	ld (ix+012h),04ch		;96f3
	ret			;96f7
ninja_dibujo_agacha_izq:
	ld (ix+002h),020h		;96f8   ; agachado a la izquierda
	ld (ix+012h),024h		;96fc
	ret			;9700
ninja_dibujo_salto:
	ld a,(ix+009h)		;9701   ; saltando?
	and a			;9704
	jr z,ninja_dibujo_pie		;9705   ; no: de pie
	cp 001h		;9707   ; cayendo?
	jr z,ninja_dibujo_cae		;9709
	cp 002h		;970b   ; 2: a la derecha
	jr z,ninja_dibujo_salto2		;970d
	ld (ix+002h),010h		;970f   ; 3: 0x10 y 0x14
	ld (ix+012h),014h		;9713
	ret			;9717
ninja_dibujo_salto2:
	ld (ix+002h),038h		;9718   ; 0x38 y 0x3C
	ld (ix+012h),03ch		;971c
	ret			;9720
ninja_dibujo_cae:
	ld a,(ix+00bh)		;9721   ; a la izquierda?
	and a			;9724
	jr nz,ninja_dibujo_cae_izq		;9725
	ld (ix+002h),040h		;9727   ; 0x40 y 0x44
	ld (ix+012h),044h		;972b
	ret			;972f
ninja_dibujo_cae_izq:
	ld (ix+002h),018h		;9730   ; 0x18 y 0x1C
	ld (ix+012h),01ch		;9734
	ret			;9738
ninja_dibujo_pie:
	ld a,(ix+00bh)		;9739   ; a la izquierda?
	and a			;973c
	jr nz,ninja_dibujo_pie_izq		;973d
	ld a,(ix+00dh)		;973f   ; quieto: el paso segun el mapa
	and a			;9742   ; andando?
	jr nz,ninja_dibujo_anda		;9743
	ld a,(0e190h)		;9745   ; quieto: segun la columna del mapa...
	and 001h		;9748
	rlca			;974a   ; ...0 u 8...
	rlca			;974b
	rlca			;974c
	add a,028h		;974d   ; ...+ 0x28
	jr ninja_dibujo_pon		;974f
ninja_dibujo_anda:
	ld a,(ix+00eh)		;9751   ; el paso + 0x28
	add a,028h		;9754
ninja_dibujo_pon:
	ld (ix+002h),a		;9756   ; el primer sprite
	add a,004h		;9759   ; el segundo sprite, 4 mas
	ld (ix+012h),a		;975b   ; el segundo
	ret			;975e
ninja_dibujo_pie_izq:
	ld a,(ix+00dh)		;975f   ; andando?
	and a			;9762
	jr nz,ninja_dibujo_anda_izq		;9763
	ld a,(0e190h)		;9765   ; quieto: 0 u 8
	and 001h		;9768
	rlca			;976a
	rlca			;976b
	rlca			;976c
	add a,000h		;976d
	jr ninja_dibujo_pon		;976f
ninja_dibujo_anda_izq:
	ld a,(ix+00eh)		;9771   ; el paso
	add a,000h		;9774
	jr ninja_dibujo_pon		;9776
cofre_abre:		; El cofre (0xE1C5): cada 2 cuadros (0xE019) un paso: dos dibujos de la tapa (0x982D, 0x983F) y despues lo de dentro: con el sexto cofre (0xE1C6), cuando se acaba la cuenta al azar de la fase (0xE1C7), el 0x72 (0x9875); si no, al azar entre siete (0x9851: nada; 0x9863: el 0x73; 0x9887: el 0x6B; 0x9899: el 0x6C; 0x98AB: el 0xC4; 0x98BD: el 0x7E; 0x98CF: el 0xC9; 0x98E1: el 0xCC); al acabar, la casilla 0x3D cinco filas mas abajo (dos o tres)
	ld a,(0e1c5h)		;9778   ; abriendose?
	and a			;977b
	ret z			;977c   ; no
	ld a,(0e019h)		;977d   ; 2 cuadros
	cp 002h		;9780
	ret c			;9782   ; aun no
	xor a			;9783   ; la cuenta a 0
	ld (0e019h),a		;9784
	ld a,(0e1c5h)		;9787   ; el paso siguiente
	inc a			;978a
	ld (0e1c5h),a		;978b   ; apuntado
	ld de,0982dh		;978e   ; 2: la tapa
	cp 002h		;9791
	jr z,cofre_pinta		;9793   ; a pintar
	ld de,0983fh		;9795   ; 3: la tapa abierta
	cp 003h		;9798
	jr z,cofre_pinta		;979a   ; a pintar
	xor a			;979c   ; acabado
	ld (0e1c5h),a		;979d   ; 0: acabado
	ld a,(0e1c6h)		;97a0   ; un cofre mas
	inc a			;97a3
	ld (0e1c6h),a		;97a4   ; apuntado
	cp 006h		;97a7   ; 6?
	jr c,cofre_azar		;97a9   ; menos de 6: al azar
	ld a,(0e1c7h)		;97ab   ; la cuenta de la fase...
	dec a			;97ae
	ld (0e1c7h),a		;97af   ; apuntada
	jr nz,cofre_azar		;97b2   ; aun no: al azar
	ld de,09875h		;97b4   ; ...a 0: el 0x72
	jr cofre_pinta		;97b7   ; a pintar
cofre_azar:
	ld a,r		;97b9   ; al azar, 0-7
	and 007h		;97bb   ; 0-7
	ld de,09851h		;97bd   ; 0: nada
	and a			;97c0
	jr z,cofre_pinta		;97c1
	ld de,09863h		;97c3   ; 1: el 0x73
	cp 001h		;97c6
	jr z,cofre_pinta		;97c8
	ld de,09887h		;97ca   ; 2: el 0x6B
	cp 002h		;97cd
	jr z,cofre_pinta		;97cf
	ld de,09899h		;97d1   ; 3: el 0x6C
	cp 003h		;97d4
	jr z,cofre_pinta		;97d6
	ld de,098abh		;97d8   ; 4: el 0xC4
	cp 004h		;97db
	jr z,cofre_pinta		;97dd
	ld de,098bdh		;97df   ; 5: el 0x7E
	cp 005h		;97e2
	jr z,cofre_pinta		;97e4
	ld de,098cfh		;97e6   ; 6: el 0xC9
	cp 006h		;97e9
	jr z,cofre_pinta		;97eb
	ld de,098e1h		;97ed   ; 7: el 0xCC
cofre_pinta:
	ld hl,(0e1c3h)		;97f0   ; en su sitio
	call dibujo_mapa		;97f3   ; en el mapa
	ld a,(0e1c5h)		;97f6   ; acabado?
	and a			;97f9
	jr nz,cofre_fin		;97fa   ; no: listo
	ld hl,(0e1c3h)		;97fc   ; cinco filas mas abajo...
	ld de,001e0h		;97ff   ; 5 filas (5 x 0x60)
	add hl,de			;9802
	ld (hl),03dh		;9803   ; ...0x3D
	inc hl			;9805   ; la segunda
	ld (hl),03dh		;9806
	ld a,(0e009h)		;9808   ; la primera vuelta, en la fase 2: dos; si no, tres
	and a			;980b   ; la vuelta 0?
	jr nz,cofre_tercera		;980c
	ld a,(0e00ah)		;980e   ; la fase 2?
	cp 002h		;9811
	jr z,cofre_fin		;9813
cofre_tercera:
	inc hl			;9815   ; la tercera
	ld (hl),03dh		;9816
cofre_fin:
	call mapa_pantalla		;9818   ; a la pantalla
	call ninja_suelo		;981b   ; el suelo del ninja
	ret			;981e
mapa_pantalla:		; El mapa visible (0xEA00 + 0xE190) a la pantalla
	ld a,(0e190h)		;981f   ; la columna...
	ld hl,0ea00h		;9822   ; ...del mapa
	add a,l			;9825
	jr nc,mapa_pantalla_va		;9826
	inc h			;9828
mapa_pantalla_va:
	ld l,a			;9829
	jp mapa_vram		;982a   ; a la VRAM

; ----------------------------------------------------------------------
; DATOS cofre_dibujos: Los dibujos del cofre, de 4 x 4 casillas: la tapa
;   (0x982D, 0x983F) y abierto con lo de dentro: nada (0x9851), 0x73 (0x9863),
;   0x72 (0x9875), 0x6B (0x9887), 0x6C (0x9899), 0xC4 (0x98AB), 0x7E (0x98BD),
;   0xC9 (0x98CF), 0xCC (0x98E1)
;   0x982d..0x98f3  (198 bytes)
DATA_cofre_dibujos:
	defb 004h,004h,0d3h,0c1h,0c2h,0c3h,0d5h,0c5h,0c6h,0c7h,010h,0cdh,0ceh,0cfh,010h,010h	; 982d  ................
	defb 010h,010h,004h,004h,0d3h,0c1h,0c2h,0c3h,0d3h,0cdh,0ceh,0cfh,0d5h,010h,010h,010h	; 983d  ................
	defb 010h,010h,010h,010h,004h,004h,0d3h,0d0h,0d1h,0d2h,0d3h,010h,010h,010h,0d3h,010h	; 984d  ................
	defb 010h,010h,0d5h,010h,010h,010h,004h,004h,0d3h,0d0h,0d1h,0d2h,0d3h,010h,073h,010h	; 985d  ..............s.
	defb 0d3h,010h,077h,010h,0d5h,010h,010h,010h,004h,004h,0d3h,0d0h,0d1h,0d2h,0d3h,010h	; 986d  ..w.............
	defb 072h,010h,0d3h,010h,076h,010h,0d5h,010h,010h,010h,004h,004h,0d3h,0d0h,0d1h,0d2h	; 987d  r...v...........
	defb 0d3h,010h,06bh,010h,0d3h,010h,06fh,010h,0d5h,010h,010h,010h,004h,004h,0d3h,0d0h	; 988d  ..k...o.........
	defb 0d1h,0d2h,0d3h,010h,06ch,010h,0d3h,010h,06dh,010h,0d5h,010h,010h,010h,004h,004h	; 989d  ....l...m.......
	defb 0d3h,0d0h,0d1h,0d2h,0d3h,010h,0c4h,010h,0d3h,010h,0c8h,010h,0d5h,010h,010h,010h	; 98ad  ................
	defb 004h,004h,0d3h,0d0h,0d1h,0d2h,0d3h,010h,07eh,010h,0d3h,010h,07fh,010h,0d5h,010h	; 98bd  ........~.......
	defb 010h,010h,004h,004h,0d3h,0d0h,0d1h,0d2h,0d3h,010h,0c9h,010h,0d3h,010h,0cbh,010h	; 98cd  ................
	defb 0d5h,010h,010h,010h,004h,004h,0d3h,0d0h,0d1h,0d2h,0d3h,010h,0cch,010h,0d3h,010h	; 98dd  ................
	defb 0d6h,010h,0d5h,010h,010h,010h	; 98ed

; ======================================================================
; CODIGO 0x98f3..0x99b0  (189 bytes)
; ======================================================================


salto:		; El salto, con el boton 2 (0xE020): si no salta, no esta en una escalera, no cae y no esta agachado: el efecto A 5; a la derecha (palanca 2 o 3) +9 = 2, a la izquierda (7 u 8) +9 = 3, recto (0 o 1) +9 = 1; sube 24 pasos (la tabla de 0x99B0) y despues baja (+0x14) hasta el suelo
	ld a,(ix+009h)		;98f3   ; saltando?
	and a			;98f6   ; saltando?
	jr nz,salto_sigue		;98f7
	ld a,(0e020h)		;98f9   ; el boton 2?
	and a			;98fc
	ret z			;98fd   ; no
	xor a			;98fe   ; gastado
	ld (0e020h),a		;98ff
	ld a,(ix+006h)		;9902   ; en la escalera?
	and a			;9905
	ret nz			;9906   ; en la escalera: no
	ld a,(ix+016h)		;9907   ; cayendo?
	and a			;990a
	ret nz			;990b   ; cayendo: no
	ld a,(ix+00ah)		;990c   ; agachado?
	and a			;990f
	ret nz			;9910   ; agachado: no
	ld a,005h		;9911   ; el efecto A 5
	call efecto_a_pide		;9913   ; pide el efecto
	ld a,(0e180h)		;9916   ; la palanca
	cp 002h		;9919   ; 2 o 3: a la derecha
	jr z,salto_der		;991b
	cp 003h		;991d
	jr z,salto_der		;991f
	cp 007h		;9921   ; 7 u 8: a la izquierda
	jr z,salto_izq		;9923
	cp 008h		;9925
	jr z,salto_izq		;9927
	cp 000h		;9929   ; 0 o 1: recto
	jr z,salto_recto		;992b
	cp 001h		;992d
	jr z,salto_recto		;992f
	ret			;9931   ; 4-6: nada
salto_izq:
	ld (ix+009h),003h		;9932   ; a la izquierda
	jr salto_sigue		;9936
salto_der:
	ld (ix+009h),002h		;9938   ; a la derecha
	jr salto_sigue		;993c
salto_recto:
	ld (ix+009h),001h		;993e   ; recto
salto_sigue:
	ld a,(ix+014h)		;9942   ; bajando?
	and a			;9945
	jr nz,salto_baja		;9946   ; si
	inc (ix+015h)		;9948   ; un paso mas
	ld a,(ix+015h)		;994b
	cp 018h		;994e   ; 24: ya baja
	jr c,salto_sube		;9950   ; no
	ld (ix+014h),001h		;9952   ; a bajar
	jr salto_baja		;9956
salto_sube:
	ld hl,099b0h		;9958   ; cuanto sube (0x99B0)
	add a,l			;995b
	jr nc,L_995F		;995c
	inc h			;995e
L_995F:
	ld l,a			;995f   ; la tabla + el paso
	ld b,(hl)			;9960   ; cuanto
	ld a,(ix+000h)		;9961   ; la Y...
	sub b			;9964   ; ...menos eso
	ld (ix+000h),a		;9965
	ld (ix+010h),a		;9968   ; los dos sprites
	ret			;996b
salto_baja:
	dec (ix+015h)		;996c   ; un paso menos
	ld a,(ix+015h)		;996f
	and a			;9972
	jr nz,salto_baja_paso		;9973
	call salto_acaba		;9975   ; de pie
	call ninja_suelo		;9978   ; el suelo
	ret			;997b
salto_acaba:
	ld (ix+005h),000h		;997c   ; de pie
	ld (ix+009h),000h		;9980
	ld (ix+014h),000h		;9984
	ld (ix+015h),000h		;9988
	xor a			;998c
	ld (0e020h),a		;998d
	ret			;9990
salto_baja_paso:
	ld hl,099b0h		;9991   ; cuanto baja
	add a,l			;9994
	jr nc,L_9998		;9995
	inc h			;9997
L_9998:
	ld l,a			;9998
	ld a,(hl)			;9999   ; cuanto
	and a			;999a
	ret z			;999b   ; 0: nada
	ld b,a			;999c
salto_baja_punto:
	push bc			;999d
	call suelo_mira		;999e   ; suelo?
	jr nc,salto_suelo		;99a1
	inc (ix+000h)		;99a3   ; un punto
	inc (ix+010h)		;99a6   ; el segundo sprite
	pop bc			;99a9
	djnz salto_baja_punto		;99aa   ; tantos puntos
	ret			;99ac
salto_suelo:
	pop bc			;99ad   ; de pie
	jr salto_acaba		;99ae

; ----------------------------------------------------------------------
; DATOS salto_tabla: Cuanto sube el ninja en cada uno de los 24 pasos del
;   salto (y cuanto baja, al reves)
;   0x99b0..0x99cc  (28 bytes)
DATA_salto_tabla:
	defb 004h,004h,003h,003h,003h,003h,002h,002h,002h,001h,002h,002h,002h,001h,001h,001h	; 99b0  ................
	defb 001h,001h,001h,001h,001h,000h,000h,000h,000h,000h,000h,000h	; 99c0  ............

; ======================================================================
; CODIGO 0x99cc..0x9a66  (154 bytes)
; ======================================================================


ninja_suelo:		; Sin escalera ni salto: si no hay suelo, cae (+0x16); si lo hay y es 0x3D, muere (0xE183 = 2), salvo con el poder 5
	ld a,(ix+006h)		;99cc
	and a			;99cf
	ret nz			;99d0
	ld a,(ix+009h)		;99d1   ; saltando?
	and a			;99d4
	ret nz			;99d5
	call suelo_mira		;99d6   ; suelo?
	jr nc,ninja_suelo_mira		;99d9
	ld (ix+016h),001h		;99db   ; no: cae
	ret			;99df
ninja_suelo_mira:
	ld a,(hl)			;99e0   ; 0x3D?
	cp 03dh		;99e1
	ret nz			;99e3
	ld a,(ix+018h)		;99e4   ; el poder 5?
	cp 005h		;99e7
	ret z			;99e9
	ld a,002h		;99ea   ; muere
	ld (0e183h),a		;99ec
	ret			;99ef
ninja_cae_suelo:		; Cayendo (+0x16): 3 puntos por cuadro hasta el suelo
	ld a,(ix+016h)		;99f0   ; cayendo?
	and a			;99f3
	ret z			;99f4
	ld b,003h		;99f5   ; tres puntos
ninja_cae_punto:
	push bc			;99f7   ; uno
	call suelo_mira		;99f8   ; suelo?
	jr nc,ninja_cae_para		;99fb   ; si: para
	inc (ix+000h)		;99fd   ; un punto abajo
	inc (ix+010h)		;9a00   ; el segundo sprite
	pop bc			;9a03
	djnz ninja_cae_punto		;9a04   ; tres
	ret			;9a06
ninja_cae_para:
	pop bc			;9a07
	ld (ix+016h),000h		;9a08   ; de pie
	jr ninja_suelo_mira		;9a0c   ; mira donde
suelo_mira:		; La casilla del mapa debajo del ninja: NC si sostiene (una escalera, 0x31, 0x32, 0x34, 0x35, o 0x36-0x5F); en una escalera, tambien 0x30 y 0x33
	ld hl,0ea00h		;9a0e   ; el mapa
	ld a,(ix+001h)		;9a11   ; la X + 8...
	add a,008h		;9a14
	srl a		;9a16   ; ...entre 8
	srl a		;9a18
	srl a		;9a1a
	ld b,a			;9a1c
	ld a,(0e190h)		;9a1d   ; + la columna del mapa
	add a,b			;9a20
	add a,l			;9a21
	jr nc,L_9A25		;9a22
	inc h			;9a24
L_9A25:
	ld l,a			;9a25   ; HL
	ld de,00060h		;9a26   ; filas de 0x60
	ld a,(ix+000h)		;9a29   ; la Y...
	srl a		;9a2c   ; ...entre 8
	srl a		;9a2e
	srl a		;9a30
	ld b,a			;9a32
L_9A33:
	add hl,de			;9a33   ; una fila mas
	djnz L_9A33		;9a34
	ld a,(hl)			;9a36   ; la casilla de debajo
	cp 031h		;9a37   ; lo alto de una escalera?
	jr z,suelo_si		;9a39
	cp 032h		;9a3b   ; 0x32?
	jr z,suelo_si		;9a3d
	cp 034h		;9a3f   ; 0x34?
	jr z,suelo_si		;9a41
	cp 035h		;9a43   ; 0x35?
	jr z,suelo_si		;9a45
	push af			;9a47
	ld a,(ix+006h)		;9a48   ; en la escalera?
	and a			;9a4b
	jr nz,suelo_escalera		;9a4c
	pop af			;9a4e
suelo_pared:
	cp 036h		;9a4f   ; por debajo de 0x36: no
	jr c,suelo_no		;9a51
	cp 060h		;9a53   ; desde 0x60: no
	jr nc,suelo_no		;9a55
suelo_si:
	xor a			;9a57   ; NC: sostiene
	ret			;9a58
suelo_no:
	scf			;9a59   ; C: no sostiene
	ret			;9a5a
suelo_escalera:
	pop af			;9a5b   ; la casilla
	cp 030h		;9a5c   ; 0x30?
	jr z,suelo_si		;9a5e
	cp 033h		;9a60   ; 0x33?
	jr z,suelo_si		;9a62
	jr suelo_pared		;9a64   ; si no, como siempre

; ----------------------------------------------------------------------
; DATOS codigo_suelto_9A66: Codigo que nada llama: subir o bajar la pantalla 8
;   puntos por paso con el ninja (0xE191, 0xE192), 0x11 pasos, y despues la
;   posicion 0xE199 en 0xE051
;   0x9a66..0x9af3  (141 bytes)
DATA_codigo_suelto_9A66:
	defb 03ah,091h,0e1h,0a7h,0c8h,0feh,001h,0c2h,0b2h,09ah,0cdh,0f3h,09ah,03ah,099h,0e1h	; 9a66  :............:..
	defb 0cdh,06bh,09ch,0cdh,010h,09bh,0cdh,0f3h,09ah,0cdh,002h,09bh,03eh,011h,032h,092h	; 9a76  .k..........>.2.
	defb 0e1h,0ddh,07eh,000h,0c6h,008h,0ddh,077h,000h,0ddh,077h,010h,0cdh,018h,08bh,0cdh	; 9a86  ..~....w..w.....
	defb 01ch,09bh,03ah,092h,0e1h,0a7h,028h,006h,03dh,032h,092h,0e1h,018h,0e3h,03ah,099h	; 9a96  ..:...(.=2....:.
	defb 0e1h,032h,051h,0e0h,0afh,032h,091h,0e1h,0cdh,08eh,09bh,0c9h,0cdh,0f3h,09ah,0cdh	; 9aa6  .2Q..2..........
	defb 002h,09bh,0cdh,010h,09bh,0cdh,0f3h,09ah,03ah,099h,0e1h,0cdh,06bh,09ch,03eh,001h	; 9ab6  ........:...k.>.
	defb 032h,092h,0e1h,0ddh,07eh,000h,0d6h,008h,0ddh,077h,000h,0ddh,077h,010h,0cdh,018h	; 9ac6  2...~....w..w...
	defb 08bh,0cdh,01ch,09bh,03ah,092h,0e1h,03ch,032h,092h,0e1h,0feh,013h,020h,0e4h,03ah	; 9ad6  ....:..<2.... .:
	defb 099h,0e1h,032h,051h,0e0h,0afh,032h,091h,0e1h,0cdh,08eh,09bh,0c9h	; 9ae6  ..2Q..2......

; ======================================================================
; CODIGO 0x9af3..0x9b02  (15 bytes)
; ======================================================================


pantalla_ram_borra:		; La pantalla de la RAM (0xE740, 0x2C0 bytes) llena de la casilla 0x10
	ld hl,0e740h		;9af3
	ld bc,002c0h		;9af6   ; 0x2C0 bytes
pantalla_ram_borra_byte:
	ld (hl),010h		;9af9   ; el espacio
	inc hl			;9afb   ; la siguiente
	dec bc			;9afc   ; una menos
	ld a,c			;9afd
	or b			;9afe
	jr nz,pantalla_ram_borra_byte		;9aff   ; hasta el final
	ret			;9b01

; ----------------------------------------------------------------------
; DATOS codigo_suelto_9B02: Mas codigo que nada llama, del mismo
;   desplazamiento hacia arriba o abajo: el mapa (0xEA00 + 0xE190) a 0xE500 y
;   de alli a la pantalla, fila a fila
;   0x9b02..0x9b8e  (140 bytes)
DATA_codigo_suelto_9B02:
	defb 03ah,090h,0e1h,021h,000h,0eah,085h,030h,001h,024h,06fh,0c3h,039h,09ch,021h,040h	; 9b02  :..!...0.$o.9.!@
	defb 0e7h,011h,000h,0e5h,001h,0c0h,002h,0edh,0b0h,0c9h,03ah,013h,0e0h,0feh,002h,038h	; 9b12  ..........:....8
	defb 0f9h,0afh,032h,013h,0e0h,021h,000h,0e5h,03ah,092h,0e1h,0a7h,028h,007h,047h,011h	; 9b22  ..2..!..:...(.G.
	defb 020h,000h,019h,010h,0fdh,006h,016h,0cdh,059h,089h,0c9h,0edh,053h,093h,0e1h,006h	; 9b32   .......Y...S...
	defb 018h,0c5h,0edh,05bh,093h,0e1h,001h,018h,000h,0edh,0b0h,0e5h,02ah,093h,0e1h,011h	; 9b42  ...[........*...
	defb 030h,000h,019h,022h,093h,0e1h,0e1h,0c1h,010h,0e7h,0c9h,022h,0a0h,0e1h,021h,000h	; 9b52  0.."......."..!.
	defb 018h,022h,0a2h,0e1h,006h,018h,0edh,05bh,0a2h,0e1h,02ah,0a0h,0e1h,0c5h,001h,018h	; 9b62  .".....[..*.....
	defb 000h,0cdh,05ch,000h,02ah,0a2h,0e1h,011h,020h,000h,019h,022h,0a2h,0e1h,02ah,0a0h	; 9b72  ..\.*... .."..*.
	defb 0e1h,011h,018h,000h,019h,022h,0a0h,0e1h,0c1h,010h,0dbh,0c9h	; 9b82  ....."......

; ======================================================================
; CODIGO 0x9b8e..0x9c5a  (204 bytes)
; ======================================================================


mapa_monta:		; El mapa de la RAM (0xEA00: tres pantallas de 32 columnas, filas de 0x60) para la posicion 0xE051: la de antes a la izquierda (0xEA00), la siguiente a la derecha (0xEA40) y la suya en el centro (0xEA20); 0xE190 = 0x20
	ld a,020h		;9b8e   ; la columna 0x20: la del centro
	ld (0e190h),a		;9b90   ; 0xE190
	ld hl,0e740h		;9b93   ; 0xB00 bytes de 0xE740 a 0x10
	ld bc,00b00h		;9b96   ; 0xB00 bytes
L_9B99:
	ld (hl),010h		;9b99   ; el espacio
	inc hl			;9b9b
	dec bc			;9b9c
	ld a,c			;9b9d
	or b			;9b9e
	jr nz,L_9B99		;9b9f
	ld a,(0e051h)		;9ba1   ; la de antes...
	dec a			;9ba4   ; la de antes
	call trozo_pon		;9ba5   ; en la pantalla de la RAM
	call pantalla_a_izq		;9ba8   ; ...a la izquierda
	call pantalla_ram_borra		;9bab   ; borrada
	ld a,(0e051h)		;9bae   ; la siguiente...
	inc a			;9bb1   ; la siguiente
	call trozo_pon		;9bb2   ; en la pantalla de la RAM
	call pantalla_a_der		;9bb5   ; ...a la derecha
	call pantalla_ram_borra		;9bb8   ; borrada
	ld a,(0e051h)		;9bbb   ; la suya...
	call trozo_pon		;9bbe   ; en la pantalla de la RAM
	call pantalla_a_centro		;9bc1   ; ...en el centro
	ret			;9bc4
mapa_avanza:		; El mapa una pantalla a la izquierda: la del centro a la izquierda, la de la derecha al centro y la siguiente (0xE051 + 1) a la derecha
	ld hl,0ea20h		;9bc5   ; el centro...
	call mapa_a_pantalla		;9bc8   ; a la pantalla de la RAM
	call pantalla_a_izq		;9bcb   ; ...a la izquierda
	ld hl,0ea40h		;9bce   ; la derecha...
	call mapa_a_pantalla		;9bd1   ; a la pantalla de la RAM
	call pantalla_a_centro		;9bd4   ; ...al centro
	call pantalla_ram_borra		;9bd7   ; borrada
	ld a,(0e051h)		;9bda   ; la posicion...
	inc a			;9bdd   ; ...siguiente
	call trozo_pon		;9bde   ; en la pantalla de la RAM
	call pantalla_a_der		;9be1   ; a la derecha
	ret			;9be4
mapa_retrocede:		; Al reves: el centro a la derecha, la izquierda al centro y la de antes (0xE051 - 1) a la izquierda
	ld hl,0ea20h		;9be5   ; el centro...
	call mapa_a_pantalla		;9be8   ; ...a la pantalla de la RAM...
	call pantalla_a_der		;9beb   ; ...y a la derecha
	ld hl,0ea00h		;9bee   ; la izquierda...
	call mapa_a_pantalla		;9bf1   ; ...a la pantalla de la RAM...
	call pantalla_a_centro		;9bf4   ; ...y al centro
	call pantalla_ram_borra		;9bf7   ; borrada
	ld a,(0e051h)		;9bfa   ; la posicion...
	dec a			;9bfd   ; ...de antes
	call trozo_pon		;9bfe   ; en la pantalla de la RAM
	call pantalla_a_izq		;9c01   ; a la izquierda
	ret			;9c04
pantalla_a_izq:		; La pantalla de la RAM (0xE740) a la izquierda del mapa (0xEA00)
	ld de,0ea00h		;9c05   ; la izquierda del mapa
pantalla_a_mapa:
	call pantalla_copia		;9c08   ; copiada
	ret			;9c0b
pantalla_a_centro:		; ... al centro (0xEA20)
	ld de,0ea20h		;9c0c   ; el centro
	jr pantalla_a_mapa		;9c0f
pantalla_a_der:		; ... a la derecha (0xEA40)
	ld de,0ea40h		;9c11   ; la derecha
	jr pantalla_a_mapa		;9c14
pantalla_copia:		; 22 filas de 32 de 0xE740 al mapa en DE (filas de 0x60)
	ld (0e1a0h),de		;9c16   ; el destino
	ld hl,0e740h		;9c1a   ; desde 0xE740
	ld b,016h		;9c1d   ; 22 filas
pantalla_copia_fila:
	push bc			;9c1f
	ld de,(0e1a0h)		;9c20   ; su sitio en el mapa
	ld bc,00020h		;9c24   ; 32 casillas
	ldir		;9c27   ; copiadas
	push hl			;9c29
	ld hl,(0e1a0h)		;9c2a
	ld de,00060h		;9c2d   ; la fila siguiente del mapa
	add hl,de			;9c30
	ld (0e1a0h),hl		;9c31
	pop hl			;9c34
	pop bc			;9c35
	djnz pantalla_copia_fila		;9c36   ; una fila menos
	ret			;9c38
mapa_a_pantalla:		; 22 filas de 32 del mapa en HL a 0xE740
	ld (0e1a0h),hl		;9c39   ; el origen
	ld de,0e740h		;9c3c   ; a 0xE740
	ld b,016h		;9c3f   ; 22 filas
mapa_a_pantalla_fila:
	push bc			;9c41
	ld hl,(0e1a0h)		;9c42   ; su sitio en el mapa
	ld bc,00020h		;9c45   ; 32 casillas
	ldir		;9c48   ; copiadas
	push de			;9c4a
	ld hl,(0e1a0h)		;9c4b
	ld de,00060h		;9c4e   ; la fila siguiente del mapa
	add hl,de			;9c51
	ld (0e1a0h),hl		;9c52
	pop de			;9c55
	pop bc			;9c56
	djnz mapa_a_pantalla_fila		;9c57   ; una fila menos
	ret			;9c59

; ----------------------------------------------------------------------
; DATOS codigo_suelto_9C5A: Codigo que nadie llama: el principio de mapa_monta
;   otra vez (0xE740 a 0x10 y la posicion)
;   0x9c5a..0x9c6b  (17 bytes)
DATA_codigo_suelto_9C5A:
	defb 021h,040h,0e7h,001h,000h,00bh,036h,010h,023h,00bh,079h,0b0h,020h,0f8h,03ah,051h	; 9c5a  !@....6.#.y. .:Q
	defb 0e0h	; 9c6a

; ======================================================================
; CODIGO 0x9c6b..0x9d63  (248 bytes)
; ======================================================================


trozo_pon:		; La pantalla A de la fase (0xE050) en 0xE740: su puntero sale de la tabla de 0x406D (una lista por fase); tiene cuatro listas: rectangulos de dos casillas alternas (0x9CC7), rectangulos de una casilla (0x9D30), escaleras (0x9D87) y dibujos (0x9C93)
	push af			;9c6b   ; la pantalla
	ld hl,0406dh		;9c6c   ; la tabla de las fases
	ld a,(0e050h)		;9c6f   ; la fase...
	add a,a			;9c72   ; ...x 2
	add a,l			;9c73
	ld l,a			;9c74
	ld e,(hl)			;9c75   ; su lista de pantallas
	inc hl			;9c76
	ld d,(hl)			;9c77
	ex de,hl			;9c78
	pop af			;9c79
	add a,a			;9c7a   ; la pantalla A
	add a,l			;9c7b   ; + la pantalla x 2
	jr nc,L_9C7F		;9c7c
	inc h			;9c7e
L_9C7F:
	ld l,a			;9c7f
	ld e,(hl)			;9c80   ; su puntero
	inc hl			;9c81
	ld d,(hl)			;9c82
	call trozo_rect2		;9c83   ; los rectangulos de dos casillas
	inc de			;9c86   ; la siguiente lista
	call trozo_rect1		;9c87   ; los de una
	inc de			;9c8a   ; la siguiente
	call trozo_escaleras		;9c8b   ; las escaleras
	inc de			;9c8e   ; la siguiente
	call trozo_dibujos		;9c8f   ; los dibujos
	ret			;9c92
trozo_dibujos:		; Hasta 0xFF: la fila, la columna y el puntero de un dibujo
	ld a,(de)			;9c93   ; el final?
	cp 0ffh		;9c94   ; 0xFF: el final
	ret z			;9c96
	call trozo_sitio		;9c97   ; su sitio
	ld a,(de)			;9c9a   ; el puntero
	ld c,a			;9c9b   ; el puntero del dibujo
	inc de			;9c9c
	ld a,(de)			;9c9d
	ld b,a			;9c9e
	inc de			;9c9f
	push de			;9ca0
	ld e,c			;9ca1   ; en DE
	ld d,b			;9ca2
	call dibujo_pon		;9ca3   ; pintado
	pop de			;9ca6
	jr trozo_dibujos		;9ca7   ; el siguiente
dibujo_pon:		; Un dibujo de casillas (ancho, alto y las casillas) en HL (filas de 32)
	ld a,(de)			;9ca9   ; el ancho
	ld (0e1a0h),a		;9caa   ; apuntado
	inc de			;9cad
	ld a,(de)			;9cae   ; el alto
	ld b,a			;9caf   ; las filas
	inc de			;9cb0
dibujo_fila:
	ld a,(0e1a0h)		;9cb1   ; el ancho
	ld c,a			;9cb4
	push hl			;9cb5   ; su principio
dibujo_casilla:
	ld a,(de)			;9cb6   ; una casilla
	ld (hl),a			;9cb7   ; en el mapa
	inc de			;9cb8
	inc hl			;9cb9
	dec c			;9cba   ; una menos
	jr nz,dibujo_casilla		;9cbb   ; la fila entera
	pop hl			;9cbd   ; la fila
	push de			;9cbe
	ld de,00020h		;9cbf   ; la fila siguiente
	add hl,de			;9cc2
	pop de			;9cc3
	djnz dibujo_fila		;9cc4   ; una fila menos
	ret			;9cc6
trozo_rect2:		; Hasta 0xFF: la fila, la columna, el ancho, el alto y una casilla N: filas alternas de N, N+1 y de N+2, N+3
	ld a,(de)			;9cc7   ; el final?
	cp 0ffh		;9cc8   ; 0xFF: el final
	ret z			;9cca
	call trozo_sitio		;9ccb   ; su sitio
	ld a,(de)			;9cce   ; el ancho
	ld (0e1a0h),a		;9ccf   ; apuntado
	inc de			;9cd2
	ld a,(de)			;9cd3   ; el alto
	inc de			;9cd4
	ld b,a			;9cd5   ; las filas
	ld (0e1a1h),hl		;9cd6   ; su sitio
	ld a,(de)			;9cd9   ; la casilla
	ld (0e1a4h),a		;9cda   ; apuntada
	inc de			;9cdd
	xor a			;9cde
	ld (0e1a3h),a		;9cdf   ; la primera fila, par
trozo_rect2_fila:
	ld hl,(0e1a1h)		;9ce2   ; su sitio
	ld a,(0e1a0h)		;9ce5   ; el ancho
	ld c,a			;9ce8
	ld a,(0e1a3h)		;9ce9   ; fila par o impar?
	and a			;9cec
	jr nz,trozo_rect2_impar		;9ced
	cpl			;9cef   ; la siguiente, impar
	ld (0e1a3h),a		;9cf0
trozo_rect2_par:
	ld a,(0e1a4h)		;9cf3   ; N y N+1
	ld (hl),a			;9cf6   ; N
	inc hl			;9cf7   ; la siguiente
	dec c			;9cf8
	jr z,trozo_rect2_sigue		;9cf9
	ld a,(0e1a4h)		;9cfb   ; N + 1
	inc a			;9cfe
	ld (hl),a			;9cff
	inc hl			;9d00   ; la siguiente
	dec c			;9d01
	jr nz,trozo_rect2_par		;9d02   ; la fila entera
	jr trozo_rect2_sigue		;9d04
trozo_rect2_impar:
	cpl			;9d06   ; la siguiente, par
	ld (0e1a3h),a		;9d07
trozo_rect2_impar_par:
	ld a,(0e1a4h)		;9d0a   ; N+2 y N+3
	add a,002h		;9d0d   ; N + 2
	ld (hl),a			;9d0f
	inc hl			;9d10   ; la siguiente
	dec c			;9d11
	jr z,trozo_rect2_sigue		;9d12
	ld a,(0e1a4h)		;9d14   ; N + 3
	add a,003h		;9d17
	ld (hl),a			;9d19
	inc hl			;9d1a   ; la siguiente
	dec c			;9d1b
	jr nz,trozo_rect2_impar_par		;9d1c   ; la fila entera
	jr trozo_rect2_sigue		;9d1e
trozo_rect2_sigue:
	ld hl,(0e1a1h)		;9d20   ; la fila siguiente
	push de			;9d23
	ld de,00020h		;9d24   ; una fila abajo
	add hl,de			;9d27
	pop de			;9d28
	ld (0e1a1h),hl		;9d29
	djnz trozo_rect2_fila		;9d2c   ; una fila menos
	jr trozo_rect2		;9d2e   ; el siguiente
trozo_rect1:		; Hasta 0xFF: la fila, la columna, el ancho, el alto y la casilla con que se llena
	ld a,(de)			;9d30   ; el final?
	cp 0ffh		;9d31   ; 0xFF: el final
	ret z			;9d33
	call trozo_sitio		;9d34   ; su sitio
	ld (0e1a2h),hl		;9d37   ; apuntado
	ld a,(de)			;9d3a   ; el ancho
	ld (0e1a0h),a		;9d3b
	inc de			;9d3e
	ld a,(de)			;9d3f   ; el alto
	ld b,a			;9d40   ; las filas
	inc de			;9d41
	ld a,(de)			;9d42   ; la casilla
	ld (0e1a1h),a		;9d43   ; apuntada
	inc de			;9d46
trozo_rect1_fila:
	ld a,(0e1a0h)		;9d47   ; el ancho
	ld c,a			;9d4a
trozo_rect1_casilla:
	ld a,(0e1a1h)		;9d4b   ; la casilla
	ld (hl),a			;9d4e   ; puesta
	inc hl			;9d4f   ; la siguiente
	dec c			;9d50
	jr nz,trozo_rect1_casilla		;9d51   ; la fila entera
	push de			;9d53
	ld de,00020h		;9d54   ; una fila abajo
	ld hl,(0e1a2h)		;9d57
	add hl,de			;9d5a
	ld (0e1a2h),hl		;9d5b
	pop de			;9d5e
	djnz trozo_rect1_fila		;9d5f   ; una fila menos
	jr trozo_rect1		;9d61   ; el siguiente

; ----------------------------------------------------------------------
; DATOS codigo_suelto_9D63: Doce bytes que nadie lee: un trozo de trozo_rect1
;   0x9d63..0x9d6f  (12 bytes)
DATA_codigo_suelto_9D63:
	defb 01ah,0feh,0ffh,0c8h,0cdh,06fh,09dh,01ah,013h,077h,018h,0f4h	; 9d63  .....o...w..

; ======================================================================
; CODIGO 0x9d6f..0x9da8  (57 bytes)
; ======================================================================


trozo_sitio:		; HL = 0xE740 + la fila (A) x 32 + la columna (DE+1)
	ld hl,0e740h		;9d6f   ; la pantalla de la RAM
	and a			;9d72   ; la fila 0?
	jr z,trozo_sitio_col		;9d73
	ld b,a			;9d75   ; las filas
	push de			;9d76
	ld de,00020h		;9d77   ; x 32
trozo_sitio_fila:
	add hl,de			;9d7a
	djnz trozo_sitio_fila		;9d7b
	pop de			;9d7d
trozo_sitio_col:
	inc de			;9d7e   ; la columna
	ld a,(de)			;9d7f   ; + la columna
	add a,l			;9d80
	jr nc,L_9D84		;9d81
	inc h			;9d83
L_9D84:
	ld l,a			;9d84
	inc de			;9d85
	ret			;9d86   ; DE, al dato siguiente
trozo_escaleras:		; Hasta 0xFF: la fila, la columna, hacia donde (0: subiendo a la derecha, con las casillas 0x90, 0x91, 0x30, 0x92; si no, a la izquierda, 0x93, 0x94, 0x33, 0x95), los escalones y dos bits: el 0, sin el remate de arriba (0x3A 0x3A 0x31 0x3A); el 1, sin el de abajo (0x32)
	ld a,(de)			;9d87   ; el final?
	cp 0ffh		;9d88   ; 0xFF: el final
	ret z			;9d8a
	call trozo_sitio		;9d8b   ; su sitio
	ld a,(de)			;9d8e   ; hacia donde?
	and a			;9d8f
	jp nz,escalera_izq		;9d90   ; a la izquierda
	inc de			;9d93
	ld a,(de)			;9d94   ; los escalones
	ld (0e1a0h),a		;9d95   ; apuntados
	inc de			;9d98
	ld a,(de)			;9d99   ; los remates
	ld (0e1a2h),a		;9d9a   ; apuntados
	inc de			;9d9d
	bit 0,a		;9d9e   ; sin el de arriba?
	jr z,$+10		;9da0
	push de			;9da2   ; sin remate
	ld de,0001ch		;9da3   ; la fila siguiente, 4 a la izquierda
	jr $+29		;9da6   ; a 0x9DC3

; ----------------------------------------------------------------------
; DATOS byte_9DA8: Dos bytes que salta el "jr z" de 0x9DA0
;   0x9da8..0x9daa  (2 bytes)
DATA_byte_9DA8:
	defb 018h,00bh	; 9da8

; ======================================================================
; CODIGO 0x9daa..0x9f30  (390 bytes)
; ======================================================================


escalera_der_arriba:
	ld (hl),03ah		;9daa   ; el remate de arriba
	inc hl			;9dac   ; 0x3A
	ld (hl),03ah		;9dad
	inc hl			;9daf
	ld (hl),031h		;9db0   ; 0x31: lo alto
	inc hl			;9db2
	ld (hl),03ah		;9db3   ; 0x3A
	push de			;9db5
	ld de,0001ch		;9db6   ; una fila abajo, 4 a la izquierda (32 - 4)
escalera_der_escalon:
	ld a,(0e1a0h)		;9db9   ; los escalones
	dec a			;9dbc   ; uno menos
	jr z,escalera_der_abajo		;9dbd   ; el ultimo
	ld (0e1a0h),a		;9dbf
	add hl,de			;9dc2   ; una fila abajo
escalera_der_casillas:
	ld (hl),090h		;9dc3   ; un escalon
	inc hl			;9dc5
	ld (hl),091h		;9dc6   ; 0x91
	inc hl			;9dc8
	ld (hl),030h		;9dc9   ; 0x30: el escalon
	inc hl			;9dcb
	ld (hl),092h		;9dcc   ; 0x92
	jr escalera_der_escalon		;9dce   ; el siguiente
escalera_der_abajo:
	ld a,(0e1a2h)		;9dd0   ; los remates
	bit 1,a		;9dd3   ; sin el de abajo?
	jr nz,escalera_der_fin		;9dd5   ; sin el de abajo
	add hl,de			;9dd7   ; una fila abajo
	ld (hl),03ah		;9dd8   ; 0x3A
	inc hl			;9dda
	ld (hl),03ah		;9ddb
	inc hl			;9ddd
	ld (hl),032h		;9dde   ; 0x32: el pie
	inc hl			;9de0
	ld (hl),03ah		;9de1   ; 0x3A
escalera_der_fin:
	pop de			;9de3
	jr $-93		;9de4   ; a la siguiente
escalera_izq:
	inc de			;9de6   ; los escalones
	ld a,(de)			;9de7
	ld (0e1a0h),a		;9de8   ; apuntados
	inc de			;9deb
	ld a,(de)			;9dec   ; los remates
	ld (0e1a2h),a		;9ded   ; apuntados
	inc de			;9df0
	bit 0,a		;9df1   ; sin el de arriba?
	jr z,escalera_izq_arriba		;9df3
	push de			;9df5   ; sin remate
	ld de,0007eh		;9df6   ; la fila siguiente, hacia la derecha
	jr escalera_izq_casillas		;9df9   ; a pintar
escalera_izq_arriba:
	ld (hl),03ah		;9dfb   ; el remate de arriba, hacia atras
	dec hl			;9dfd
	ld (hl),03ah		;9dfe
	dec hl			;9e00
	ld (hl),034h		;9e01   ; 0x34: lo alto
	dec hl			;9e03
	ld (hl),03ah		;9e04
	push de			;9e06
	ld de,00024h		;9e07   ; una fila abajo, 4 a la derecha (32 + 4)
escalera_izq_escalon:
	ld a,(0e1a0h)		;9e0a   ; los escalones
	dec a			;9e0d   ; uno menos
	jr z,escalera_izq_abajo		;9e0e   ; el ultimo
	ld (0e1a0h),a		;9e10
	add hl,de			;9e13   ; una fila abajo
escalera_izq_casillas:
	ld (hl),093h		;9e14   ; 0x93
	dec hl			;9e16
	ld (hl),094h		;9e17   ; 0x94
	dec hl			;9e19
	ld (hl),033h		;9e1a   ; 0x33: el escalon
	dec hl			;9e1c
	ld (hl),095h		;9e1d   ; 0x95
	jr escalera_izq_escalon		;9e1f   ; el siguiente
escalera_izq_abajo:
	ld a,(0e1a2h)		;9e21   ; los remates
	bit 1,a		;9e24   ; sin el de abajo?
	jr nz,escalera_izq_fin		;9e26
	add hl,de			;9e28   ; una fila abajo
	ld (hl),03ah		;9e29
	dec hl			;9e2b
	ld (hl),03ah		;9e2c
	dec hl			;9e2e
	ld (hl),035h		;9e2f   ; 0x35: el pie
	dec hl			;9e31
	ld (hl),03ah		;9e32
escalera_izq_fin:
	pop de			;9e34
	jp trozo_escaleras		;9e35   ; a la siguiente
dibujo_mapa:		; Un dibujo (ancho, alto y las casillas) en el mapa de la RAM en HL (filas de 0x60)
	ld (0e1a0h),hl		;9e38   ; el sitio
	ld a,(de)			;9e3b   ; el ancho
	ld (0e1a3h),a		;9e3c   ; apuntado
	inc de			;9e3f
	ld a,(de)			;9e40   ; el alto
	ld (0e1a2h),a		;9e41   ; apuntado
	inc de			;9e44
	ld c,a			;9e45   ; las filas
dibujo_mapa_fila:
	ld a,(0e1a3h)		;9e46   ; el ancho
	ld b,a			;9e49
	ld hl,(0e1a0h)		;9e4a   ; su sitio
dibujo_mapa_casilla:
	ld a,(de)			;9e4d   ; una casilla
	ld (hl),a			;9e4e   ; en el mapa
	inc hl			;9e4f   ; la siguiente
	inc de			;9e50
	djnz dibujo_mapa_casilla		;9e51   ; la fila entera
	dec c			;9e53   ; una fila menos
	jr z,L_9E64		;9e54
	ld hl,(0e1a0h)		;9e56   ; la fila...
	push de			;9e59
	ld de,00060h		;9e5a   ; ...siguiente del mapa (0x60)
	add hl,de			;9e5d
	ld (0e1a0h),hl		;9e5e
	pop de			;9e61
	jr dibujo_mapa_fila		;9e62   ; otra fila
L_9E64:
	ret			;9e64
enemigos_salen:		; Los enemigos que salen (en 0xE360, 16 bytes cada uno, +4 el tipo): en la fase 6, el 9 si no esta; en la 1, en las posiciones 0x20, 0x86 y 0xA0 del mapa (0xE195), el 4 en 0xE3C0 o 0xE3E0 cada tanto (0xE1C1); desde la 3, el 6 en 0xE3C4 cada tanto (0xE1CA); y siempre, cada tanto (0xE1C0), el 1 en 0xE364 y el 1 o el 3 (al azar, salvo en la fase 0) en 0xE394; la espera es al azar y mas corta con la luna mas llena (0x9F51)
	ld a,(0e00ah)		;9e65   ; la fase 6?
	cp 006h		;9e68
	jr nz,enemigos_fase1		;9e6a
	ld a,(0e364h)		;9e6c   ; el 9 ya esta?
	and a			;9e6f
	ret nz			;9e70
	ld a,009h		;9e71   ; el 9
	ld (0e364h),a		;9e73
	ret			;9e76
enemigos_fase1:
	cp 000h		;9e77   ; la fase 1?
	jr z,enemigo6		;9e79
	cp 001h		;9e7b
	jr nz,enemigo6		;9e7d
	ld a,(0e195h)		;9e7f   ; la posicion del mapa: 0x20, 0x86 o 0xA0?
	cp 020h		;9e82
	jr z,enemigo4_hueco		;9e84
	cp 086h		;9e86
	jr z,enemigo4_hueco		;9e88
	cp 0a0h		;9e8a
	jr z,enemigo4_hueco		;9e8c
	jr enemigo6		;9e8e
enemigo4_hueco:
	ld iy,0e3c0h		;9e90   ; libre 0xE3C0...
	ld a,(iy+004h)		;9e94
	and a			;9e97
	jr z,enemigo4_espera		;9e98
	ld iy,0e3e0h		;9e9a   ; ...o 0xE3E0?
	ld a,(iy+004h)		;9e9e
	and a			;9ea1
	jr nz,enemigo6		;9ea2
enemigo4_espera:
	ld a,(0e1c1h)		;9ea4   ; la espera
	and a			;9ea7
	jr z,enemigo4_sale		;9ea8
	dec a			;9eaa
	ld (0e1c1h),a		;9eab
	jr enemigo6		;9eae
enemigo4_sale:
	call enemigo_espera		;9eb0   ; la siguiente, al azar
	ld (0e1c1h),a		;9eb3
	ld (iy+000h),048h		;9eb6   ; Y 0x48, X 0xF0
	ld (iy+001h),0f0h		;9eba
	ld (iy+004h),004h		;9ebe   ; el 4
enemigo6:
	ld a,(0e00ah)		;9ec2   ; desde la fase 3
	cp 003h		;9ec5
	jr c,enemigo1		;9ec7
	ld a,(0e1cah)		;9ec9   ; la espera
	and a			;9ecc
	jr z,enemigo6_sale		;9ecd
	dec a			;9ecf
	ld (0e1cah),a		;9ed0
	jr enemigo1		;9ed3
enemigo6_sale:
	ld a,(0e3c4h)		;9ed5   ; libre?
	and a			;9ed8
	jr nz,enemigo1		;9ed9
	ld a,006h		;9edb   ; el 6
	ld (0e3c4h),a		;9edd
enemigo1:
	ld a,(0e1c0h)		;9ee0   ; la espera
	and a			;9ee3
	jr z,enemigo1_sale		;9ee4
	dec a			;9ee6
	ld (0e1c0h),a		;9ee7
	ret			;9eea
enemigo1_sale:
	call enemigo_espera		;9eeb   ; la siguiente, al azar
	ld (0e1c0h),a		;9eee
	ld a,(0e364h)		;9ef1   ; 0xE364 libre?
	and a			;9ef4
	jr nz,enemigo3		;9ef5
	inc a			;9ef7   ; el 1
	ld (0e364h),a		;9ef8
	ld a,(0e195h)		;9efb   ; en las posiciones 0xE0-0xF3...
	cp 0e0h		;9efe
	ret c			;9f00
	cp 0f4h		;9f01
	ret nc			;9f03
	ld a,001h		;9f04   ; ...0xE368 = 1
	ld (0e368h),a		;9f06
	ret			;9f09
enemigo3:
	ld a,(0e394h)		;9f0a   ; 0xE394 libre?
	and a			;9f0d
	ret nz			;9f0e
	inc a			;9f0f   ; el 1...
	ld (0e394h),a		;9f10
	ld a,(0e00ah)		;9f13   ; ...en la fase 0, siempre
	and a			;9f16
	jr z,enemigo3_pon		;9f17
	ld a,r		;9f19   ; si no, al azar...
	bit 6,a		;9f1b
	jr nz,enemigo3_pon		;9f1d
	ld a,003h		;9f1f   ; ...el 3
	ld (0e394h),a		;9f21
enemigo3_pon:
	ld a,(0e195h)		;9f24   ; desde la posicion 0xF0...
	cp 0f0h		;9f27
	ret c			;9f29
	ld a,001h		;9f2a   ; ...0xE398 = 1
	ld (0e398h),a		;9f2c
	ret			;9f2f

; ----------------------------------------------------------------------
; DATOS restos_9F30: Restos que nadie usa: un trozo de codigo que copia una
;   lista (hasta 0xFF) a los objetos de 0xE380
;   0x9f30..0x9f51  (33 bytes)
DATA_restos_9F30:
	defb 013h,021h,080h,0e3h,01ah,0feh,0ffh,028h,03ch,077h,023h,013h,01ah,077h,023h,023h	; 9f30  .!.....(<w#..w##
	defb 023h,013h,01ah,077h,013h,01ah,023h,077h,0d5h,011h,00bh,000h,019h,0d1h,013h,018h	; 9f40  #..w..#w........
	defb 0e3h	; 9f50

; ======================================================================
; CODIGO 0x9f51..0x9f75  (36 bytes)
; ======================================================================


enemigo_espera:		; La espera hasta el siguiente: al azar (0-63) mas 0x40, 0x30, 0x20, 0x10 o 0 segun la luna (0xE1BA, 0-4)
	ld a,r		;9f51   ; al azar, 0-63
	and 03fh		;9f53
	ld b,a			;9f55
	ld a,(0e1bah)		;9f56   ; la luna
	ld c,040h		;9f59
	and a			;9f5b
	jr z,enemigo_espera_suma		;9f5c
	ld c,030h		;9f5e
	cp 001h		;9f60
	jr z,enemigo_espera_suma		;9f62
	ld c,020h		;9f64
	cp 002h		;9f66
	jr z,enemigo_espera_suma		;9f68
	ld c,010h		;9f6a
	cp 003h		;9f6c
	jr z,enemigo_espera_suma		;9f6e
	ld c,000h		;9f70
enemigo_espera_suma:
	ld a,c			;9f72
	add a,b			;9f73
	ret			;9f74

; ----------------------------------------------------------------------
; DATOS restos_9F75: Restos que nadie usa: otro trozo de codigo como el de
;   0x9F30 (a 0xE400), unas llamadas, una lista de casillas (0xA0, 0x0F, 0xBE,
;   0x5E 0x5F...) y, desde 0x9FD5, el principio de la rutina del kakejiku que
;   se enrolla del primer Iga Ninpouchou (con 0xE1C4, 0xE1C3 y 0xE1CA)
;   0x9f75..0xa000  (139 bytes)
DATA_restos_9F75:
	defb 013h,021h,000h,0e4h,01ah,0feh,0ffh,028h,016h,077h,023h,013h,01ah,077h,023h,013h	; 9f75  .!.....(.w#..w#.
	defb 01ah,077h,023h,013h,01ah,077h,013h,0d5h,011h,00dh,000h,019h,0d1h,018h,0e5h,0cdh	; 9f85  .w#..w..........
	defb 0c8h,0a0h,0cdh,000h,0a0h,0c9h,0a0h,00fh,0a0h,00fh,0a0h,002h,0a0h,00fh,0a0h,00fh	; 9f95  ................
	defb 0a0h,002h,0a0h,00fh,0beh,00fh,0beh,002h,0beh,05eh,05fh,05eh,05fh,05eh,05fh,05eh	; 9fa5  .........^_^_^_^
	defb 05fh,05eh,05fh,05eh,05fh,05eh,05fh,05eh,05fh,05eh,05fh,05eh,05fh,05eh,05fh,05eh	; 9fb5  _^_^_^_^_^_^_^_^
	defb 05fh,05eh,05fh,05eh,05fh,05eh,05fh,05eh,05fh,00fh,0cfh,00fh,0cfh,002h,0cfh,0ffh	; 9fc5  _^_^_^_^_.......
	defb 03ah,0c4h,0e1h,03ch,032h,0c4h,0e1h,0feh,003h,0d8h,0afh,032h,0c4h,0e1h,03ah,0c3h	; 9fd5  :..<2......2..:.
	defb 0e1h,0feh,001h,0c2h,073h,0a0h,03ah,0cah,0e1h,03ch,032h,0cah,0e1h,021h,0cah,0e1h	; 9fe5  ....s.:..<2..!..
	defb 03ah,00ah,0e0h,0feh,002h,020h,004h,03eh,00ah,018h,012h	; 9ff5  :.... .>...

; ======================================================================
; CODIGO 0xa000..0xa029  (41 bytes)
; ======================================================================


objetos_e400:		; Los 16 objetos de 0xE400 (16 bytes): los que tienen tipo (+2) van a su rutina por la tabla de 0xA029, que lleva a todos a 0xAC52
	ld iy,0e400h		;a000   ; 16 objetos
	ld b,010h		;a004   ; 16
L_A006:
	push bc			;a006
	ld a,(iy+002h)		;a007   ; tipo?
	and a			;a00a   ; tiene tipo?
	jr nz,objetos_e400_uno		;a00b
objetos_e400_sigue:
	ld de,00010h		;a00d   ; el siguiente: + 16
	add iy,de		;a010
	pop bc			;a012
	djnz L_A006		;a013
	ret			;a015
objetos_e400_uno:
	call objetos_e400_salta		;a016   ; su rutina
	jr objetos_e400_sigue		;a019
objetos_e400_salta:		; Salta a la rutina A de la tabla de 0xA029
	ld hl,0a029h		;a01b   ; la tabla
	add a,a			;a01e   ; x 2
	add a,l			;a01f
	jr nc,L_A023		;a020
	inc h			;a022
L_A023:
	ld l,a			;a023
	ld e,(hl)			;a024   ; la direccion
	inc hl			;a025
	ld d,(hl)			;a026
	ex de,hl			;a027
	jp (hl)			;a028   ; salta

; ----------------------------------------------------------------------
; DATOS objetos_e400_tabla: La tabla de las rutinas de los objetos de 0xE400:
;   las 16 llevan a 0xAC52
;   0xa029..0xa049  (32 bytes)
DATA_objetos_e400_tabla:
	defb 052h,0ach,052h,0ach,052h,0ach,052h,0ach,052h,0ach,052h,0ach,052h,0ach,052h,0ach	; a029  R.R.R.R.R.R.R.R.
	defb 052h,0ach,052h,0ach,052h,0ach,052h,0ach,052h,0ach,052h,0ach,052h,0ach,052h,0ach	; a039  R.R.R.R.R.R.R.R.

; ----------------------------------------------------------------------
; DATOS codigo_suelto_A049: Codigo que nadie llama: 16 bytes de IY a cero, y
;   el sitio en la tabla de nombres (0x1800) de la Y y la X de IY
;   0xa049..0xa076  (45 bytes)
DATA_codigo_suelto_A049:
	defb 0fdh,0e5h,0e1h,006h,010h,036h,000h,023h,010h,0fbh,0c9h,0fdh,07eh,000h,0cbh,03fh	; a049  .....6.#....~..?
	defb 0cbh,03fh,0cbh,03fh,047h,021h,000h,018h,011h,020h,000h,019h,010h,0fdh,0fdh,07eh	; a059  .?.?G!... .....~
	defb 001h,0cbh,03fh,0cbh,03fh,0cbh,03fh,085h,030h,001h,024h,06fh,0c9h	; a069  ..?.?.?.0.$o.

; ======================================================================
; CODIGO 0xa076..0xa0a0  (42 bytes)
; ======================================================================


dibujo_vram:		; Un dibujo (ancho, alto y las casillas, en DE) en la tabla de nombres desde HL
	ld (0e1a0h),hl		;a076   ; el sitio
	ld a,(de)			;a079   ; el ancho
	ld (0e1a2h),a		;a07a
	inc de			;a07d
	ld a,(de)			;a07e   ; el alto
	ld b,a			;a07f
	inc de			;a080
dibujo_vram_fila:
	ld a,(0e1a2h)		;a081   ; el ancho
	ld c,a			;a084
	ld hl,(0e1a0h)		;a085
dibujo_vram_casilla:
	ld a,(de)			;a088   ; una casilla
	call 0004dh		;a089   ; WRTVRM
	inc de			;a08c   ; la siguiente
	inc hl			;a08d
	dec c			;a08e   ; una menos
	jr nz,dibujo_vram_casilla		;a08f
	ld hl,(0e1a0h)		;a091   ; la fila...
	push de			;a094
	ld de,00020h		;a095   ; ...siguiente
	add hl,de			;a098
	ld (0e1a0h),hl		;a099
	pop de			;a09c
	djnz dibujo_vram_fila		;a09d   ; una fila menos
	ret			;a09f

; ----------------------------------------------------------------------
; DATOS codigo_suelto_A0A0: Codigo que nadie llama: dibujo_vram escribiendo en
;   la RAM en vez de la VRAM
;   0xa0a0..0xa0c8  (40 bytes)
DATA_codigo_suelto_A0A0:
	defb 022h,0a0h,0e1h,01ah,032h,0a2h,0e1h,013h,01ah,047h,013h,03ah,0a2h,0e1h,04fh,02ah	; a0a0  "...2....G.:..O*
	defb 0a0h,0e1h,01ah,077h,013h,023h,00dh,020h,0f9h,02ah,0a0h,0e1h,0d5h,011h,020h,000h	; a0b0  ...w.#. .*.... .
	defb 019h,022h,0a0h,0e1h,0d1h,010h,0e4h,0c9h	; a0c0  ."......

; ======================================================================
; CODIGO 0xa0c8..0xa0f1  (41 bytes)
; ======================================================================


enemigos:		; Los 10 enemigos de 0xE360 (16 bytes; +4 el tipo): los que estan van a su rutina por la tabla de 0xA0F1
	ld iy,0e360h		;a0c8   ; los enemigos
	ld b,00ah		;a0cc   ; 10
otros_uno:
	push bc			;a0ce   ; la cuenta
	ld a,(iy+004h)		;a0cf   ; esta?
	and a			;a0d2
	jr nz,otros_mueve		;a0d3
otros_sig:
	ld de,00010h		;a0d5   ; el siguiente: + 16
	add iy,de		;a0d8
	pop bc			;a0da
	djnz otros_uno		;a0db
	ret			;a0dd
otros_mueve:
	call enemigos_salta		;a0de   ; se mueve
	jr otros_sig		;a0e1
enemigos_salta:		; Salta a la rutina del tipo A por la tabla de 0xA0F1
	ld hl,0a0f1h		;a0e3   ; la tabla
	add a,a			;a0e6   ; x 2
	add a,l			;a0e7
	jr nc,L_A0EB		;a0e8
	inc h			;a0ea
L_A0EB:
	ld l,a			;a0eb
	ld e,(hl)			;a0ec   ; la direccion
	inc hl			;a0ed
	ld d,(hl)			;a0ee
	ex de,hl			;a0ef
	jp (hl)			;a0f0   ; salta

; ----------------------------------------------------------------------
; DATOS enemigos_tabla: Las rutinas de los 16 tipos de enemigo: 0, 1, 3 y 6,
;   el ninja (0xA111); 2 y 7, 0xA47A; 4, 0xA52F; 5 y 10, 0xA5C7; 9, 0xA99D; 8
;   y 11-15, nada (0xAC51)
;   0xa0f1..0xa111  (32 bytes)
DATA_enemigos_tabla:
	defb 011h,0a1h,011h,0a1h,07ah,0a4h,011h,0a1h,02fh,0a5h,0c7h,0a5h,011h,0a1h,07ah,0a4h	; a0f1  ....z.../.....z.
	defb 051h,0ach,09dh,0a9h,0c7h,0a5h,051h,0ach,051h,0ach,051h,0ach,051h,0ach,051h,0ach	; a101  Q.....Q.Q.Q.Q.Q.

; ======================================================================
; CODIGO 0xa111..0xa46f  (862 bytes)
; ======================================================================


ninja_enemigo:		; Un ninja enemigo (+5 su paso): al salir, su altura (0x70 en las fases 0 y 1; si no, 0x38, 0x70, 0xA8 o la del ninja, por turno) y su color (el 6, 9; el 1, 12 en la fase 0 y 13 despues; los demas, 7 en la fase 1 y 14); entra por un lado, al azar o por el contrario al que mira el ninja, anda, salta (la tabla de 0xA46F) y tira cosas; si toca al ninja, el ninja muere, salvo que este saltando a un lado (+9 = 2 o 3) o con el poder 6, que lo derrotan, o con el poder 1, que no le pasa nada; el shuriken lo derrota: su tipo x 16 en puntos (en pantalla x 10), el efecto A 2 y un derrotado mas (0xE1B8)
	ld a,(iy+005h)		;a111   ; ya en marcha?
	and a			;a114   ; en marcha?
	jp nz,ninja_enemigo_paso		;a115
	ld a,(0e00ah)		;a118   ; las fases 0 y 1...
	cp 002h		;a11b   ; la 2 o mas?
	jr nc,ninja_enemigo_altura		;a11d
	ld (iy+000h),070h		;a11f   ; ...Y 0x70
	jr ninja_enemigo_color		;a123
ninja_enemigo_altura:
	ld a,(0e1c1h)		;a125   ; por turno (0xE1C1)...
	inc a			;a128   ; la siguiente...
	and 003h		;a129   ; ...de cuatro
	ld (0e1c1h),a		;a12b
	and a			;a12e   ; 0?
	jr nz,ninja_enemigo_altura1		;a12f
	ld (iy+000h),038h		;a131   ; ...0x38...
	jr ninja_enemigo_color		;a135
ninja_enemigo_altura1:
	cp 001h		;a137   ; 1?
	jr nz,ninja_enemigo_altura2		;a139
	ld (iy+000h),070h		;a13b   ; ...0x70...
	jr ninja_enemigo_color		;a13f
ninja_enemigo_altura2:
	cp 002h		;a141   ; 2?
	jr nz,ninja_enemigo_altura3		;a143
	ld (iy+000h),0a8h		;a145   ; ...0xA8...
	jr ninja_enemigo_color		;a149
ninja_enemigo_altura3:
	ld a,(ix+000h)		;a14b   ; ...o la del ninja
	ld (iy+000h),a		;a14e   ; su Y
ninja_enemigo_color:
	inc (iy+005h)		;a151   ; en marcha
	ld a,(iy+004h)		;a154   ; el 6?
	cp 006h		;a157   ; el 6?
	jr nz,ninja_enemigo_color1		;a159
	ld (iy+003h),009h		;a15b   ; color 9
	jr ninja_enemigo_lado		;a15f
ninja_enemigo_color1:
	cp 001h		;a161   ; el 1?
	jr nz,ninja_enemigo_color_otro		;a163
	ld a,(0e00ah)		;a165   ; la fase 0?
	and a			;a168
	jr nz,ninja_enemigo_color13		;a169
	ld (iy+003h),00ch		;a16b   ; en la fase 0, color 12
	jr ninja_enemigo_lado		;a16f
ninja_enemigo_color13:
	ld (iy+003h),00dh		;a171   ; si no, 13
	jr ninja_enemigo_lado		;a175
ninja_enemigo_color_otro:
	ld a,(0e00ah)		;a177   ; la fase 1?
	cp 001h		;a17a
	jr nz,ninja_enemigo_color14		;a17c
	ld (iy+003h),007h		;a17e   ; en la fase 1, color 7
	jr ninja_enemigo_lado		;a182
ninja_enemigo_color14:
	ld (iy+003h),00eh		;a184   ; si no, 14
ninja_enemigo_lado:
	ld (iy+013h),00bh		;a188   ; el segundo sprite, color 11
	ld (iy+014h),00fh		;a18c   ; el segundo sprite en pantalla
	ld (iy+007h),030h		;a190   ; la cuenta, 0x30
	ld a,(ix+008h)		;a194   ; hacia donde mira el ninja?
	and a			;a197   ; a la izquierda: sale por la derecha
	jr nz,ninja_enemigo_der		;a198
	ld a,(0e180h)		;a19a   ; va a la derecha?
	cp 003h		;a19d   ; a la derecha: sale por la derecha
	jr z,ninja_enemigo_der		;a19f
	cp 002h		;a1a1
	jr z,ninja_enemigo_der		;a1a3
	ld a,r		;a1a5   ; si no, al azar
	bit 2,a		;a1a7   ; al azar
	jr nz,ninja_enemigo_der		;a1a9
ninja_enemigo_izq:
	ld (iy+001h),008h		;a1ab   ; por la izquierda (X 8)
	ld a,001h		;a1af   ; hacia la derecha
	ld (iy+008h),a		;a1b1
	call enemigo_suelo		;a1b4   ; sitio libre?
	jr nc,ninja_enemigo_izq_mira		;a1b7   ; suelo?
ninja_enemigo_otro_lado:
	ld a,(iy+00dh)		;a1b9   ; ya probo el otro lado?
	and a			;a1bc
	jp nz,ninja_enemigo_fuera		;a1bd
	ld (iy+00fh),000h		;a1c0   ; si no, lo prueba
	ld (iy+00dh),001h		;a1c4
	jr ninja_enemigo_der		;a1c8
ninja_enemigo_izq_mira:
	call enemigo_libre_der		;a1ca   ; libre?
	jr c,ninja_enemigo_dibujo		;a1cd
	jr ninja_enemigo_otro_lado		;a1cf
ninja_enemigo_der:
	ld a,(0e00ah)		;a1d1   ; en la fase 0, pasada la posicion 0x42 del mapa, Y 0x48
	and a			;a1d4
	jr nz,ninja_enemigo_der_x		;a1d5
	ld a,(0e195h)		;a1d7   ; la posicion del mapa...
	cp 042h		;a1da
	jr c,ninja_enemigo_der_x		;a1dc
	ld (iy+000h),048h		;a1de   ; ...Y 0x48
ninja_enemigo_der_x:
	ld (iy+001h),0f0h		;a1e2   ; por la derecha (X 0xF0)
	xor a			;a1e6   ; hacia la izquierda
	ld (iy+008h),a		;a1e7
	call enemigo_suelo		;a1ea   ; suelo?
	jr nc,ninja_enemigo_der_mira		;a1ed
ninja_enemigo_der_otro:
	ld a,(iy+00dh)		;a1ef   ; ya probo el otro lado?
	and a			;a1f2
	jp nz,ninja_enemigo_fuera		;a1f3
	ld (iy+00fh),000h		;a1f6   ; si no, lo prueba
	ld (iy+00dh),001h		;a1fa
	jr ninja_enemigo_izq		;a1fe
ninja_enemigo_der_mira:
	call enemigo_libre_izq		;a200   ; libre?
	jr c,ninja_enemigo_dibujo		;a203
	jr ninja_enemigo_der_otro		;a205
ninja_enemigo_azar:		; Una cuenta al azar (+7) y un lado al azar (+8)
	ld a,r		;a207   ; al azar
	and 03fh		;a209
	ld (iy+007h),a		;a20b   ; la cuenta
	and 004h		;a20e   ; el lado
	rrca			;a210
	rrca			;a211
	ld (iy+008h),a		;a212
ninja_enemigo_dibujo:		; Su dibujo segun el lado: 0x50 a la izquierda, 0x60 a la derecha (el 6: 0xC0 y 0xD0)
	ld a,(iy+008h)		;a215   ; hacia donde?
	and a			;a218
	jr nz,ninja_enemigo_dibujo_der		;a219
	ld (iy+009h),050h		;a21b   ; a la izquierda: 0x50
	ld a,(iy+004h)		;a21f   ; el 6?
	cp 006h		;a222
	jp nz,ninja_enemigo_toca		;a224
	ld (iy+009h),0c0h		;a227   ; 0xC0
	jp ninja_enemigo_toca		;a22b
ninja_enemigo_dibujo_der:
	ld (iy+009h),060h		;a22e   ; a la derecha: 0x60
	ld a,(iy+004h)		;a232   ; el 6?
	cp 006h		;a235
	jp nz,ninja_enemigo_toca		;a237
	ld (iy+009h),0d0h		;a23a   ; 0xD0
	jp ninja_enemigo_toca		;a23e
ninja_enemigo_paso:		; Su paso (+5): 8, derrotado por el objeto 2; 4, fuera; 1, en marcha; los demas, la explosion (0xA747)
	cp 008h		;a241   ; 8?
	jp z,ninja_enemigo_derrotado		;a243
	cp 004h		;a246   ; 4?
	jp z,ninja_enemigo_explota		;a248
	cp 001h		;a24b   ; 1?
	jp nz,explosion		;a24d
	call enemigo_cae		;a250   ; lo que tira
	inc (iy+00eh)		;a253   ; la cuenta de cuadros...
	ld a,(iy+004h)		;a256   ; ...el 1, cada 3; los demas, cada 2
	cp 001h		;a259   ; el 1?
	jr nz,ninja_enemigo_lento		;a25b
	ld b,003h		;a25d   ; 3
	jr ninja_enemigo_cuadro		;a25f
ninja_enemigo_lento:
	ld b,002h		;a261   ; 2
ninja_enemigo_cuadro:
	ld a,(iy+00eh)		;a263   ; la cuenta
	cp b			;a266
	jp c,ninja_enemigo_toca		;a267
	ld (iy+00eh),000h		;a26a   ; a cero
	ld a,(iy+00bh)		;a26e   ; saltando?
	and a			;a271
	jr z,ninja_enemigo_anda		;a272
	ld a,(iy+000h)		;a274   ; a la altura del ninja?
	ld b,(ix+000h)		;a277   ; la Y del ninja
	cp b			;a27a
	jr nz,ninja_enemigo_salta		;a27b
	call ninja_enemigo_tira		;a27d   ; tira
ninja_enemigo_salta:
	ld a,(iy+00bh)		;a280   ; subiendo?
	cp 001h		;a283
	jr nz,ninja_enemigo_baja		;a285
	inc (iy+00ch)		;a287   ; un paso mas
	ld a,(iy+00ch)		;a28a
	cp 008h		;a28d   ; 8: ya baja
	jr c,ninja_enemigo_sube		;a28f
	inc (iy+00bh)		;a291
	jr ninja_enemigo_baja		;a294
ninja_enemigo_sube:
	ld hl,0a46fh		;a296   ; cuanto sube (0xA46F)
	add a,l			;a299
	jr nc,L_A29D		;a29a
	inc h			;a29c
L_A29D:
	ld l,a			;a29d   ; la tabla + el paso
	ld b,(hl)			;a29e   ; cuanto
	ld a,(iy+000h)		;a29f   ; la Y...
	sub b			;a2a2   ; ...menos eso
	ld (iy+000h),a		;a2a3
	jr ninja_enemigo_anda		;a2a6
ninja_enemigo_baja:
	dec (iy+00ch)		;a2a8
	jr nz,ninja_enemigo_baja_paso		;a2ab
	ld (iy+00bh),000h		;a2ad
	jr ninja_enemigo_anda		;a2b1
ninja_enemigo_baja_paso:
	ld a,(iy+00ch)		;a2b3
	ld hl,0a46fh		;a2b6
	add a,l			;a2b9
	jr nc,ninja_enemigo_baja_tabla		;a2ba
	inc h			;a2bc
ninja_enemigo_baja_tabla:
	ld l,a			;a2bd
	ld b,(hl)			;a2be
ninja_enemigo_baja_punto:
	push bc			;a2bf   ; uno
	call enemigo_suelo_mira		;a2c0   ; suelo?
	jr nc,ninja_enemigo_suelo		;a2c3   ; si: para
	inc (iy+000h)		;a2c5   ; un punto abajo
	pop bc			;a2c8
	djnz ninja_enemigo_baja_punto		;a2c9   ; tantos
	jr ninja_enemigo_anda		;a2cb
ninja_enemigo_suelo:
	pop bc			;a2cd
	ld (iy+00bh),000h		;a2ce   ; sin salto
	ld (iy+00ch),000h		;a2d2
ninja_enemigo_anda:
	call enemigo_suelo		;a2d6
	dec (iy+007h)		;a2d9   ; la cuenta
	jr nz,ninja_enemigo_lados		;a2dc
	ld a,(iy+00bh)		;a2de   ; saltando: otra vez a 1
	and a			;a2e1
	jr z,ninja_enemigo_decide		;a2e2
	ld (iy+007h),001h		;a2e4
	jr ninja_enemigo_lados		;a2e8
ninja_enemigo_decide:
	ld a,r		;a2ea   ; al azar: tira o no
	bit 3,a		;a2ec
	jp nz,ninja_enemigo_azar		;a2ee
	call ninja_enemigo_tira		;a2f1
	jp ninja_enemigo_azar		;a2f4
ninja_enemigo_tira:		; Tira una cosa (+0x20, un sprite), si no hay otra: el 6, una bala (+0x24 = 7) desde un poco mas arriba (o, en la fase 3, a veces desde 0xE0), color 15; los demas, un shuriken (+0x24 = 2), color 7; hacia donde va
	ld a,(iy+024h)		;a2f7   ; ya tiro?
	and a			;a2fa
	ret nz			;a2fb
	ld a,(iy+004h)		;a2fc   ; el 6?
	cp 006h		;a2ff
	jr nz,ninja_enemigo_shuriken		;a301
	ld a,(0e00ah)		;a303   ; en la fase 3, al azar...
	cp 003h		;a306
	jr nz,ninja_enemigo_bala		;a308
	ld a,r		;a30a
	bit 2,a		;a30c
	jr nz,ninja_enemigo_bala		;a30e
	ld (iy+020h),0e0h		;a310   ; ...desde arriba (Y 0xE0)
	jr ninja_enemigo_bala_pon		;a314
ninja_enemigo_bala:
	ld a,(iy+000h)		;a316   ; 6 por encima
	sub 006h		;a319
	ld (iy+020h),a		;a31b
ninja_enemigo_bala_pon:
	ld a,(iy+008h)		;a31e
	ld (iy+025h),a		;a321
	ld (iy+024h),007h		;a324   ; una bala
	ld a,(iy+001h)		;a328
	ld (iy+021h),a		;a32b
	ld (iy+023h),00fh		;a32e   ; color 15
	ret			;a332
ninja_enemigo_shuriken:
	ld a,(iy+008h)		;a333
	ld (iy+025h),a		;a336
	ld (iy+024h),002h		;a339   ; un shuriken
	ld a,(iy+000h)		;a33d
	ld (iy+020h),a		;a340
	ld a,(iy+001h)		;a343
	ld (iy+021h),a		;a346
	ld (iy+023h),007h		;a349   ; color 7
	ret			;a34d
ninja_enemigo_lados:
	ld a,(iy+008h)		;a34e   ; a la izquierda?
	and a			;a351
	jr nz,ninja_enemigo_va_der		;a352
	call enemigo_libre_izq		;a354   ; libre?
	jr nc,ninja_enemigo_vuelve_der		;a357
	dec (iy+001h)		;a359   ; un punto a la izquierda
	jr ninja_enemigo_toca		;a35c
ninja_enemigo_vuelve_der:
	ld (iy+009h),060h		;a35e   ; da la vuelta
	ld (iy+008h),001h		;a362
	jr ninja_enemigo_toca		;a366
ninja_enemigo_va_der:
	call enemigo_libre_der		;a368   ; libre?
	jr nc,ninja_enemigo_vuelve_izq		;a36b
	inc (iy+001h)		;a36d   ; un punto a la derecha
	jr ninja_enemigo_toca		;a370
ninja_enemigo_vuelve_izq:
	ld (iy+009h),050h		;a372
	ld (iy+008h),000h		;a376
	ld a,(0e00ah)		;a37a   ; desde la fase 1, salta
	and a			;a37d
	jr z,ninja_enemigo_toca		;a37e
	ld (iy+00bh),001h		;a380
ninja_enemigo_toca:
	ld a,(iy+001h)		;a384   ; el segundo sprite, con el
	ld (iy+011h),a		;a387
	ld a,(iy+000h)		;a38a
	ld (iy+010h),a		;a38d
	ld bc,008f8h		;a390   ; cerca en X?
	call cerca_x		;a393
	jr nc,ninja_enemigo_shuriken_toca		;a396
	ld a,(ix+00ah)		;a398   ; el ninja agachado?
	and a			;a39b
	jr z,ninja_enemigo_toca_y		;a39c
	ld bc,00cfch		;a39e
	jr ninja_enemigo_toca_y2		;a3a1
ninja_enemigo_toca_y:
	ld bc,00cf4h		;a3a3
ninja_enemigo_toca_y2:
	call cerca_y		;a3a6   ; cerca en Y?
	jr nc,ninja_enemigo_shuriken_toca		;a3a9
	ld a,(ix+009h)		;a3ab   ; saltando a la derecha...
	cp 002h		;a3ae
	jr z,ninja_enemigo_pisado_der		;a3b0
	cp 003h		;a3b2   ; ...o a la izquierda: lo derrota
	jr z,ninja_enemigo_pisado_izq		;a3b4
	ld a,(ix+018h)		;a3b6   ; el poder 1: nada
	cp 001h		;a3b9
	jr z,ninja_enemigo_shuriken_toca		;a3bb
	cp 006h		;a3bd   ; el poder 6: lo derrota
	jp z,ninja_enemigo_derrotado		;a3bf
	ld a,001h		;a3c2   ; si no, el ninja muere
	ld (0e183h),a		;a3c4
	jp ninja_enemigo_dibujo_pon		;a3c7
ninja_enemigo_pisado_der:
	jp ninja_enemigo_derrotado		;a3ca
ninja_enemigo_pisado_izq:
	jp ninja_enemigo_derrotado		;a3cd
ninja_enemigo_shuriken_toca:
	ld a,(ix+024h)		;a3d0   ; el shuriken del ninja en marcha?
	and a			;a3d3
	jr z,ninja_enemigo_dibujo_pon		;a3d4
	ld bc,002f2h		;a3d6   ; cerca en Y?
	call cerca_y2		;a3d9
	jr nc,ninja_enemigo_dibujo_pon		;a3dc
	ld bc,008f8h		;a3de   ; y en X?
	call cerca_x2		;a3e1
	jr nc,ninja_enemigo_esquiva		;a3e4
ninja_enemigo_derrotado:
	ld a,(iy+004h)		;a3e6   ; su tipo x 16...
	and 00fh		;a3e9
	rlca			;a3eb
	rlca			;a3ec
	rlca			;a3ed
	rlca			;a3ee
	call puntos_suma		;a3ef   ; ...en puntos
	ld a,002h		;a3f2   ; el efecto A 2
	call efecto_a_pide		;a3f4
	call shuriken_fuera		;a3f7   ; el shuriken fuera
	ld a,(0e1b8h)		;a3fa   ; un derrotado mas
	inc a			;a3fd
	daa			;a3fe
	ld (0e1b8h),a		;a3ff
	call derrotados_pinta		;a402   ; en el marcador
	ld a,(iy+004h)		;a405   ; el 6?
	cp 006h		;a408
	jr nz,ninja_enemigo_explota		;a40a
	ld a,(0e00ah)		;a40c   ; su espera: 0x70 en la fase 3...
	ld c,070h		;a40f
	cp 003h		;a411
	jr z,ninja_enemigo_espera6		;a413
	ld c,040h		;a415   ; ...0x40 en la 2...
	cp 002h		;a417
	jr z,ninja_enemigo_espera6		;a419
	ld c,010h		;a41b   ; ...0x10 en las demas
ninja_enemigo_espera6:
	ld a,r		;a41d   ; mas 0-63 al azar
	and 03fh		;a41f
	add a,c			;a421
	ld (0e1cah),a		;a422
ninja_enemigo_explota:
	ld (iy+005h),005h		;a425   ; el paso 5: la explosion
	ld (iy+006h),000h		;a429
	jr ninja_enemigo_dibujo_pon		;a42d
ninja_enemigo_esquiva:
	ld a,r		;a42f   ; al azar...
	bit 5,a		;a431
	jr nz,ninja_enemigo_dibujo_pon		;a433
	ld bc,040c0h		;a435   ; ...con el shuriken cerca...
	call cerca_x2		;a438
	jr nc,ninja_enemigo_dibujo_pon		;a43b
	ld a,(iy+00bh)		;a43d
	and a			;a440
	jr nz,ninja_enemigo_dibujo_pon		;a441
	ld a,(iy+00fh)		;a443
	and a			;a446
	jr nz,ninja_enemigo_dibujo_pon		;a447
	ld (iy+00bh),001h		;a449   ; ...salta
ninja_enemigo_dibujo_pon:
	ld a,(0e012h)		;a44d   ; cada 8 cuadros, otro dibujo
	and 008h		;a450
	ld b,(iy+009h)		;a452
	add a,b			;a455
	ld (iy+002h),a		;a456
	add a,004h		;a459
	ld (iy+012h),a		;a45b
	ld a,(iy+001h)		;a45e   ; fuera por la derecha?
	cp 0f8h		;a461
	ret c			;a463
ninja_enemigo_fuera:
	ld (iy+010h),0ech		;a464
	ld (iy+014h),000h		;a468
	jp otro_borra_va		;a46c

; ----------------------------------------------------------------------
; DATOS ninja_enemigo_salto: Cuanto sube el ninja enemigo en cada paso del
;   salto (8) y cuanto baja, al reves
;   0xa46f..0xa47a  (11 bytes)
DATA_ninja_enemigo_salto:
	defb 004h,004h,004h,003h,003h,002h,002h,001h,001h,000h,000h	; a46f  ...........

; ======================================================================
; CODIGO 0xa47a..0xa716  (668 bytes)
; ======================================================================


tiro_enemigo:		; Los tipos 2 y 7: lo que tiran los enemigos, 3 puntos por cuadro hacia su lado (+5); si toca al ninja, el ninja muere (salvo el poder 1; con el poder 6 se rompe); el shuriken del ninja lo rompe (el efecto A 3); el 7, dibujo 0x78 o 0x7C; el 2 gira (0xA4 / 0xA8); fuera por el borde
	ld a,(iy+005h)		;a47a   ; 8: fuera
	cp 008h		;a47d
	jp z,otro_borra_va		;a47f
	and a			;a482   ; a la izquierda?
	jr nz,tiro_enemigo_der		;a483
	ld a,(iy+001h)		;a485   ; 3 a la izquierda
	sub 003h		;a488
	ld (iy+001h),a		;a48a
	jr tiro_enemigo_toca		;a48d
tiro_enemigo_der:
	ld a,(iy+001h)		;a48f   ; 3 a la derecha
	add a,003h		;a492
	ld (iy+001h),a		;a494
tiro_enemigo_toca:
	ld a,(iy+004h)		;a497   ; el 7?
	cp 007h		;a49a
	jr nz,tiro_enemigo_agachado		;a49c
	ld bc,002f6h		;a49e   ; cerca en Y?
	call cerca_y		;a4a1
	jr nc,tiro_enemigo_shuriken		;a4a4
	jr tiro_enemigo_x		;a4a6
tiro_enemigo_agachado:
	ld a,(ix+00ah)		;a4a8   ; el ninja agachado?
	and a			;a4ab
	jr z,tiro_enemigo_de_pie		;a4ac
	ld a,(ix+000h)		;a4ae   ; la diferencia de alturas...
	ld b,(iy+000h)		;a4b1
	sub b			;a4b4
	cp 0f2h		;a4b5
	jr c,tiro_enemigo_shuriken		;a4b7
	cp 0fah		;a4b9
	jr nc,tiro_enemigo_shuriken		;a4bb
	jr tiro_enemigo_x		;a4bd
tiro_enemigo_de_pie:
	ld bc,00efeh		;a4bf
	call cerca_y		;a4c2
	jr nc,tiro_enemigo_shuriken		;a4c5
tiro_enemigo_x:
	ld bc,007f9h		;a4c7   ; cerca en X?
	call cerca_x		;a4ca
	jr nc,tiro_enemigo_shuriken		;a4cd
	ld a,(ix+018h)		;a4cf   ; el poder 1: nada
	cp 001h		;a4d2
	jr z,tiro_enemigo_dibujo		;a4d4
	cp 006h		;a4d6   ; el poder 6: lo rompe
	jr z,tiro_enemigo_roto		;a4d8
	ld a,001h		;a4da   ; si no, el ninja muere
	ld (0e183h),a		;a4dc
	jr tiro_enemigo_dibujo		;a4df
tiro_enemigo_shuriken:
	ld a,(ix+024h)		;a4e1   ; el shuriken del ninja?
	and a			;a4e4
	jr z,tiro_enemigo_dibujo		;a4e5
	ld bc,006fah		;a4e7
	call cerca_y2		;a4ea
	jr nc,tiro_enemigo_dibujo		;a4ed
	ld bc,006fah		;a4ef
	call cerca_x2		;a4f2
	jr nc,tiro_enemigo_dibujo		;a4f5
tiro_enemigo_roto:
	ld a,003h		;a4f7   ; el efecto A 3
	call efecto_a_pide		;a4f9
	call shuriken_fuera		;a4fc   ; el shuriken fuera
	jp otro_borra_va		;a4ff   ; y el tiro
tiro_enemigo_dibujo:
	ld a,(iy+004h)		;a502   ; el 7?
	cp 007h		;a505
	jr nz,tiro_enemigo_gira		;a507
	ld a,(iy+005h)		;a509
	and a			;a50c
	jr nz,tiro_enemigo_dibujo_der		;a50d
	ld (iy+002h),078h		;a50f   ; a la izquierda, 0x78
	jr tiro_enemigo_borde		;a513
tiro_enemigo_dibujo_der:
	ld (iy+002h),07ch		;a515   ; a la derecha, 0x7C
	jr tiro_enemigo_borde		;a519
tiro_enemigo_gira:
	ld a,(0e012h)		;a51b   ; cada 2 cuadros, 0xA4 o 0xA8
	and 002h		;a51e
	rlca			;a520
	add a,0a4h		;a521
	ld (iy+002h),a		;a523
tiro_enemigo_borde:
	ld a,(iy+001h)		;a526   ; en el borde?
	cp 0f0h		;a529
	ret c			;a52b
	jp otro_borra_va		;a52c
enemigo4:		; El tipo 4 (en la fase 1): quieto, dibujo 0x70, color 13 (parpadeando 9 / 11); cada tanto (+7, al azar) suelta algo (+0x14 = 5) desde su sitio; con cinco tiros de shuriken: 500 puntos (en pantalla) y pasa a ser un tipo 1 que sale de el
	ld a,(iy+005h)		;a52f   ; al salir...
	and a			;a532
	jr nz,enemigo4_va		;a533
	inc (iy+005h)		;a535
	ld (iy+002h),070h		;a538   ; ...dibujo 0x70, color 13
	ld (iy+003h),00dh		;a53c
	ld (iy+007h),040h		;a540   ; la espera, 0x40
	ret			;a544
enemigo4_va:
	cp 008h		;a545   ; 8: fuera
	jp z,otro_borra_va		;a547
	ld a,(iy+014h)		;a54a   ; soltando?
	and a			;a54d
	jr nz,enemigo4_tiro		;a54e
	dec (iy+007h)		;a550   ; la espera
	jr nz,enemigo4_tiro		;a553
	ld a,r		;a555   ; la siguiente: 0x20 + 0-63
	and 03fh		;a557
	add a,020h		;a559
	ld (iy+007h),a		;a55b
	ld (iy+014h),005h		;a55e   ; suelta algo
	ld a,(iy+000h)		;a562
	ld (iy+010h),a		;a565
	ld a,(iy+001h)		;a568
	ld (iy+011h),a		;a56b
enemigo4_tiro:
	ld a,(ix+024h)		;a56e   ; el shuriken del ninja?
	and a			;a571
	jr z,enemigo4_color		;a572
	ld bc,001f8h		;a574
	call cerca_y2		;a577
	jr nc,enemigo4_color		;a57a
	ld bc,006fah		;a57c
	call cerca_x2		;a57f
	jr nc,enemigo4_color		;a582
	call shuriken_fuera		;a584   ; fuera
	inc (iy+00ch)		;a587   ; un tiro mas
	ld a,(iy+00ch)		;a58a
	cp 005h		;a58d   ; 5?
	jr c,enemigo4_color		;a58f
	ld a,050h		;a591   ; 500 puntos
	call puntos_suma		;a593
	ld (iy+005h),005h		;a596   ; la explosion...
	ld (iy+006h),000h		;a59a
	ld (iy+004h),001h		;a59e   ; ...y un tipo 1
	ld a,(iy+000h)		;a5a2
	ld (iy+010h),a		;a5a5
	ld a,(iy+001h)		;a5a8
	ld (iy+011h),a		;a5ab
	ld (iy+014h),00fh		;a5ae
	ret			;a5b2
enemigo4_color:
	ld a,(0e012h)		;a5b3   ; cada 4 cuadros, 9 u 11
	and 004h		;a5b6
	rrca			;a5b8
	add a,009h		;a5b9
	ld (iy+003h),a		;a5bb
	ld a,(iy+001h)		;a5be   ; en el borde?
	cp 008h		;a5c1
	ret nc			;a5c3
	jp otro_borra_va		;a5c4
cae_enemigo:		; Los tipos 5 y 10: algo que cae hacia el ninja: al salir, su inclinacion (+6, 0-10) segun lo lejos que este el ninja en X; baja un punto por cuadro y se va de lado (hasta 5 puntos); el 10 tiene el dibujo de la vuelta (0x80, 0x84 o 0x98); el 5, 0x9C, color 7; en la fase 6 y desde la segunda vuelta, cada 2 pasos se acerca a la altura del ninja; si toca al ninja, el ninja muere (salvo el poder 1; con el 6 se rompe); se va por los bordes o al llegar abajo (el 5 en la Y 0x7C, el 10 en la 0x94)
	ld a,(iy+005h)		;a5c7   ; 8: fuera
	cp 008h		;a5ca   ; 8?
	jp z,otro_borra_va		;a5cc
	and a			;a5cf   ; al salir
	jr nz,cae_enemigo_paso		;a5d0   ; ya en marcha
	inc (iy+005h)		;a5d2   ; en marcha
	ld c,000h		;a5d5   ; la inclinacion, segun la distancia en X
	ld a,(ix+001h)		;a5d7   ; la X del ninja...
	ld b,(iy+001h)		;a5da
	sub b			;a5dd   ; ...menos la suya
	cp 0f0h		;a5de   ; muy cerca a la izquierda: 0
	jr nc,cae_enemigo_pon		;a5e0
	inc c			;a5e2
	cp 0e0h		;a5e3   ; menos de 0x20: 1
	jr nc,cae_enemigo_pon		;a5e5
	inc c			;a5e7
	cp 0d0h		;a5e8   ; 0x30: 2
	jr nc,cae_enemigo_pon		;a5ea
	inc c			;a5ec
	cp 0c0h		;a5ed   ; 0x40: 3
	jr nc,cae_enemigo_pon		;a5ef
	inc c			;a5f1
	cp 0b0h		;a5f2   ; 0x50: 4
	jr nc,cae_enemigo_pon		;a5f4
	inc c			;a5f6
	cp 080h		;a5f7   ; 0x80: 5
	jr nc,cae_enemigo_pon		;a5f9
	inc c			;a5fb
	cp 050h		;a5fc   ; a la derecha, lejos: 6
	jr nc,cae_enemigo_pon		;a5fe
	inc c			;a600
	cp 040h		;a601   ; 7
	jr nc,cae_enemigo_pon		;a603
	inc c			;a605
	cp 030h		;a606   ; 8
	jr nc,cae_enemigo_pon		;a608
	inc c			;a60a
	cp 020h		;a60b   ; 9
	jr nc,cae_enemigo_pon		;a60d
	inc c			;a60f
	cp 010h		;a610   ; 10
	jr nc,cae_enemigo_pon		;a612
	ld c,000h		;a614   ; muy cerca: 0
cae_enemigo_pon:
	ld (iy+006h),c		;a616
	ld (iy+002h),09ch		;a619   ; dibujo 0x9C, color 7
	ld (iy+003h),007h		;a61d   ; color 7
cae_enemigo_paso:
	ld a,(iy+006h)		;a621   ; la inclinacion: 0-5, a la izquierda; 6-10, a la derecha
	and a			;a624   ; 0: recto
	jr z,cae_baja		;a625
	cp 001h		;a627
	jr z,cae_izq1		;a629
	cp 002h		;a62b   ; 2
	jr z,cae_izq2		;a62d
	cp 003h		;a62f
	jr z,cae_izq3		;a631
	cp 004h		;a633   ; 4
	jr z,cae_izq4		;a635
	cp 005h		;a637
	jr z,cae_izq5		;a639
	cp 006h		;a63b   ; 6
	jr z,cae_der5		;a63d
	cp 007h		;a63f
	jr z,cae_der4		;a641
	cp 008h		;a643   ; 8
	jr z,cae_der3		;a645
	cp 009h		;a647
	jr z,cae_der2		;a649
	jr cae_der1		;a64b   ; 10
cae_izq5:
	dec (iy+001h)		;a64d   ; 5 a la izquierda...
cae_izq4:
	dec (iy+001h)		;a650
cae_izq3:
	dec (iy+001h)		;a653
cae_izq2:
	dec (iy+001h)		;a656
cae_izq1:
	dec (iy+001h)		;a659   ; ...1
cae_baja:
	inc (iy+000h)		;a65c   ; un punto abajo
	jr cae_dibujo		;a65f
cae_der5:
	inc (iy+001h)		;a661   ; 5 a la derecha...
cae_der4:
	inc (iy+001h)		;a664
cae_der3:
	inc (iy+001h)		;a667
cae_der2:
	inc (iy+001h)		;a66a
cae_der1:
	inc (iy+001h)		;a66d   ; ...1
	jr cae_baja		;a670
cae_dibujo:
	ld a,(iy+004h)		;a672   ; el 10?
	cp 00ah		;a675
	jr nz,cae_dibujo5		;a677
	ld a,(0e009h)		;a679   ; su dibujo segun la vuelta: 0x80...
	ld b,080h		;a67c
	and a			;a67e
	jr z,cae_dibujo_pon		;a67f
	ld b,084h		;a681   ; ...0x84...
	cp 001h		;a683
	jr z,cae_dibujo_pon		;a685
	ld b,098h		;a687   ; ...o 0x98
cae_dibujo_pon:
	ld (iy+002h),b		;a689
	jr cae_toca		;a68c
cae_dibujo5:
	ld (iy+002h),09ch		;a68e
cae_toca:
	ld a,(ix+00ah)		;a692   ; el ninja agachado?
	and a			;a695
	jr z,cae_toca_pie		;a696
	ld bc,006ffh		;a698
	call cerca_y		;a69b
	jr nc,cae_persigue		;a69e
	jr cae_toca_x		;a6a0
cae_toca_pie:
	ld bc,006fah		;a6a2
	call cerca_y		;a6a5
	jr nc,cae_persigue		;a6a8
cae_toca_x:
	ld bc,006fah		;a6aa
	call cerca_x		;a6ad
	jr nc,cae_persigue		;a6b0
	ld a,(ix+018h)		;a6b2   ; el poder 1: nada
	cp 001h		;a6b5
	jr z,cae_persigue		;a6b7
	cp 006h		;a6b9   ; el poder 6: se rompe
	jp z,otro_borra_va		;a6bb
	ld a,001h		;a6be   ; si no, el ninja muere
	ld (0e183h),a		;a6c0
	ret			;a6c3
cae_persigue:
	ld a,(0e00ah)		;a6c4   ; la fase 6...
	cp 006h		;a6c7
	jr z,cae_persigue_paso		;a6c9
	ld a,(0e009h)		;a6cb   ; ...o desde la segunda vuelta
	and a			;a6ce
	jr z,cae_bordes		;a6cf
cae_persigue_paso:
	inc (iy+00ah)		;a6d1   ; cada 2 pasos
	ld a,(iy+00ah)		;a6d4
	cp 002h		;a6d7
	jr c,cae_bordes		;a6d9
	ld (iy+00ah),000h		;a6db
	ld a,(ix+000h)		;a6df   ; la Y del ninja
	ld b,(iy+000h)		;a6e2
	cp b			;a6e5
	jr c,cae_persigue_sube		;a6e6
	inc (iy+000h)		;a6e8
	jr cae_bordes		;a6eb
cae_persigue_sube:
	dec (iy+000h)		;a6ed
cae_bordes:
	ld a,(iy+001h)		;a6f0   ; por los lados?
	cp 004h		;a6f3
	jp c,otro_borra_va		;a6f5
	cp 0f8h		;a6f8
	jp nc,otro_borra_va		;a6fa
	ld a,(iy+004h)		;a6fd   ; el 5?
	cp 005h		;a700
	jr nz,cae_abajo10		;a702
	ld a,(iy+000h)		;a704   ; abajo (0x7C)?
	cp 07ch		;a707
	ret c			;a709
	jp otro_borra_va		;a70a
cae_abajo10:
	ld a,(iy+000h)		;a70d   ; abajo (0x94)?
	cp 094h		;a710
	ret c			;a712
	jp otro_borra_va		;a713

; ----------------------------------------------------------------------
; DATOS codigo_suelto_A716: Codigo que nadie llama: el sitio de IY en la
;   pantalla de la RAM (0xE740, filas de 24) y su Y y X x 8
;   0xa716..0xa747  (49 bytes)
DATA_codigo_suelto_A716:
	defb 021h,040h,0e7h,0fdh,07eh,000h,0a7h,028h,007h,047h,011h,018h,000h,019h,010h,0fdh	; a716  !@..~..(.G......
	defb 0fdh,07eh,001h,085h,030h,001h,024h,06fh,0fdh,075h,00ch,0fdh,074h,00dh,0fdh,07eh	; a726  .~..0.$o.u..t..~
	defb 000h,007h,007h,007h,0fdh,077h,000h,0fdh,07eh,001h,007h,007h,007h,0fdh,077h,001h	; a736  .....w..~.....w.
	defb 0c9h	; a746

; ======================================================================
; CODIGO 0xa747..0xa78f  (72 bytes)
; ======================================================================


explosion:		; La explosion de un enemigo (+6 su cuenta): 0x20 cuadros con los dibujos 0x88 / 0x90 cada 4 y el color 15 / 9 cada 8; despues, fuera
	inc (iy+006h)		;a747   ; la cuenta
	ld a,(iy+006h)		;a74a
	cp 020h		;a74d   ; 0x20?
	jr c,explosion_dibujo		;a74f
	ld (iy+014h),000h		;a751   ; fuera
	ld (iy+010h),0ech		;a755
	jp otro_borra_va		;a759
explosion_dibujo:
	ld a,(0e012h)		;a75c   ; cada 4 cuadros, 0x88 o 0x90
	and 004h		;a75f
	rlca			;a761
	add a,088h		;a762
	ld (iy+002h),a		;a764
	add a,004h		;a767
	ld (iy+012h),a		;a769
	ld a,(0e012h)		;a76c   ; cada 8, color 15 o 9
	and 008h		;a76f
	and a			;a771
	jr nz,explosion_color9		;a772
	ld (iy+003h),00fh		;a774
	jr explosion_borde		;a778
explosion_color9:
	ld (iy+003h),009h		;a77a
explosion_borde:
	ld a,(iy+001h)		;a77e   ; fuera por la derecha?
	cp 0f8h		;a781
	ret c			;a783
	ld (iy+014h),000h		;a784   ; el segundo sprite...
	ld (iy+010h),0ech		;a788   ; ...fuera
	jp otro_borra_va		;a78c

; ----------------------------------------------------------------------
; DATOS codigo_suelto_A78F: Codigo que nadie llama: unas comprobaciones de si
;   algo toca al ninja (cerca_y, cerca_x y las del sprite 2), como las de los
;   enemigos
;   0xa78f..0xa7de  (79 bytes)
DATA_codigo_suelto_A78F:
	defb 0c9h,0ddh,07eh,004h,0a7h,020h,012h,001h,0f6h,00ah,0cdh,03eh,087h,030h,00ah,001h	; a78f  ..~.. .....>.0..
	defb 0f8h,008h,0cdh,04dh,087h,030h,002h,037h,0c9h,0afh,0c9h,0ddh,07eh,00dh,0a7h,028h	; a79f  ...M.0.7....~..(
	defb 019h,0ddh,07eh,024h,0cbh,047h,020h,014h,001h,0fah,006h,0cdh,05dh,087h,030h,00ah	; a7af  ..~$.G .....].0.
	defb 001h,0f5h,00bh,0cdh,055h,087h,030h,002h,037h,0c9h,0afh,0c9h,001h,0f6h,00ah,0cdh	; a7bf  ....U.0.7.......
	defb 05dh,087h,030h,0f6h,001h,0f9h,009h,0cdh,055h,087h,030h,0eeh,037h,0c9h,0c9h	; a7cf  ].0.....U.0.7..

; ======================================================================
; CODIGO 0xa7de..0xa945  (359 bytes)
; ======================================================================


fase_fin:		; Cuando acaba la fase: en la 0, con 10 derrotados (0xE1B8; con el primer Iga en otro slot, basta con estar a la altura 0x70) y pasada la posicion 0x48 del mapa; en la 1, al llegar a la 0xC0; desde la 2, al coger el 0x6E (0xE1C9); en las dos primeras, la musica 3, el ninja anda hasta la X 0x9C y la puerta se abre y se cierra en la pantalla (cuatro dibujos, 0xA945-0xA987): 1.000 puntos (en pantalla); en las demas, la salida se abre en el mapa en tres pasos (0x4790, 0x47A2, 0x477E): 2.000 puntos; y la fase acabada (0xE186)
	ld a,(0e00ah)		;a7de   ; la fase 0?
	cp 000h		;a7e1
	jp nz,fase_fin_fase1		;a7e3
	ld a,(0e060h)		;a7e6   ; el primer Iga?
	and a			;a7e9
	jr z,fase_fin_derrotados		;a7ea
	ld a,(ix+000h)		;a7ec   ; a la altura 0x70?
	cp 070h		;a7ef
	ret nz			;a7f1
	jr fase_fin_posicion		;a7f2
fase_fin_derrotados:
	ld a,(0e1b8h)		;a7f4   ; 10 derrotados?
	cp 010h		;a7f7
	ret c			;a7f9
fase_fin_posicion:
	ld a,(0e195h)		;a7fa   ; pasada la posicion 0x48?
	cp 048h		;a7fd
	ret c			;a7ff
fase_fin_puerta:
	ld a,(ix+009h)		;a800   ; saltando?
	and a			;a803
	ret nz			;a804
	ld (ix+00ah),000h		;a805   ; de pie
	ld a,003h		;a809   ; la musica 3
	call musica_pide		;a80b
	call puntos_pinta		;a80e   ; los puntos
	call todos_fuera		;a811   ; todos fuera
fase_fin_anda:
	call fase_fin_cuadro		;a814   ; un cuadro
	inc (ix+001h)		;a817   ; un punto a la derecha
	inc (ix+011h)		;a81a
	ld (ix+00bh),000h		;a81d
	ld a,(ix+001h)		;a821   ; hasta la X 0x9C
	cp 09ch		;a824
	jr c,fase_fin_anda		;a826
	ld (ix+004h),000h		;a828   ; el paso de la puerta (+4)
fase_fin_puerta_paso:
	ld a,(0e013h)		;a82c   ; 0x30 cuadros
	cp 030h		;a82f
	jr c,fase_fin_puerta_paso		;a831
	xor a			;a833
	ld (0e013h),a		;a834
	call sprites_rota		;a837
	ld a,(ix+004h)		;a83a   ; el paso
	and a			;a83d
	jr z,fase_fin_cerrada		;a83e
	cp 001h		;a840
	jr z,fase_fin_medio		;a842
	ld (ix+000h),06ch		;a844   ; el ninja en la puerta (Y 0x6C)
	ld (ix+010h),06ch		;a848
	cp 002h		;a84c
	jr z,fase_fin_abierta		;a84e
	ld (ix+000h),0ech		;a850   ; y dentro (fuera de la pantalla)
	ld (ix+010h),0ech		;a854
	cp 003h		;a858
	jr z,fase_fin_medio		;a85a
	cp 004h		;a85c
	jr z,fase_fin_cerrada		;a85e
	cp 005h		;a860
	jr z,fase_fin_vacia		;a862
	ld a,001h		;a864   ; acabado: 100 x 10 puntos
	call puntos_suma_cien		;a866
	ld a,001h		;a869   ; la fase acabada
	ld (0e186h),a		;a86b
	ret			;a86e
fase_fin_cerrada:
	ld de,0a945h		;a86f
	jr fase_fin_puerta_pinta		;a872
fase_fin_medio:
	ld de,0a95bh		;a874
	jr fase_fin_puerta_pinta		;a877
fase_fin_abierta:
	ld de,0a971h		;a879
	jr fase_fin_puerta_pinta		;a87c
fase_fin_vacia:
	ld a,020h		;a87e
	ld (0e013h),a		;a880
	ld de,0a987h		;a883
fase_fin_puerta_pinta:
	ld hl,01972h		;a886   ; en la fila 11, columna 18
	call dibujo_vram		;a889
	inc (ix+004h)		;a88c
	jr fase_fin_puerta_paso		;a88f
fase_fin_cuadro:		; Un cuadro de la puerta: espera, los sprites y el ninja andando
	ld a,(0e011h)		;a891   ; un cuadro
	cp 001h		;a894
	jr c,fase_fin_cuadro		;a896
	xor a			;a898   ; la cuenta a 0
	ld (0e011h),a		;a899
	call sprites_rota		;a89c   ; los sprites
	ld a,(0e012h)		;a89f   ; el paso, cada 8 cuadros
	and 008h		;a8a2
	ld (ix+00eh),a		;a8a4
	ld (ix+00dh),001h		;a8a7   ; andando
	call ninja_dibujo		;a8ab   ; su dibujo
	ret			;a8ae
fase_fin_fase1:
	cp 001h		;a8af   ; la fase 1?
	jr nz,fase_fin_salida		;a8b1
	ld a,(ix+009h)		;a8b3
	and a			;a8b6
	ret nz			;a8b7
	ld a,(0e195h)		;a8b8   ; el final del mapa (0xC0)?
	cp 0c0h		;a8bb
	jp z,fase_fin_puerta		;a8bd
	ret			;a8c0
fase_fin_salida:
	ld a,(0e1c9h)		;a8c1   ; el 0x6E cogido?
	and a			;a8c4
	ret z			;a8c5
	xor a			;a8c6
	ld (0e011h),a		;a8c7
	ld (0e1b0h),a		;a8ca
	call puntos_pinta		;a8cd   ; los puntos
	call todos_fuera		;a8d0
	ld a,003h		;a8d3   ; la musica 3
	call musica_pide		;a8d5
	ld a,(0e00ah)		;a8d8
	cp 002h		;a8db
	jr z,fase_fin_salida_paso		;a8dd
fase_fin_salida_paso:
	ld a,(0e011h)		;a8df   ; 24 cuadros
	cp 018h		;a8e2
	jr c,fase_fin_salida_paso		;a8e4
	xor a			;a8e6
	ld (0e011h),a		;a8e7
	ld a,(0e00ah)		;a8ea   ; el sitio de la salida segun la fase: 2, 0xF0A1...
	ld hl,0f0a1h		;a8ed
	cp 002h		;a8f0
	jr z,fase_fin_salida_dibujo		;a8f2
	ld hl,0f083h		;a8f4   ; ...3, 0xF083...
	cp 003h		;a8f7
	jr z,fase_fin_salida_dibujo		;a8f9
	ld hl,0ededh		;a8fb   ; ...4, 0xEDED...
	cp 004h		;a8fe
	jr z,fase_fin_salida_dibujo		;a900
	ld hl,0ee19h		;a902   ; ...las demas, 0xEE19
fase_fin_salida_dibujo:
	ld a,(0e1b0h)		;a905   ; el paso
	ld de,04790h		;a908
	and a			;a90b
	jr z,fase_fin_salida_pon		;a90c
	ld de,047a2h		;a90e
	cp 001h		;a911
	jr z,fase_fin_salida_pon		;a913
	ld (ix+000h),0ech		;a915   ; el ninja dentro
	ld (ix+010h),0ech		;a919
	ld de,04790h		;a91d
	cp 002h		;a920
	jr z,fase_fin_salida_pon		;a922
	ld de,0477eh		;a924
	cp 003h		;a927
	jr z,fase_fin_salida_pon		;a929
	ld a,002h		;a92b   ; acabado: 200 x 10 puntos
	call puntos_suma_cien		;a92d
	ld a,001h		;a930   ; la fase acabada
	ld (0e186h),a		;a932
	ret			;a935
fase_fin_salida_pon:
	inc a			;a936   ; el paso siguiente
	ld (0e1b0h),a		;a937
	call dibujo_mapa		;a93a   ; en el mapa
	call mapa_pantalla		;a93d
	call sprites_rota		;a940
	jr fase_fin_salida_paso		;a943

; ----------------------------------------------------------------------
; DATOS puerta_dibujos: La puerta del castillo, cuatro dibujos de 5 x 4
;   casillas: cerrada (0xA945), medio abierta (0xA95B), abierta (0xA971) y
;   otra (0xA987)
;   0xa945..0xa99d  (88 bytes)
DATA_puerta_dibujos:
	defb 005h,004h,08dh,08dh,010h,08dh,08dh,08dh,08dh,010h,08dh,08dh,08dh,084h,010h,084h	; a945  ................
	defb 08dh,08dh,08dh,010h,08dh,08dh,005h,004h,08dh,010h,010h,010h,08dh,08dh,010h,010h	; a955  ................
	defb 010h,08dh,084h,010h,010h,010h,084h,08dh,010h,010h,010h,08dh,005h,004h,010h,010h	; a965  ................
	defb 010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h	; a975  ................
	defb 010h,010h,005h,004h,08dh,08dh,08ch,08dh,08dh,08dh,08dh,08ch,08dh,08dh,08dh,084h	; a985  ................
	defb 08ch,084h,08dh,08dh,08dh,08ch,08dh,08dh	; a995  ........

; ======================================================================
; CODIGO 0xa99d..0xac4d  (688 bytes)
; ======================================================================


jefe:		; El tipo 9, el jefe de la fase 6 (cinco sprites, +0x10 a +0x40): al salir, en la Y 0x78 y la X 0xF2, con el dibujo y el color de la vuelta (0xAC y 9; 0xB8 y 5; 0xBC y 13); va de un lado a otro, de cuando en cuando suelta un tipo 10 (+0x50); si toca al ninja lo empuja 0x16 a un lado y, muy cerca, lo mata (0xE183 = 2), salvo si esta aturdido (+0xD, 0x80 cuadros temblando), que lo deja el ninja saltandole encima; con la vuelta x 2 + 5 tiros de shuriken: la musica 5, "IGA2" (0xAC4D) en la fila 12, en la tercera vuelta un dibujo mas (0xAD17), sale andando por la derecha y da 3.000 puntos (en pantalla): la fase acabada
	ld a,(iy+005h)		;a99d   ; en marcha?
	and a			;a9a0
	jr nz,jefe_paso		;a9a1
	inc (iy+005h)		;a9a3
	ld (iy+000h),078h		;a9a6   ; cinco sprites: la Y...
	ld (iy+010h),078h		;a9aa
	ld (iy+020h),078h		;a9ae
	ld (iy+030h),088h		;a9b2
	ld (iy+040h),088h		;a9b6
	ld (iy+001h),0f2h		;a9ba   ; ...la X...
	ld (iy+011h),0ech		;a9be
	ld (iy+021h),0fch		;a9c2
	ld (iy+031h),0ech		;a9c6
	ld (iy+041h),0fch		;a9ca
	ld (iy+014h),00fh		;a9ce   ; ...todos en pantalla
	ld (iy+024h),00fh		;a9d2
	ld (iy+034h),00fh		;a9d6
	ld (iy+044h),00fh		;a9da
	ld (iy+003h),00fh		;a9de
	ld a,(0e009h)		;a9e2   ; la vuelta: 0xAC y 9...
	ld b,0ach		;a9e5
	ld c,009h		;a9e7
	and a			;a9e9
	jr z,jefe_color		;a9ea
	ld b,0b8h		;a9ec   ; ...0xB8 y 5...
	ld c,005h		;a9ee
	cp 001h		;a9f0
	jr z,jefe_color		;a9f2
	ld b,0bch		;a9f4   ; ...0xBC y 13
	ld c,00dh		;a9f6
	ld (iy+003h),00fh		;a9f8
jefe_color:
	ld (iy+002h),b		;a9fc   ; el dibujo
	ld (iy+003h),00fh		;a9ff   ; color 15
	ld (iy+013h),c		;aa03   ; los otros cuatro, del color de la vuelta
	ld (iy+023h),c		;aa06
	ld (iy+033h),c		;aa09
	ld (iy+043h),c		;aa0c
	ld a,r		;aa0f   ; la espera, al azar
	and 03fh		;aa11   ; 0x10-0x4F
	add a,010h		;aa13
	ld (iy+007h),a		;aa15   ; la espera
	ld (iy+006h),000h		;aa18   ; a la izquierda
	ret			;aa1c
jefe_paso:
	cp 001h		;aa1d   ; 1: en marcha; si no, sale
	jp nz,jefe_sale		;aa1f
	dec (iy+007h)		;aa22   ; la espera
	jr nz,jefe_aturdido		;aa25
	ld a,r		;aa27   ; la siguiente, al azar...
	and 03fh		;aa29
	add a,030h		;aa2b
	ld (iy+007h),a		;aa2d
	and 001h		;aa30   ; ...y el lado
	ld (iy+006h),a		;aa32
	ld a,(iy+00dh)		;aa35   ; aturdido?
	and a			;aa38
	jr nz,jefe_tiro		;aa39
	ld a,(iy+000h)		;aa3b   ; si no, suelta un tipo 10 (+0x50)
	ld (iy+050h),a		;aa3e
	ld a,(iy+001h)		;aa41
	ld (iy+051h),a		;aa44
	ld (iy+054h),00ah		;aa47
	jr jefe_tiro		;aa4b
jefe_aturdido:
	ld a,(iy+00dh)		;aa4d   ; aturdido?
	and a			;aa50
	jr z,jefe_anda		;aa51
	inc (iy+00dh)		;aa53   ; la cuenta
	ld a,(iy+00dh)		;aa56
	cp 080h		;aa59   ; 0x80?
	jr c,jefe_tiembla		;aa5b
	ld (iy+00dh),000h		;aa5d
	jr jefe_anda		;aa61
jefe_tiembla:
	ld a,(iy+00eh)		;aa63   ; un lado...
	cpl			;aa66
	ld (iy+00eh),a		;aa67
	and a			;aa6a
	jr nz,jefe_tiembla_izq		;aa6b
	ld a,(iy+011h)		;aa6d   ; ...2 a la derecha...
	add a,002h		;aa70
	ld (iy+011h),a		;aa72
	jr jefe_tiro		;aa75
jefe_tiembla_izq:
	ld a,(iy+011h)		;aa77   ; ...o 2 a la izquierda
	sub 002h		;aa7a
	ld (iy+011h),a		;aa7c
	jr jefe_tiro		;aa7f
jefe_anda:
	ld a,(iy+006h)		;aa81   ; a la izquierda?
	and a			;aa84
	jr nz,jefe_anda_der		;aa85
	ld a,(iy+011h)		;aa87   ; en el borde?
	cp 004h		;aa8a
	jr c,jefe_anda_der_paso		;aa8c
	dec (iy+011h)		;aa8e   ; un punto a la izquierda
	jr jefe_tiro		;aa91
jefe_anda_der:
	ld a,(iy+011h)		;aa93   ; en el borde?
	cp 0ech		;aa96
	jr c,jefe_anda_der_paso		;aa98
	ld (iy+006h),000h		;aa9a   ; da la vuelta
	jr jefe_aturdido		;aa9e
jefe_anda_der_paso:
	inc (iy+011h)		;aaa0
jefe_tiro:
	ld bc,008f8h		;aaa3   ; el shuriken del ninja: cerca en Y?
	call cerca_y2		;aaa6
	jp nc,jefe_toca		;aaa9
	ld bc,008f8h		;aaac   ; ...y en X?
	call cerca_x2		;aaaf
	jp nc,jefe_toca		;aab2
	inc (iy+008h)		;aab5   ; un tiro mas
	ld a,001h		;aab8   ; el efecto A 1
	call efecto_a_pide		;aaba
	call shuriken_fuera		;aabd   ; el shuriken fuera
	ld a,(0e009h)		;aac0   ; la vuelta x 2 + 5
	rlca			;aac3
	add a,005h		;aac4
	ld b,a			;aac6
	ld a,(iy+008h)		;aac7   ; tantos?
	cp b			;aaca
	jp c,jefe_toca		;aacb
	ld a,(iy+011h)		;aace   ; vencido: dos sprites, dibujos 0xA0 y 0xB4
	ld (iy+001h),a		;aad1
	ld (iy+010h),088h		;aad4
	ld (iy+000h),088h		;aad8
	ld (iy+020h),0ech		;aadc
	ld (iy+030h),0ech		;aae0
	ld (iy+040h),0ech		;aae4
	ld (iy+002h),0a0h		;aae8
	ld (iy+012h),0b4h		;aaec
	ld (iy+003h),008h		;aaf0
	ld (iy+013h),00fh		;aaf4
	ld a,005h		;aaf8   ; la musica 5
	call musica_pide		;aafa
	ld hl,0ac4dh		;aafd   ; "IGA2" en la fila 12, columna 14
	ld de,019eeh		;ab00
	ld bc,00004h		;ab03
	call 0005ch		;ab06
	ld (iy+005h),002h		;ab09   ; el paso 2
	ld a,(0e009h)		;ab0d   ; la tercera vuelta?
	cp 002h		;ab10
	jr nz,jefe_sale		;ab12
	ld hl,0ad17h		;ab14   ; un dibujo de dos filas de 8 (0xAD17) en la fila 6, columna 7...
	ld de,018c7h		;ab17
	ld bc,00008h		;ab1a
	call 0005ch		;ab1d
	ex de,hl			;ab20
	ld de,018e7h		;ab21
	ld bc,00008h		;ab24
	call 0005ch		;ab27
	ld hl,0ad17h		;ab2a   ; ...y otra vez en la columna 17
	ld de,018d1h		;ab2d
	ld bc,00008h		;ab30
	call 0005ch		;ab33
	ex de,hl			;ab36
	ld de,018f1h		;ab37
	ld bc,00008h		;ab3a
	call 0005ch		;ab3d
jefe_sale:
	inc (iy+009h)		;ab40   ; cada 5 cuadros...
	ld a,(iy+009h)		;ab43
	cp 005h		;ab46
	jr c,jefe_sale_dibujo		;ab48
	ld (iy+009h),000h		;ab4a
	ld a,005h		;ab4e   ; ...la musica 5...
	call musica_pide		;ab50
	inc (iy+001h)		;ab53   ; ...un punto a la derecha
	inc (iy+011h)		;ab56
	ld a,(iy+001h)		;ab59   ; fuera?
	cp 0fah		;ab5c
	jr c,jefe_sale		;ab5e
	jr jefe_fuera		;ab60
jefe_sale_dibujo:
	ld a,(0e012h)		;ab62   ; cada 8 cuadros, 0xA0 o 0xB0
	and 008h		;ab65
	rlca			;ab67
	add a,0a0h		;ab68
	ld (iy+002h),a		;ab6a
	ret			;ab6d
jefe_fuera:
	xor a			;ab6e   ; la musica callada
	ld (0e2beh),a		;ab6f
	ld a,003h		;ab72   ; 300 x 10 puntos
	call puntos_suma_cien		;ab74
	ld a,001h		;ab77   ; la fase acabada
	ld (0e186h),a		;ab79
	ld (iy+004h),000h		;ab7c
	ld (iy+015h),000h		;ab80
	ret			;ab84
jefe_toca:		; El jefe y el ninja: cerca en Y y en X, el ninja va 0x16 a un lado; si saltaba hacia el, el jefe aturdido; si no y muy cerca, el ninja muere
	ld a,(iy+010h)		;ab85   ; cerca en Y?
	ld b,(ix+000h)		;ab88
	sub b			;ab8b
	cp 00ch		;ab8c
	jr c,L_AB95		;ab8e
	cp 0ech		;ab90
	jp c,jefe_dibujo		;ab92
L_AB95:
	ld a,(ix+001h)		;ab95   ; de que lado?
	add a,008h		;ab98   ; el centro del ninja
	ld b,a			;ab9a
	ld a,(iy+011h)		;ab9b   ; el del jefe
	add a,010h		;ab9e
	cp b			;aba0
	jr c,jefe_toca_der		;aba1   ; el ninja a la derecha
	sub b			;aba3
	cp 006h		;aba4   ; muy cerca?
	jr c,jefe_toca_izq		;aba6
	cp 015h		;aba8   ; lejos?
	jr nc,jefe_dibujo		;abaa
jefe_empuja_izq:
	ld a,(ix+001h)		;abac   ; 0x16 a la izquierda (6 como poco)
	sub 016h		;abaf
	cp 006h		;abb1
	jr c,jefe_empuja_izq_borde		;abb3
	cp 0efh		;abb5
	jr c,jefe_empuja_izq_pon		;abb7
jefe_empuja_izq_borde:
	ld a,006h		;abb9
jefe_empuja_izq_pon:
	ld (ix+001h),a		;abbb
	ld (ix+011h),a		;abbe
	ld a,(ix+009h)		;abc1   ; saltando a la derecha?
	cp 002h		;abc4
	ret nz			;abc6
	ld (iy+00dh),001h		;abc7   ; aturdido
	jr jefe_dibujo		;abcb
jefe_toca_izq:
	ld a,(iy+00dh)		;abcd   ; aturdido?
	and a			;abd0
	jr nz,jefe_empuja_izq		;abd1
	ld a,002h		;abd3   ; si no, el ninja muere
	ld (0e183h),a		;abd5
	jr jefe_dibujo		;abd8
jefe_toca_der:
	sub b			;abda
	cp 0fah		;abdb
	jr nc,jefe_toca_der2		;abdd
	cp 0ech		;abdf
	jr c,jefe_dibujo		;abe1
jefe_empuja_der:
	ld a,(ix+001h)		;abe3   ; 0x16 a la derecha (0xF0 como mucho)
	add a,016h		;abe6
	cp 010h		;abe8
	jr c,jefe_empuja_der_borde		;abea
	cp 0f0h		;abec
	jr c,jefe_empuja_der_pon		;abee
jefe_empuja_der_borde:
	ld a,0f0h		;abf0
jefe_empuja_der_pon:
	ld (ix+001h),a		;abf2   ; la X del ninja
	ld (ix+011h),a		;abf5
	ld a,(ix+009h)		;abf8   ; saltando a la izquierda?
	cp 003h		;abfb
	ret nz			;abfd
	ld (iy+00dh),001h		;abfe   ; el jefe aturdido
	jr jefe_dibujo		;ac02
jefe_toca_der2:
	ld a,(iy+00dh)		;ac04
	and a			;ac07
	jr nz,jefe_empuja_der		;ac08
	ld a,002h		;ac0a
	ld (0e183h),a		;ac0c
jefe_dibujo:
	ld a,(0e012h)		;ac0f   ; cada 8 cuadros, sus dibujos 0xF0-0xFC o 0xE0-0xEC
	and 008h		;ac12
	and a			;ac14
	jr nz,jefe_dibujo2		;ac15
	ld (iy+012h),0f0h		;ac17
	ld (iy+022h),0f4h		;ac1b
	ld (iy+032h),0f8h		;ac1f
	ld (iy+042h),0fch		;ac23
	jr jefe_sitios		;ac27
jefe_dibujo2:
	ld (iy+012h),0e0h		;ac29
	ld (iy+022h),0e4h		;ac2d
	ld (iy+032h),0e8h		;ac31
	ld (iy+042h),0ech		;ac35
jefe_sitios:
	ld a,(iy+011h)		;ac39   ; los otros sprites, a su lado
	ld (iy+031h),a		;ac3c
	add a,010h		;ac3f
	ld (iy+021h),a		;ac41
	ld (iy+041h),a		;ac44
	sub 00ch		;ac47
	ld (iy+001h),a		;ac49
	ret			;ac4c

; ----------------------------------------------------------------------
; DATOS iga2: "IGA2" en letras (0x19 0x17 0x11 0x02): lo que escribe el jefe
;   al ser vencido, y las teclas del truco de continuar en el titulo
;   0xac4d..0xac51  (4 bytes)
DATA_iga2:
	defb 019h,017h,011h,002h	; ac4d

; ======================================================================
; CODIGO 0xac51..0xad17  (198 bytes)
; ======================================================================


nada:		; Los tipos de enemigo que no hacen nada
	ret			;ac51
enemigo_libre_der:		; Como libre_der, para el enemigo IY: C si la casilla de su derecha deja pasar
	call enemigo_casilla_der		;ac52
enemigo_libre_mira:
	cp 036h		;ac55
	jr c,enemigo_libre_si		;ac57
	cp 060h		;ac59
	jr c,enemigo_libre_no		;ac5b
enemigo_libre_si:
	scf			;ac5d
	ret			;ac5e
enemigo_libre_no:
	xor a			;ac5f
	ret			;ac60
enemigo_casilla_izq:		; La casilla del mapa a la izquierda del enemigo IY (X - 4)
	ld a,(iy+001h)		;ac61
	sub 004h		;ac64
	jr enemigo_casilla_xy		;ac66
enemigo_casilla_der:		; La casilla del mapa a la derecha del enemigo IY (X + 12)
	ld a,(iy+001h)		;ac68
	add a,00ch		;ac6b
enemigo_casilla_xy:
	srl a		;ac6d   ; / 8: la columna
	srl a		;ac6f
	srl a		;ac71
	ld b,a			;ac73
	ld a,(0e190h)		;ac74   ; + la del mapa
	add a,b			;ac77
	ld hl,0ea00h		;ac78   ; el mapa
	add a,l			;ac7b
	jr nc,enemigo_casilla_fila		;ac7c
	inc h			;ac7e
enemigo_casilla_fila:
	ld l,a			;ac7f
	ld a,(iy+000h)		;ac80   ; la Y...
	srl a		;ac83   ; ...entre 8...
	srl a		;ac85
	srl a		;ac87
	dec a			;ac89   ; ...menos 1
	ld b,a			;ac8a
	and a			;ac8b
	jr z,enemigo_casilla_lee		;ac8c
	ld de,00060h		;ac8e   ; filas de 0x60
enemigo_casilla_suma:
	add hl,de			;ac91
	djnz enemigo_casilla_suma		;ac92
enemigo_casilla_lee:
	ld a,(hl)			;ac94   ; la casilla
	ret			;ac95
enemigo_libre_izq:		; C si la casilla de su izquierda deja pasar
	call enemigo_casilla_izq		;ac96
	ld a,(hl)			;ac99
	jp enemigo_libre_mira		;ac9a
enemigo_suelo:		; Sin saltar: si no hay suelo debajo, cae (+0xF)
	ld a,(iy+00bh)		;ac9d   ; saltando?
	and a			;aca0
	ret nz			;aca1
	call enemigo_suelo_mira		;aca2   ; suelo?
	ret nc			;aca5
	ld (iy+00fh),001h		;aca6   ; no: cae
	ret			;acaa
enemigo_cae:		; Cayendo (+0xF): 2 puntos por cuadro hasta el suelo
	ld a,(iy+00fh)		;acab
	and a			;acae
	ret z			;acaf
	ld b,002h		;acb0
enemigo_cae_punto:
	push bc			;acb2   ; uno
	call enemigo_suelo_mira		;acb3   ; suelo?
	jr nc,enemigo_cae_para		;acb6   ; si: para
	inc (iy+000h)		;acb8   ; un punto abajo
	inc (iy+010h)		;acbb   ; el segundo sprite
	pop bc			;acbe
	djnz enemigo_cae_punto		;acbf   ; dos
	ret			;acc1
enemigo_cae_para:
	pop bc			;acc2
	ld (iy+00fh),000h		;acc3   ; de pie
	ret			;acc7
enemigo_suelo_mira:		; La casilla debajo del enemigo: NC si sostiene; la 0x3D (la que mata) se lo lleva (+5 = 4, fuera)
	ld hl,0ea00h		;acc8   ; el mapa
	ld a,(iy+001h)		;accb   ; la X + 8...
	add a,008h		;acce
	srl a		;acd0   ; ...entre 8
	srl a		;acd2
	srl a		;acd4
	ld b,a			;acd6
	ld a,(0e190h)		;acd7   ; + la columna del mapa
	add a,b			;acda
	add a,l			;acdb
	jr nc,enemigo_suelo_columna		;acdc
	inc h			;acde
enemigo_suelo_columna:
	ld l,a			;acdf
	ld de,00060h		;ace0   ; filas de 0x60
	ld a,(iy+000h)		;ace3   ; la Y...
	srl a		;ace6   ; ...entre 8
	srl a		;ace8
	srl a		;acea
	ld b,a			;acec
enemigo_suelo_fila:
	add hl,de			;aced   ; una fila mas
	djnz enemigo_suelo_fila		;acee
	ld a,(hl)			;acf0   ; la casilla de debajo
	cp 031h		;acf1   ; lo alto de una escalera?
	jr z,enemigo_suelo_si		;acf3
	cp 032h		;acf5   ; 0x32?
	jr z,enemigo_suelo_si		;acf7
	cp 034h		;acf9   ; 0x34?
	jr z,enemigo_suelo_si		;acfb
	cp 035h		;acfd   ; 0x35?
	jr z,enemigo_suelo_si		;acff
	cp 036h		;ad01   ; libre?
	jr c,enemigo_suelo_no		;ad03
	cp 03dh		;ad05   ; 0x3D?
	jr nz,enemigo_suelo_pared		;ad07
	ld (iy+005h),004h		;ad09   ; fuera
	jr enemigo_suelo_si		;ad0d
enemigo_suelo_pared:
	cp 060h		;ad0f   ; desde 0x60: no
	jr nc,enemigo_suelo_no		;ad11
enemigo_suelo_si:
	xor a			;ad13   ; NC: sostiene
	ret			;ad14
enemigo_suelo_no:
	scf			;ad15   ; C: no sostiene
	ret			;ad16

; ----------------------------------------------------------------------
; DATOS dibujo_final: El dibujo que pone el jefe vencido en la tercera vuelta
;   (0xAD17: dos filas de 8 casillas) y, detras, 0x2D9 bytes de dibujos de
;   casillas y 0xFF que no lee nadie
;   0xad17..0xb000  (745 bytes)
DATA_dibujo_final:
	defb 0a8h,0aah,0ach,0aeh,0b0h,0b2h,0b4h,0b6h,0a9h,0abh,0adh,0afh,0b1h,0b3h,0b5h,0b7h	; ad17  ................
	defb 0fch,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,07fh,07fh,07fh,07fh,07fh,07fh,07fh	; ad27  ................
	defb 07fh,0ffh,01fh,0f8h,0c7h,0ffh,0ffh,0ffh,0ffh,07fh,03fh,01fh,00fh,007h,003h,001h	; ad37  ..........?.....
	defb 0ffh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,0feh,0fch,0f8h,0f0h,0e0h,0c0h,080h	; ad47  .????????.......
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; ad57  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; ad67  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,07fh,07fh,03fh,03fh,01fh,01fh,00fh	; ad77  ...........??...
	defb 00fh,0e7h,0e7h,0f3h,0f3h,0f9h,0f9h,0fch,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; ad87  ................
	defb 0ffh,0feh,0feh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,007h,007h,003h,003h,0feh,0fch,0f8h	; ad97  ................
	defb 0f1h,0feh,0feh,0ffh,03fh,03fh,07fh,0ffh,0ffh,07fh,07fh,03fh,03fh,09fh,0ffh,0ffh	; ada7  ....??.....??...
	defb 0ffh,018h,03ch,07eh,03fh,035h,03fh,07fh,01ch,018h,07ch,0feh,0fch,0ach,0feh,07ch	; adb7  ..<~?5?...|....|
	defb 000h,07eh,081h,0bdh,0a1h,0a1h,0bdh,081h,07eh,07fh,080h,080h,080h,080h,080h,080h	; adc7  .~......~.......
	defb 07fh,003h,004h,008h,008h,00fh,008h,008h,008h,0c0h,020h,010h,010h,0f0h,010h,010h	; add7  .......... .....
	defb 010h,07fh,080h,080h,07eh,001h,001h,001h,0feh,010h,010h,010h,010h,010h,010h,010h	; ade7  ....~...........
	defb 010h,07eh,081h,081h,081h,081h,081h,081h,07eh,000h,000h,004h,003h,003h,003h,003h	; adf7  .~......~.......
	defb 002h,000h,000h,000h,000h,080h,011h,00fh,003h,000h,000h,000h,000h,038h,0fch,0cch	; ae07  .............8..
	defb 0beh,000h,003h,001h,007h,003h,003h,006h,004h,006h,006h,004h,00ah,012h,022h,002h	; ae17  ..............".
	defb 006h,001h,007h,03dh,001h,001h,007h,03dh,003h,0ffh,0d8h,090h,0f0h,0fch,098h,080h	; ae27  ...=...=........
	defb 080h,000h,080h,0e0h,03bh,034h,062h,0e3h,042h,006h,004h,00ch,00ch,004h,000h,000h	; ae37  ....;4b.B.......
	defb 000h,003h,003h,003h,002h,006h,004h,004h,008h,000h,000h,000h,000h,000h,000h,000h	; ae47  ................
	defb 000h,000h,000h,070h,0f8h,018h,020h,0f0h,000h,018h,020h,000h,000h,000h,000h,000h	; ae57  ...p.. ... .....
	defb 000h,004h,07fh,081h,0b9h,0c1h,09dh,0e3h,083h,000h,080h,080h,000h,000h,000h,000h	; ae67  ................
	defb 000h,000h,000h,003h,000h,001h,003h,004h,008h,09fh,0f3h,083h,0c7h,080h,000h,000h	; ae77  ................
	defb 000h,000h,000h,000h,000h,0c0h,060h,030h,010h,000h,000h,000h,000h,000h,003h,000h	; ae87  ......`0........
	defb 001h,000h,000h,000h,006h,03dh,0c3h,023h,0a3h,000h,000h,000h,000h,080h,000h,000h	; ae97  .....=.#........
	defb 000h,000h,000h,000h,001h,003h,000h,000h,002h,076h,05eh,0c6h,03ch,018h,010h,007h	; aea7  .........v^.<...
	defb 03ch,000h,000h,000h,000h,000h,038h,00ch,046h,011h,011h,030h,010h,018h,000h,000h	; aeb7  <.....8.F..0....
	defb 000h,008h,000h,0c0h,038h,01fh,001h,000h,000h,020h,020h,030h,03ch,0f8h,0c0h,000h	; aec7  ....8....  0<...
	defb 000h,000h,000h,000h,000h,00ch,002h,003h,001h,000h,000h,010h,00eh,007h,003h,003h	; aed7  ................
	defb 003h,000h,000h,000h,000h,000h,000h,000h,0f0h,000h,040h,038h,00ch,004h,000h,000h	; aee7  ..........@8....
	defb 001h,003h,03fh,003h,003h,003h,00fh,074h,086h,0e0h,000h,000h,000h,0fch,00eh,000h	; aef7  ..?....t........
	defb 040h,004h,004h,00ch,058h,030h,010h,000h,000h,004h,00ch,018h,077h,03ch,030h,000h	; af07  @...X0......w<0.
	defb 000h,060h,030h,078h,09ch,00ch,004h,000h,000h,000h,000h,000h,008h,006h,003h,002h	; af17  .`0x............
	defb 002h,000h,000h,000h,000h,010h,00ch,006h,007h,000h,000h,000h,000h,000h,000h,000h	; af27  ................
	defb 000h,003h,00eh,042h,032h,013h,012h,012h,002h,083h,063h,043h,043h,0c3h,0c2h,087h	; af37  ...B2.....cCC...
	defb 03ch,000h,01ch,0f8h,000h,000h,010h,0f8h,00ch,002h,002h,002h,006h,006h,002h,000h	; af47  <...............
	defb 000h,060h,030h,030h,010h,01fh,010h,000h,000h,018h,030h,030h,0e0h,0f0h,030h,000h	; af57  .`00......00..0.
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; af67  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,03fh,07fh,0ffh,0f0h,0e0h	; af77  ...........?....
	defb 0e0h,0e0h,0e0h,0e0h,0f0h,0ffh,07fh,03fh,000h,000h,000h,0e0h,0f0h,0f8h,078h,000h	; af87  .......?......x.
	defb 000h,000h,000h,039h,079h,0f9h,0f3h,0e3h,000h,000h,000h,03eh,03eh,07fh,077h,077h	; af97  ...9y......>>.ww
	defb 0e3h,0e3h,0e3h,0ffh,0ffh,0c1h,080h,080h,000h,000h,000h,003h,007h,00fh,00fh,00fh	; afa7  ................
	defb 08fh,087h,083h,0c0h,0cfh,0cfh,0e7h,0e3h,000h,000h,000h,0feh,0ffh,0ffh,007h,000h	; afb7  ................
	defb 0feh,0ffh,0ffh,007h,007h,0ffh,0ffh,0feh,000h,000h,000h,038h,039h,0bbh,0bbh,03bh	; afc7  ...........89..;
	defb 03bh,03bh,0bbh,0bbh,0bbh,0bbh,039h,038h,000h,000h,000h,0ffh,0ffh,0ffh,0c1h,080h	; afd7  ;;....98........
	defb 080h,080h,080h,080h,0c1h,0ffh,0ffh,0ffh,000h,000h,000h,080h,0c0h,0e0h,0e0h,0e0h	; afe7  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0c0h,080h,000h	; aff7  .........

; ----------------------------------------------------------------------
; DATOS sonido_tablas: Las tablas del sonido: 6 musicas (0xB000, 6 bytes: las
;   piezas de A, B y C; la 0 en silencio), 8 efectos del canal A (0xB024, 2
;   bytes) y 8 de B y C (0xB034, 4 bytes)
;   0xb000..0xb054  (84 bytes)
DATA_sonido_tablas:
	defb 092h,0b4h,092h,0b4h,092h,0b4h,096h,0b4h,0fdh,0b4h,052h,0b5h,0c5h,0b5h,01dh,0b6h	; b000  ..........R.....
	defb 07bh,0b6h,0dfh,0b6h,08bh,0b7h,01ch,0b8h,0a1h,0b8h,0a5h,0b8h,0a9h,0b8h,086h,0beh	; b010  {...............
	defb 0f9h,0beh,05dh,0bfh,032h,0b4h,036h,0b4h,044h,0b4h,04ah,0b4h,04eh,0b4h,068h,0b4h	; b020  ..].2.6.D.J.N.h.
	defb 082h,0b4h,08ah,0b4h,092h,0b4h,092h,0b4h,060h,0beh,06ah,0beh,0afh,0b8h,0f8h,0b8h	; b030  ........`.j.....
	defb 007h,0bch,031h,0bdh,01bh,0bbh,082h,0bbh,048h,0b9h,051h,0bah,058h,0beh,05ch,0beh	; b040  ..1.....H.Q.X.\.
	defb 071h,0beh,074h,0beh	; b050

; ======================================================================
; CODIGO 0xb054..0xb329  (725 bytes)
; ======================================================================


efecto_a_pide:		; Pide el efecto A del canal A (0xE2C0), solo en partida, con la misma regla: se queda el de numero mas bajo
	ld b,a			;b054   ; el numero
	ld a,(0e000h)		;b055   ; en partida?
	and a			;b058
	ret z			;b059
sonido_a_pon:
	ld a,b			;b05a
	ld hl,0e2c0h		;b05b   ; el efecto del canal A pedido
	jr pide_va		;b05e
efecto_pide:		; Pide el efecto A (0xE2C2), solo en partida: si ya hay uno, se queda el de numero mas bajo
	ld b,a			;b060   ; el numero
	ld a,(0e000h)		;b061   ; en partida?
	and a			;b064
	ret z			;b065
	ld a,b			;b066
	ld hl,0e2c2h		;b067   ; el efecto pedido
pide_va:
	ld b,a			;b06a
	ld a,(hl)			;b06b   ; ya hay uno?
	and a			;b06c
	jr z,pide_pon		;b06d
	cp b			;b06f   ; el de antes es menor: se queda
	ret c			;b070
pide_pon:
	ld (hl),b			;b071   ; el nuevo
	ret			;b072
musica_pide:		; Pide la musica A (0xE2BE), con la misma regla
	ld hl,0e2beh		;b073   ; la musica pedida
	jr pide_va		;b076
sonido:		; El sonido de cada cuadro (desde la interrupcion): una musica nueva o un efecto nuevo empiezan; los tres canales (0xE280, 0xE292, 0xE2A4, 18 bytes) siguen
	ld hl,0e2bdh		;b078   ; una musica sonando?
	xor a			;b07b
	cp (hl)			;b07c   ; sonando?
	jr nz,sonido_musica_sigue		;b07d
	inc hl			;b07f   ; una pedida?
	cp (hl)			;b080
	jp nz,musica_empieza		;b081   ; empieza
	inc hl			;b084   ; el efecto A sonando?
	cp (hl)			;b085
	jr nz,sonido_a_sigue		;b086
	inc hl			;b088
	cp (hl)			;b089
	jp nz,sonido_a_empieza		;b08a
sonido_bc_mira2:
	xor a			;b08d
	inc hl			;b08e   ; el de B y C sonando?
	cp (hl)			;b08f
	jr nz,sonido_bc_sigue		;b090
	inc hl			;b092
	cp (hl)			;b093
	jp nz,sonido_bc_empieza		;b094
sonido_musica_sigue:		; Sonando una musica: si la pedida gana, empieza; si no, los canales
	call pedido_gana		;b097
	jp c,musica_empieza		;b09a
	jr sonido_canal_a		;b09d
sonido_a_sigue:		; Sonando un efecto de A: si el pedido gana, empieza
	call pedido_gana		;b09f
	jp c,sonido_a_empieza		;b0a2
	jr sonido_bc_mira2		;b0a5
sonido_bc_sigue:		; Sonando uno de B y C: si el pedido gana, empieza
	call pedido_gana		;b0a7
	jp c,sonido_bc_empieza		;b0aa
sonido_canal_a:		; El canal A: su bloque a 0xE2C3, un paso y de vuelta
	ld a,(0e2bdh)		;b0ad   ; la musica?
	and a			;b0b0
	jr nz,sonido_canal_a_va		;b0b1
	ld a,(0e2bfh)		;b0b3   ; o un efecto que use el canal A?
	and a			;b0b6
	jr z,sonido_canal_b		;b0b7
sonido_canal_a_va:
	ld hl,0e280h		;b0b9   ; el canal A
	call canal_a_trabajo		;b0bc   ; al canal de trabajo
	ld bc,00008h		;b0bf   ; los registros 0 y 1, volumen el 8
	xor a			;b0c2
	call canal_paso_pon		;b0c3
	push af			;b0c6
	ld de,0e280h		;b0c7
	call canal_de_trabajo		;b0ca
	pop af			;b0cd
	and a			;b0ce   ; 0: sigue
	jr z,sonido_canal_b		;b0cf
	cp 001h		;b0d1
	jp z,musica_acaba		;b0d3
	cp 002h		;b0d6
	jp z,sonido_a_acaba		;b0d8
sonido_canal_b:		; Los canales B y C: con la musica o el efecto de B y C, un paso de cada uno (los registros 2-3 y 9, 4-5 y 10); al acabar, 0xB3ED
	ld a,(0e2bdh)		;b0db   ; la musica?
	and a			;b0de
	jr nz,sonido_canal_b_va		;b0df
	ld a,(0e2c1h)		;b0e1   ; o el efecto de B y C?
	and a			;b0e4
	ret z			;b0e5
sonido_canal_b_va:
	ld hl,0e292h		;b0e6   ; el canal B
	call canal_a_trabajo		;b0e9
	ld bc,00209h		;b0ec   ; los registros 2 y 3, volumen el 9
	ld a,(0e088h)		;b0ef   ; sus bits del registro 7
	rrca			;b0f2
	ld (0e088h),a		;b0f3
	ld a,001h		;b0f6   ; el canal 1
	call canal_paso_pon		;b0f8   ; un paso
	push af			;b0fb
	ld de,0e292h		;b0fc   ; y de vuelta
	call canal_de_trabajo		;b0ff
	pop af			;b102
	cp 003h		;b103   ; 3: sigue
	jr z,sonido_canal_c		;b105
	ld b,a			;b107
	ld a,(0e088h)		;b108   ; los bits de vuelta
	rlca			;b10b
	ld (0e088h),a		;b10c
	ld a,b			;b10f
	and a			;b110
	jp nz,sonido_bc_acaba		;b111   ; acabado
sonido_canal_c:		; El canal C (los registros 4 y 5, volumen el 10); despues el barrido del ruido
	ld hl,0e2a4h		;b114   ; el canal C
	call canal_a_trabajo		;b117
	ld bc,0040ah		;b11a   ; los registros 4 y 5, volumen el 10
	ld a,(0e088h)		;b11d   ; sus bits del registro 7
	rrca			;b120
	rrca			;b121
	ld (0e088h),a		;b122
	ld a,002h		;b125   ; el canal 2
	call canal_paso_pon		;b127   ; un paso
	push af			;b12a
	ld de,0e2a4h		;b12b   ; y de vuelta
	call canal_de_trabajo		;b12e
	pop af			;b131
	cp 003h		;b132   ; 3: sigue
	jp z,ruido_barrido		;b134
	ld b,a			;b137   ; los bits de vuelta
	ld a,(0e088h)		;b138
	rlca			;b13b
	rlca			;b13c
	ld (0e088h),a		;b13d
	ld a,b			;b140   ; acabado?
	and a			;b141
	jp nz,sonido_bc_acaba		;b142
	jp ruido_barrido		;b145   ; el barrido del ruido
canal_a_trabajo:		; Copia el bloque del canal (HL, 18 bytes) a 0xE2C3
	ld de,0e2c3h		;b148   ; al canal de trabajo
copia18:
	ld bc,00012h		;b14b   ; 18 bytes
	ldir		;b14e
	ret			;b150
canal_de_trabajo:		; Y de vuelta a DE
	ld hl,0e2c3h		;b151
	jr copia18		;b154
canal_paso:		; Un paso del canal de trabajo: si la nota sigue, nada; si no, el byte siguiente de la pieza: una nota (menos de 0xF0) o una orden
	ld hl,0e2cdh		;b156   ; la nota sigue?
	ld a,(hl)			;b159
	and a			;b15a
	jr z,canal_byte		;b15b
	call canal_cuenta		;b15d   ; su cuenta
	and a			;b160
	ret z			;b161
canal_byte:		; El byte siguiente de la pieza (0xE2C3): menos de 0xF0, una nota (duracion y volumen, el tono) y 3; si no, una orden
	ld iy,0e2cdh		;b162
	ld hl,(0e2c3h)		;b166
	ld a,(hl)			;b169   ; el byte
	cp 0f0h		;b16a   ; 0xF0 o mas: una orden
	jr nc,L_B193		;b16c
	call nota_pon		;b16e
	call nota_tono		;b171
	ld (0e2c3h),hl		;b174   ; apuntado
	ld a,(0e088h)		;b177   ; el canal con tono, sin ruido
	res 0,a		;b17a
	set 3,a		;b17c
canal_mezcla:
	ld c,a			;b17e
	ld a,(0e2d5h)		;b17f   ; corrido al canal
	and a			;b182
	ld b,a			;b183
	ld a,c			;b184
	jr z,canal_mezcla_pon		;b185
canal_mezcla_corre:
	rlca			;b187
	djnz canal_mezcla_corre		;b188
canal_mezcla_pon:
	ld (0e088h),a		;b18a   ; el registro 7
	call psg_mezcla		;b18d
	ld a,003h		;b190
	ret			;b192
L_B193:
	jp z,canal_ruido		;b193
	cp 0ffh		;b196   ; 0xFF: el final
	jr nz,canal_orden_f7		;b198
	ld a,001h		;b19a   ; 1
	ret			;b19c
canal_orden_f7:
	cp 0f7h		;b19d   ; 0xF7: callar
	jr nz,canal_orden_fe		;b19f
	ld a,002h		;b1a1   ; 2
	ret			;b1a3
canal_orden_fe:
	cp 0feh		;b1a4   ; 0xFE: al principio
	jr nz,canal_orden_fd		;b1a6
	ld hl,(0e2c5h)		;b1a8   ; la pieza otra vez desde su principio
	jr canal_orden_sigue		;b1ab
canal_orden_fd:		; 0xFD n: la marca 1 y cuantas veces
	cp 0fdh		;b1ad   ; 0xFD n: el primer bucle, n veces
	jr nz,canal_orden_fc		;b1af
	inc hl			;b1b1   ; cuantas veces...
	ld a,(hl)			;b1b2
	ld (iy+005h),a		;b1b3   ; ...en +5
	inc hl			;b1b6
	ld (0e2c7h),hl		;b1b7   ; la marca 1
	jr canal_orden_sigue		;b1ba
canal_orden_fc:		; 0xFC: vuelve a la marca 1 si quedan
	cp 0fch		;b1bc   ; 0xFC: el final del primer bucle
	jr nz,canal_orden_fb		;b1be
	dec (iy+005h)		;b1c0   ; una vez menos
	jr nz,canal_orden_fc_vuelve		;b1c3
	inc hl			;b1c5   ; ya: sigue
	jr canal_orden_sigue		;b1c6
canal_orden_fc_vuelve:
	ld hl,(0e2c7h)		;b1c8   ; a la marca 1
	jr canal_orden_sigue		;b1cb
canal_orden_fb:		; 0xFB n: la marca 2
	cp 0fbh		;b1cd   ; 0xFB n: el segundo bucle
	jr nz,canal_orden_fa		;b1cf
	inc hl			;b1d1   ; cuantas veces...
	ld a,(hl)			;b1d2
	ld (iy+006h),a		;b1d3   ; ...en +6
	inc hl			;b1d6
	ld (0e2c9h),hl		;b1d7   ; la marca 2
canal_orden_sigue:		; Sigue leyendo
	ld (0e2c3h),hl		;b1da   ; por donde va
	jr canal_byte		;b1dd
canal_orden_fa:		; 0xFA: vuelve a la marca 2
	cp 0fah		;b1df   ; 0xFA: su final
	jr nz,canal_orden_f9		;b1e1
	dec (iy+006h)		;b1e3   ; una vez menos
	jr nz,canal_orden_fa_vuelve		;b1e6
	inc hl			;b1e8   ; ya: sigue
	jr canal_orden_sigue		;b1e9
canal_orden_fa_vuelve:
	ld hl,(0e2c9h)		;b1eb   ; a la marca 2
	jr canal_orden_sigue		;b1ee
canal_orden_f9:		; 0xF9 n: la marca 3
	cp 0f9h		;b1f0   ; 0xF9 n: el tercer bucle
	jr nz,canal_orden_f8		;b1f2
	inc hl			;b1f4   ; cuantas veces...
	ld a,(hl)			;b1f5
	ld (iy+007h),a		;b1f6   ; ...en +7
	inc hl			;b1f9
	ld (0e2cbh),hl		;b1fa   ; la marca 3
	jr canal_orden_sigue		;b1fd
canal_orden_f8:		; 0xF8 (o mas): vuelve a la marca 3
	dec (iy+007h)		;b1ff   ; una vez menos
	jr nz,canal_orden_f8_vuelve		;b202
	inc hl			;b204   ; ya: sigue
	jr canal_orden_sigue		;b205
canal_orden_f8_vuelve:
	ld hl,(0e2cbh)		;b207   ; a la marca 3
	jr canal_orden_sigue		;b20a
canal_ruido:		; 0xF0: una nota de ruido (el periodo y su barrido) y su duracion; el canal, a ruido en el registro 7
	call ruido_pon		;b20c   ; el ruido
	inc hl			;b20f
	call nota_pon		;b210
	inc hl			;b213
	ld (0e2c3h),hl		;b214
	ld a,(0e088h)		;b217
	res 3,a		;b21a
	set 0,a		;b21c
	jp canal_mezcla		;b21e
ruido_barrido:		; El barrido del ruido: cada tantos cuadros, el periodo + el paso, unas cuantas veces
	ld a,(0e2b6h)		;b221   ; hay ruido?
	and a			;b224
	ret z			;b225
	ld a,(0e2b7h)		;b226   ; con barrido?
	and a			;b229
	ret z			;b22a
	ld a,(0e2b9h)		;b22b   ; quedan pasos?
	and a			;b22e
	ret z			;b22f
	ld a,(0e2bbh)		;b230   ; la espera...
	dec a			;b233   ; ...un cuadro menos
	ld (0e2bbh),a		;b234
	ret nz			;b237
	ld a,(0e2b9h)		;b238   ; un paso menos
	dec a			;b23b
	ld (0e2b9h),a		;b23c
	ld a,(0e2bah)		;b23f   ; otra vez la espera
	ld (0e2bbh),a		;b242
	ld a,(0e2b8h)		;b245   ; el periodo...
	ld b,a			;b248
	ld a,(0e2bch)		;b249   ; ...mas el paso
	add a,b			;b24c
	ld (0e2b8h),a		;b24d
	jp psg_ruido		;b250   ; al registro 6
canal_paso_pon:		; El canal A (0-2) en 0xE2D5 y un paso
	ld (0e2d5h),a		;b253
	call canal_paso		;b256
sonido_fin:
	ret			;b259
pedido_gana:		; (HL) el que suena, (HL+1) el pedido: Z sin pedido; C si el pedido es de numero menor (gana)
	ld b,(hl)			;b25a   ; el que suena
	inc hl			;b25b
	ld a,(hl)			;b25c   ; el pedido
	and a			;b25d
	ret z			;b25e   ; ninguno: Z
	cp b			;b25f   ; C si gana
	ret			;b260
canal_cuenta:		; La cuenta de la nota (+1): acabada, A = 1; si no, la envolvente: cada tantos cuadros el volumen baja uno; con 15, se corta a la mitad
	inc hl			;b261
	dec (hl)			;b262
	jp z,canal_cuenta_fin		;b263
	inc hl			;b266
	ld a,(hl)			;b267
	and a			;b268
	jp z,canal_cuenta_sigue		;b269
	cp 00fh		;b26c   ; 15: la envolvente corta
	jr z,canal_cuenta_15		;b26e
	inc hl			;b270
	dec (hl)			;b271   ; la cuenta de la envolvente
	jr nz,canal_cuenta_sigue		;b272
	dec hl			;b274
	ld a,(hl)			;b275   ; la espera...
	inc hl			;b276
	ld (hl),a			;b277   ; ...otra vez
	inc hl			;b278
	dec (hl)			;b279   ; el volumen, uno menos
	ld a,(hl)			;b27a
	call psg_c		;b27b   ; al PSG
	and a			;b27e
	jr nz,canal_cuenta_sigue		;b27f
	dec hl			;b281   ; volumen 0: sin envolvente
	dec hl			;b282
	ld (hl),a			;b283
canal_cuenta_sigue:
	xor a			;b284
	ret			;b285
canal_cuenta_15:
	inc hl			;b286
	dec (hl)			;b287   ; la cuenta
	jr nz,canal_cuenta_sigue		;b288
	xor a			;b28a
	dec hl			;b28b
	ld (hl),a			;b28c   ; el volumen a 0
	call psg_c		;b28d
	ret			;b290
canal_cuenta_fin:
	dec hl			;b291   ; acabada
	xor a			;b292
	ld (hl),a			;b293   ; acabada: A = 1
	ld a,001h		;b294   ; 1
	ret			;b296
ruido_pon:		; El ruido: su periodo fijo o con barrido (periodo, cuantas veces, cada cuanto, el paso)
	ld (iy+000h),a		;b297   ; la nota
	inc hl			;b29a
	ld a,(hl)			;b29b   ; con barrido?
	ld (0e2b7h),a		;b29c   ; con barrido (cuantas veces)?
	and a			;b29f
	jr nz,ruido_barre		;b2a0
	inc hl			;b2a2
	ld a,(hl)			;b2a3   ; el periodo...
	ld (0e2b8h),a		;b2a4
	call psg_ruido		;b2a7   ; ...registro 6
	xor a			;b2aa   ; sin barrido
	ld (0e2b9h),a		;b2ab
	ld (0e2bah),a		;b2ae
	ld (0e2bbh),a		;b2b1
	ld (0e2bch),a		;b2b4
	inc a			;b2b7   ; hay ruido
	ld (0e2b6h),a		;b2b8
	ret			;b2bb
ruido_barre:
	ld (0e2b6h),a		;b2bc   ; hay ruido con barrido
	ld (0e2bch),a		;b2bf
	inc hl			;b2c2
	ld a,(hl)			;b2c3   ; el periodo...
	ld (0e2b8h),a		;b2c4
	call psg_ruido		;b2c7   ; ...registro 6
	inc hl			;b2ca
	ld a,(hl)			;b2cb   ; cuantas veces...
	ld (0e2b9h),a		;b2cc
	inc hl			;b2cf
	ld a,(hl)			;b2d0   ; ...cada cuanto
	ld (0e2bah),a		;b2d1
	ld (0e2bbh),a		;b2d4
	ret			;b2d7
nota_pon:		; Una nota: el byte de arriba es la duracion (la tabla 0xB329, o el byte siguiente con 0xE), el de abajo el volumen (15: la mitad)
	ld a,(hl)			;b2d8   ; la nota...
	ld (iy+000h),a		;b2d9
	and 00fh		;b2dc   ; ...el volumen (la mitad baja)
	ld (iy+002h),a		;b2de
	ld a,(hl)			;b2e1   ; la duracion (la mitad alta)...
	and 0f0h		;b2e2
	rrca			;b2e4
	rrca			;b2e5
	rrca			;b2e6
	rrca			;b2e7
	cp 00eh		;b2e8   ; ...0xE: en el byte siguiente
	jr z,nota_duracion_byte		;b2ea
	ld de,0b329h		;b2ec   ; la tabla de duraciones
	add a,e			;b2ef
	jr nc,nota_duracion		;b2f0
	inc d			;b2f2
nota_duracion:
	ld e,a			;b2f3
	ld a,(de)			;b2f4   ; la duracion
	jr nota_volumen		;b2f5
nota_duracion_byte:
	inc hl			;b2f7
	ld a,(hl)			;b2f8
nota_volumen:
	ld (iy+001h),a		;b2f9
	ld a,(iy+002h)		;b2fc   ; volumen 15?
	cp 00fh		;b2ff
	jr nz,nota_cuenta		;b301
	ld a,(iy+001h)		;b303   ; la duracion...
	push bc			;b306
	ld c,a			;b307
	srl a		;b308   ; ...menos la mitad: la espera
	ld b,a			;b30a
	ld a,c			;b30b
	sub b			;b30c
	pop bc			;b30d
nota_cuenta:
	ld (iy+003h),a		;b30e   ; la cuenta de la envolvente
	ld a,00fh		;b311   ; el volumen 15
	ld (iy+004h),a		;b313
	jp psg_c		;b316   ; al PSG
nota_tono:		; El tono de la nota: un byte de periodo bajo (0x10 o mas) o dos (el alto y el bajo), al registro B (+1 el alto)
	inc hl			;b319
	ld a,(hl)			;b31a   ; el primer byte
	cp 010h		;b31b   ; menos de 0x10: el alto
	jr nc,nota_tono_bajo		;b31d
	call psg_b1		;b31f
	inc hl			;b322
	ld a,(hl)			;b323
nota_tono_bajo:
	call psg_b		;b324
	inc hl			;b327
	ret			;b328

; ----------------------------------------------------------------------
; DATOS duraciones: Las 14 duraciones de las notas (0x80, 0x60 ... 1)
;   0xb329..0xb337  (14 bytes)
DATA_duraciones:
	defb 080h,060h,040h,030h,020h,018h,010h,00ch,008h,006h,004h,003h,002h,001h	; b329  .`@0 .........

; ======================================================================
; CODIGO 0xb337..0xb432  (251 bytes)
; ======================================================================


psg_c:		; WRTPSG: el registro C
	ld e,a			;b337   ; el valor...
	ld a,c			;b338   ; ...el registro C
psg:
	jp 00093h		;b339   ; WRTPSG
psg_b:		; El registro B
	ld e,a			;b33c   ; el registro B
	ld a,b			;b33d
	jr psg		;b33e
psg_b1:		; El registro B + 1
	ld e,a			;b340   ; el registro B + 1
	ld a,b			;b341
	inc a			;b342
	jr psg		;b343
psg_mezcla:		; El registro 7
	ld e,a			;b345   ; el registro 7
	ld a,007h		;b346
	jr psg		;b348
psg_ruido:		; El registro 6
	ld e,a			;b34a   ; el registro 6
	ld a,006h		;b34b
	jr psg		;b34d
musica_empieza:		; Una musica: los tres canales de la tabla 0xB000 (6 bytes por musica: la musica N en 0xB000 + 6N)
	ld hl,0b000h		;b34f   ; la tabla de musicas
	ld a,(0e2beh)		;b352   ; la pedida...
	ld (0e2bdh),a		;b355   ; ...suena
	ld b,a			;b358   ; x 6
	add a,b			;b359
	add a,b			;b35a
	add a,b			;b35b
	add a,b			;b35c
	add a,b			;b35d
	call canal_a_tabla		;b35e
	inc hl			;b361
	call canales_bc		;b362
	ld (0e28ah),a		;b365
	ld (0e2beh),a		;b368   ; el pedido, gastado
	ld a,0f8h		;b36b
mezcla_pon:		; El registro 7 (0xE088) al PSG y los canales
	ld (0e088h),a		;b36d
	call psg_mezcla		;b370
	jp sonido_canal_a		;b373
musica_acaba:		; La pieza del canal A acabada: si hay otra musica pedida, empieza; si no, todo callado (0xB386)
	ld a,(0e2beh)		;b376   ; una pedida?
	and a			;b379
	jr nz,musica_empieza		;b37a
	ld (0e2bdh),a		;b37c   ; ninguna suena
	dec a			;b37f
sonido_cero:		; Todo callado: el registro 7 a A (0xFF desde la interrupcion) y los canales a cero
	ld (0e088h),a		;b380
	call psg_mezcla		;b383
canales_borra:		; Los tres canales y lo demas (0xE280, 0x43 bytes) a cero
	ld hl,0e280h		;b386
	ld b,043h		;b389   ; 0x43 bytes
canales_borra_byte:
	ld (hl),000h		;b38b
	inc hl			;b38d
	djnz canales_borra_byte		;b38e
	ret			;b390
sonido_a_empieza:		; Un efecto del canal A: su pieza de la tabla de 0xB024 (2 bytes por efecto)
	ld hl,0b024h		;b391   ; la tabla de efectos de A
	ld a,(0e2c0h)		;b394   ; el pedido...
	ld (0e2bfh),a		;b397   ; ...suena
	add a,a			;b39a
	call canal_a_tabla		;b39b
	xor a			;b39e   ; sin nota en marcha
	ld (0e28ah),a		;b39f
	ld (0e2c0h),a		;b3a2   ; el pedido, gastado
	ld a,(0e088h)		;b3a5   ; el canal A con tono
	res 0,a		;b3a8
	ld (0e088h),a		;b3aa
	call psg_mezcla		;b3ad
	ld hl,0e2c0h		;b3b0
	jp sonido_bc_mira2		;b3b3
sonido_a_acaba:		; El efecto del canal A acabado (0xF7): otro pedido, o el canal A callado
	ld a,(0e2c0h)		;b3b6   ; otro pedido?
	and a			;b3b9
	jr nz,sonido_a_empieza		;b3ba
	ld (0e2bfh),a		;b3bc   ; ninguno suena
	ld hl,0e280h		;b3bf   ; el canal A a cero
	ld b,012h		;b3c2
	call canales_borra_byte		;b3c4
	ld a,(0e088h)		;b3c7
	or 009h		;b3ca
mezcla_pon_fin:
	ld (0e088h),a		;b3cc
	jp psg_mezcla		;b3cf
sonido_bc_empieza:		; Un efecto de los canales B y C: sus dos piezas de la tabla de 0xB034 (4 bytes por efecto)
	ld hl,0b034h		;b3d2   ; la tabla de efectos de B y C
	ld a,(0e2c2h)		;b3d5   ; el pedido...
	ld (0e2c1h),a		;b3d8   ; ...suena
	add a,a			;b3db   ; x 4
	add a,a			;b3dc
	add a,l			;b3dd
	ld l,a			;b3de
	call canales_bc		;b3df   ; las dos piezas
	ld (0e2c2h),a		;b3e2   ; el pedido, gastado
	ld a,(0e088h)		;b3e5   ; B y C con tono
	and 0f9h		;b3e8
	jp mezcla_pon		;b3ea
sonido_bc_acaba:		; El efecto de B y C acabado: otro pedido, o B y C callados
	ld a,(0e2c2h)		;b3ed   ; otro pedido?
	and a			;b3f0
	jr nz,sonido_bc_empieza		;b3f1
	ld (0e2c1h),a		;b3f3
	ld hl,0e292h		;b3f6   ; los canales B y C...
	ld b,024h		;b3f9
	call canales_borra_byte		;b3fb
	ld a,(0e088h)		;b3fe   ; B y C callados
	or 036h		;b401
	jr mezcla_pon_fin		;b403
canales_bc:		; Los canales B y C desde la tabla HL
	ld e,(hl)			;b405   ; la pieza del canal B
	inc hl			;b406
	ld d,(hl)			;b407
	ld (0e292h),de		;b408   ; ...y su principio
	ld (0e294h),de		;b40c
	inc hl			;b410
	ld e,(hl)			;b411   ; la del canal C
	inc hl			;b412
	ld d,(hl)			;b413
	ld (0e2a4h),de		;b414
	ld (0e2a6h),de		;b418
	xor a			;b41c   ; sin nota en marcha
	ld (0e29ch),a		;b41d
	ld (0e2aeh),a		;b420
	ret			;b423
canal_a_tabla:		; El canal A desde la tabla
	add a,l			;b424   ; + la musica x 6
	ld l,a			;b425
	ld e,(hl)			;b426   ; el canal A: su pieza...
	inc hl			;b427
	ld d,(hl)			;b428
	ld (0e280h),de		;b429   ; ...y su principio
	ld (0e282h),de		;b42d
	ret			;b431

; ----------------------------------------------------------------------
; DATOS piezas: Las piezas de la musica y de los efectos (notas y ordenes
;   0xF0-0xFF); desde 0xBFBB, restos de la rutina que pinta la pantalla del
;   primer Iga Ninpouchou y unos bytes de dibujo
;   0xb432..0xc000  (3022 bytes)
DATA_piezas:
	defb 01ch,000h,000h,0f7h,0b2h,000h,080h,0b2h,070h,0b2h,060h,0b2h,060h,0b2h,050h,0b2h	; b432  ........p.`.`.P.
	defb 040h,0f7h,081h,001h,080h,0a1h,040h,0f7h,063h,000h,040h,0f7h,0d1h,000h,010h,0d1h	; b442  @.....@.c.@.....
	defb 040h,0d1h,020h,0d1h,050h,0d1h,030h,0d1h,060h,0d1h,040h,0d1h,070h,0d1h,050h,0d1h	; b452  @. .P.0.`.@.p.P.
	defb 080h,0d1h,060h,0d1h,090h,0f7h,0c1h,000h,0f0h,0c1h,0e0h,0c1h,0d0h,0c1h,0c0h,0c1h	; b462  ..`.............
	defb 0b0h,0c1h,0a0h,0c1h,090h,0c1h,080h,0c1h,070h,0c1h,060h,0c1h,050h,0c1h,040h,0f7h	; b472  ........p.`.P.@.
	defb 0b1h,000h,0e0h,0b1h,050h,0b1h,0d0h,0f7h,0b1h,000h,030h,0b1h,0f0h,0b1h,040h,0f7h	; b482  ....P.....0...@.
	defb 01ch,000h,000h,0ffh,0fdh,002h,084h,003h,057h,061h,000h,000h,084h,003h,057h,084h	; b492  ........Wa....W.
	defb 003h,057h,084h,003h,057h,084h,003h,057h,061h,000h,000h,084h,003h,057h,084h,003h	; b4a2  .W..W..Wa....W..
	defb 057h,084h,003h,057h,084h,003h,057h,061h,000h,000h,084h,003h,057h,084h,003h,057h	; b4b2  W..W..Wa....W..W
	defb 084h,003h,057h,084h,003h,057h,084h,003h,057h,084h,003h,057h,084h,003h,057h,084h	; b4c2  ..W..W..W..W..W.
	defb 003h,057h,084h,003h,057h,0fch,084h,002h,03bh,084h,001h,0e0h,084h,002h,081h,084h	; b4d2  .W..W...;.......
	defb 002h,01bh,084h,002h,0a7h,084h,002h,05dh,084h,002h,0fah,084h,002h,0cfh,084h,003h	; b4e2  .......]........
	defb 027h,081h,000h,000h,031h,000h,000h,066h,003h,057h,0ffh,039h,001h,01dh,039h,001h	; b4f2  '...1..f.W.9..9.
	defb 053h,066h,002h,03bh,084h,001h,0fch,084h,001h,0ach,084h,002h,0a7h,049h,001h,01dh	; b502  Sf.;.........I..
	defb 051h,000h,000h,039h,001h,01dh,039h,001h,053h,066h,002h,03bh,084h,001h,0fch,084h	; b512  Q..9..9.Sf.;....
	defb 001h,0ach,084h,002h,0a7h,049h,001h,01dh,051h,000h,000h,084h,001h,01dh,084h,000h	; b522  .....I..Q.......
	defb 0f0h,084h,001h,040h,084h,001h,00dh,084h,001h,053h,084h,001h,02eh,084h,001h,07dh	; b532  ...@.....S.....}
	defb 084h,001h,068h,084h,001h,094h,081h,000h,000h,031h,000h,000h,066h,001h,0ach,0ffh	; b542  ..h......1..f...
	defb 0fdh,002h,084h,000h,0d6h,084h,000h,0d6h,084h,000h,0d6h,084h,000h,0d6h,081h,000h	; b552  ................
	defb 000h,084h,000h,0aah,049h,000h,08fh,061h,000h,000h,084h,000h,08fh,084h,000h,07fh	; b562  ....I..a........
	defb 084h,000h,08fh,084h,000h,07fh,084h,000h,08fh,084h,000h,07fh,051h,000h,08fh,051h	; b572  ............Q..Q
	defb 000h,000h,0fch,0a2h,000h,08fh,0a2h,000h,08fh,0a2h,000h,078h,0a2h,000h,078h,0a2h	; b582  ...........x..x.
	defb 000h,0a0h,0a2h,000h,0a0h,0a2h,000h,087h,0a2h,000h,087h,0a2h,000h,0aah,0a2h,000h	; b592  ................
	defb 0aah,0a2h,000h,0a0h,0a2h,000h,0a0h,0a2h,000h,0beh,0a2h,000h,0beh,0a2h,000h,0b4h	; b5a2  ................
	defb 0a2h,000h,0b4h,0a2h,000h,0cah,0a2h,000h,0cah,081h,000h,000h,031h,000h,000h,066h	; b5b2  ............1..f
	defb 000h,06bh,0ffh,084h,000h,08fh,081h,000h,000h,084h,000h,08fh,084h,000h,08fh,084h	; b5c2  .k..............
	defb 000h,0aah,081h,000h,000h,084h,000h,0beh,081h,000h,000h,055h,000h,0d6h,084h,000h	; b5d2  ...........U....
	defb 0beh,084h,000h,0d6h,081h,000h,000h,084h,000h,0feh,081h,000h,000h,055h,001h,01dh	; b5e2  .............U..
	defb 084h,000h,0feh,084h,000h,0d6h,081h,000h,000h,084h,000h,0feh,081h,000h,000h,084h	; b5f2  ................
	defb 000h,0beh,081h,000h,000h,084h,000h,0d6h,084h,000h,0d6h,084h,000h,0feh,081h,000h	; b602  ................
	defb 000h,084h,001h,01dh,081h,000h,000h,028h,000h,0feh,0ffh,081h,000h,000h,084h,002h	; b612  .......(........
	defb 03bh,084h,001h,0fch,084h,001h,0ach,081h,000h,000h,084h,002h,03bh,084h,001h,0fch	; b622  ;...........;...
	defb 084h,001h,0ach,081h,000h,000h,084h,002h,03bh,084h,001h,0fch,084h,001h,0ach,081h	; b632  ........;.......
	defb 000h,000h,084h,002h,03bh,084h,001h,0fch,084h,001h,0ach,081h,000h,000h,084h,002h	; b642  ....;...........
	defb 03bh,084h,001h,0fch,084h,001h,0ach,081h,000h,000h,084h,002h,03bh,084h,001h,0fch	; b652  ;...........;...
	defb 084h,001h,0ach,066h,001h,0ach,084h,001h,07dh,084h,001h,0ach,066h,001h,0fch,084h	; b662  ...f....}...f...
	defb 002h,03bh,081h,000h,000h,028h,001h,053h,0ffh,084h,003h,057h,084h,003h,057h,084h	; b672  .;...(.S...W..W.
	defb 003h,057h,084h,003h,057h,084h,003h,057h,081h,000h,000h,084h,003h,057h,081h,000h	; b682  .W..W..W.....W..
	defb 000h,084h,003h,0f9h,084h,003h,0f9h,084h,003h,0f9h,084h,003h,0f9h,084h,003h,0f9h	; b692  ................
	defb 081h,000h,000h,084h,003h,0f9h,081h,000h,000h,084h,003h,057h,084h,003h,057h,084h	; b6a2  ...........W..W.
	defb 003h,057h,084h,003h,057h,084h,003h,057h,081h,000h,000h,084h,003h,057h,081h,000h	; b6b2  .W..W..W.....W..
	defb 000h,084h,003h,057h,081h,000h,000h,084h,003h,0f9h,081h,000h,000h,084h,004h,075h	; b6c2  ...W...........u
	defb 081h,000h,000h,084h,005h,04dh,081h,000h,000h,028h,003h,0f9h,0ffh,084h,003h,057h	; b6d2  .....M...(.....W
	defb 081h,000h,000h,084h,002h,03bh,084h,003h,057h,081h,000h,000h,084h,003h,057h,084h	; b6e2  .....;..W.....W.
	defb 004h,075h,084h,003h,08ah,084h,003h,057h,081h,000h,000h,084h,002h,03bh,084h,003h	; b6f2  .u.....W.....;..
	defb 057h,081h,000h,000h,084h,003h,057h,084h,004h,075h,084h,003h,08ah,084h,002h,081h	; b702  W.....W..u......
	defb 084h,001h,0ach,084h,001h,0fch,084h,001h,0ach,084h,002h,081h,084h,001h,0ach,084h	; b712  ................
	defb 002h,081h,084h,001h,0fch,084h,002h,081h,084h,001h,0ach,084h,001h,0fch,084h,001h	; b722  ................
	defb 0ach,084h,002h,081h,084h,001h,0ach,084h,002h,081h,084h,001h,0fch,084h,003h,057h	; b732  ...............W
	defb 081h,000h,000h,084h,002h,03bh,084h,003h,057h,081h,000h,000h,084h,003h,057h,084h	; b742  .....;..W.....W.
	defb 004h,075h,084h,003h,08ah,084h,003h,057h,081h,000h,000h,084h,002h,03bh,084h,003h	; b752  .u.....W.....;..
	defb 057h,081h,000h,000h,084h,003h,057h,084h,004h,075h,084h,003h,08ah,084h,002h,081h	; b762  W.....W..u......
	defb 081h,000h,000h,084h,001h,0ach,081h,000h,000h,084h,002h,0fah,081h,000h,000h,084h	; b772  ................
	defb 001h,0c5h,081h,000h,000h,048h,003h,057h,0ffh,061h,000h,000h,084h,000h,0d6h,084h	; b782  .....H.W.a......
	defb 000h,0d6h,084h,002h,03bh,084h,002h,03bh,084h,002h,03bh,084h,002h,03bh,061h,000h	; b792  ....;..;..;..;a.
	defb 000h,084h,000h,0d6h,084h,000h,0d6h,084h,002h,03bh,084h,002h,03bh,084h,002h,03bh	; b7a2  .........;..;..;
	defb 084h,002h,03bh,084h,000h,0a0h,084h,000h,0aah,084h,000h,0a0h,084h,000h,0aah,068h	; b7b2  ..;............h
	defb 000h,0a0h,068h,000h,08fh,058h,000h,07fh,084h,000h,08fh,084h,000h,0a0h,081h,000h	; b7c2  ..h..X..........
	defb 000h,084h,000h,0beh,081h,000h,000h,061h,000h,000h,084h,000h,0d6h,084h,000h,0d6h	; b7d2  .......a........
	defb 084h,002h,03bh,084h,002h,03bh,084h,002h,03bh,084h,002h,03bh,061h,000h,000h,084h	; b7e2  ..;..;..;..;a...
	defb 000h,0d6h,084h,000h,0d6h,084h,002h,03bh,084h,002h,03bh,084h,002h,03bh,084h,002h	; b7f2  .......;..;..;..
	defb 03bh,068h,000h,0beh,084h,000h,0a0h,084h,000h,0aah,084h,000h,0beh,081h,000h,000h	; b802  ;h..............
	defb 084h,000h,0e2h,081h,000h,000h,048h,000h,0d6h,0ffh,061h,000h,000h,084h,000h,0aah	; b812  ......H...a.....
	defb 084h,000h,0aah,084h,001h,01dh,084h,001h,02eh,068h,001h,01dh,061h,000h,000h,084h	; b822  .........h..a...
	defb 000h,0aah,084h,000h,0aah,084h,001h,01dh,084h,001h,02eh,068h,001h,01dh,084h,000h	; b832  ...........h....
	defb 07fh,084h,000h,08fh,084h,000h,07fh,084h,000h,08fh,068h,000h,07fh,068h,000h,071h	; b842  ..........h..h.q
	defb 058h,000h,06bh,084h,000h,071h,084h,000h,07fh,081h,000h,000h,084h,000h,0a0h,081h	; b852  X.k..q..........
	defb 000h,000h,061h,000h,000h,084h,000h,0aah,084h,000h,0aah,084h,001h,01dh,084h,001h	; b862  ..a.............
	defb 02eh,068h,001h,01dh,061h,000h,000h,084h,000h,0aah,084h,000h,0aah,084h,001h,01dh	; b872  .h..a...........
	defb 084h,001h,02eh,068h,001h,01dh,068h,000h,0a0h,084h,000h,07fh,084h,000h,08fh,084h	; b882  ...h..h.........
	defb 000h,0a0h,081h,000h,000h,084h,000h,0beh,081h,000h,000h,048h,000h,0aah,0ffh,026h	; b892  ...........H...&
	defb 000h,050h,0ffh,026h,000h,040h,0ffh,081h,000h,000h,026h,020h,0ffh,084h,003h,0f9h	; b8a2  .P.&.@....& ....
	defb 084h,001h,0fch,084h,003h,0f9h,084h,002h,03bh,084h,003h,0f9h,084h,002h,0a7h,084h	; b8b2  ........;.......
	defb 003h,0f9h,081h,000h,000h,084h,003h,0f9h,084h,001h,0fch,084h,003h,0f9h,084h,002h	; b8c2  ................
	defb 03bh,084h,003h,0f9h,084h,002h,0a7h,084h,003h,0f9h,081h,000h,000h,084h,003h,0f9h	; b8d2  ;...............
	defb 084h,003h,0c0h,084h,002h,0fah,084h,002h,0a7h,084h,002h,03bh,084h,001h,0e0h,084h	; b8e2  ...........;....
	defb 001h,07dh,058h,001h,053h,0ffh,084h,000h,0feh,084h,001h,053h,084h,000h,0f0h,084h	; b8f2  .}X.S......S....
	defb 001h,01dh,084h,000h,0beh,084h,000h,0f0h,084h,000h,0feh,084h,000h,0f0h,084h,000h	; b902  ................
	defb 0feh,084h,001h,053h,084h,000h,0f0h,084h,001h,01dh,084h,000h,0beh,084h,000h,0f0h	; b912  ...S............
	defb 084h,000h,0feh,084h,000h,0f0h,081h,000h,000h,084h,001h,0fch,084h,001h,0e0h,084h	; b922  ................
	defb 001h,07dh,084h,001h,053h,084h,001h,01dh,084h,000h,0f0h,058h,000h,0feh,0ffh,0a2h	; b932  .}..S......X....
	defb 000h,040h,083h,000h,0f0h,0ffh,0fdh,002h,084h,000h,08fh,084h,000h,08fh,084h,000h	; b942  .@..............
	defb 08fh,084h,000h,08fh,084h,000h,07fh,081h,000h,000h,084h,000h,06bh,081h,000h,000h	; b952  ............k...
	defb 048h,000h,07fh,084h,000h,08fh,081h,000h,000h,084h,000h,0aah,081h,000h,000h,084h	; b962  H...............
	defb 000h,07fh,084h,000h,06bh,084h,000h,08fh,084h,000h,07fh,084h,000h,0aah,084h,000h	; b972  ....k...........
	defb 08fh,084h,000h,0beh,084h,000h,0aah,084h,000h,0d6h,081h,000h,000h,084h,000h,0beh	; b982  ................
	defb 081h,000h,000h,066h,000h,0aah,061h,000h,000h,084h,000h,08fh,084h,000h,08fh,084h	; b992  ...f..a.........
	defb 000h,08fh,084h,000h,08fh,084h,000h,07fh,081h,000h,000h,084h,000h,06bh,081h,000h	; b9a2  .............k..
	defb 000h,048h,000h,07fh,084h,000h,08fh,081h,000h,000h,084h,000h,0aah,081h,000h,000h	; b9b2  .H..............
	defb 084h,000h,07fh,084h,000h,06bh,084h,000h,08fh,084h,000h,07fh,084h,000h,0aah,084h	; b9c2  .....k..........
	defb 000h,08fh,084h,000h,0beh,084h,000h,0aah,084h,000h,08fh,081h,000h,000h,084h,001h	; b9d2  ................
	defb 01dh,081h,000h,000h,084h,001h,01dh,081h,000h,000h,084h,001h,01dh,081h,000h,000h	; b9e2  ................
	defb 0fch,0fdh,003h,084h,001h,07dh,084h,001h,094h,084h,001h,07dh,084h,001h,094h,061h	; b9f2  .....}.....}...a
	defb 000h,000h,084h,001h,07dh,084h,001h,07dh,084h,002h,0fah,081h,000h,000h,084h,002h	; ba02  ....}..}........
	defb 03bh,081h,000h,000h,084h,001h,0fch,081h,000h,000h,084h,002h,03bh,081h,000h,000h	; ba12  ;...........;...
	defb 0fch,084h,001h,07dh,084h,001h,094h,084h,001h,07dh,084h,001h,094h,061h,000h,000h	; ba22  ...}.....}...a..
	defb 084h,001h,07dh,084h,001h,07dh,084h,002h,0fah,081h,000h,000h,084h,002h,03bh,081h	; ba32  ..}..}........;.
	defb 000h,000h,084h,001h,0fch,081h,000h,000h,084h,001h,0c5h,081h,000h,000h,0ffh,0fdh	; ba42  ................
	defb 002h,0fbh,003h,084h,003h,057h,081h,000h,000h,084h,001h,053h,084h,001h,07dh,084h	; ba52  .....W.....S..}.
	defb 003h,057h,081h,000h,000h,084h,001h,0fch,081h,000h,000h,084h,003h,057h,081h,000h	; ba62  .W...........W..
	defb 000h,084h,002h,03bh,081h,000h,000h,084h,003h,057h,084h,002h,03bh,084h,001h,0fch	; ba72  ...;.....W..;...
	defb 084h,001h,0ach,0fah,084h,003h,057h,081h,000h,000h,084h,001h,053h,084h,001h,07dh	; ba82  ......W.....S..}
	defb 084h,003h,057h,081h,000h,000h,084h,001h,0fch,081h,000h,000h,084h,003h,057h,081h	; ba92  ..W...........W.
	defb 000h,000h,086h,004h,075h,086h,003h,0f9h,086h,004h,075h,086h,003h,0f9h,086h,004h	; baa2  ....u.....u.....
	defb 075h,086h,003h,0f9h,0fch,0fdh,003h,084h,004h,075h,081h,000h,000h,084h,002h,0fah	; bab2  u........u......
	defb 084h,002h,03bh,084h,004h,075h,081h,000h,000h,084h,004h,075h,081h,000h,000h,084h	; bac2  ..;..u.....u....
	defb 004h,075h,084h,004h,075h,084h,004h,075h,081h,000h,000h,084h,004h,075h,081h,000h	; bad2  .u..u..u.....u..
	defb 000h,084h,004h,075h,081h,000h,000h,0fch,084h,004h,075h,081h,000h,000h,084h,002h	; bae2  ...u......u.....
	defb 0fah,084h,002h,03bh,084h,004h,075h,081h,000h,000h,084h,004h,075h,081h,000h,000h	; baf2  ...;..u.....u...
	defb 084h,004h,075h,084h,004h,075h,084h,004h,075h,081h,000h,000h,084h,003h,0f9h,081h	; bb02  ..u..u..u.......
	defb 000h,000h,084h,003h,08ah,081h,000h,000h,0feh,0fdh,004h,084h,003h,0f9h,081h,000h	; bb12  ................
	defb 000h,084h,001h,0fch,081h,000h,000h,084h,001h,0fch,081h,000h,000h,084h,001h,0fch	; bb22  ................
	defb 081h,000h,000h,084h,002h,03bh,084h,002h,01bh,084h,001h,0fch,081h,000h,000h,084h	; bb32  .....;..........
	defb 001h,0fch,081h,000h,000h,084h,001h,0fch,081h,000h,000h,0fch,0fbh,002h,084h,004h	; bb42  ................
	defb 075h,081h,000h,000h,084h,002h,03bh,081h,000h,000h,084h,002h,03bh,081h,000h,000h	; bb52  u.....;.....;...
	defb 084h,002h,03bh,081h,000h,000h,084h,002h,081h,084h,002h,05dh,084h,002h,03bh,081h	; bb62  ..;........]..;.
	defb 000h,000h,084h,002h,03bh,081h,000h,000h,084h,002h,03bh,081h,000h,000h,0fah,0ffh	; bb72  ....;.....;.....
	defb 0fdh,002h,048h,000h,0aah,084h,000h,0beh,081h,000h,000h,084h,000h,0d6h,081h,000h	; bb82  ..H.............
	defb 000h,057h,000h,0beh,084h,000h,0d6h,084h,000h,0feh,081h,000h,000h,084h,001h,01dh	; bb92  .W..............
	defb 081h,000h,000h,084h,000h,0d6h,081h,000h,000h,048h,000h,0feh,061h,000h,000h,021h	; bba2  .........H..a..!
	defb 000h,000h,0fch,048h,001h,01dh,084h,000h,0e2h,081h,000h,000h,084h,000h,0beh,081h	; bbb2  ...H............
	defb 000h,000h,084h,000h,0beh,084h,000h,0aah,084h,000h,0beh,084h,000h,0d6h,084h,000h	; bbc2  ................
	defb 0e2h,081h,000h,000h,084h,000h,0d6h,081h,000h,000h,056h,000h,0e2h,084h,000h,0d6h	; bbd2  ..........V.....
	defb 084h,000h,0beh,081h,000h,000h,084h,000h,0aah,081h,000h,000h,084h,000h,0beh,081h	; bbe2  ................
	defb 000h,000h,084h,000h,0beh,084h,000h,0d6h,084h,000h,0e2h,081h,000h,000h,084h,000h	; bbf2  ................
	defb 0d6h,081h,000h,000h,0feh,0fdh,002h,084h,003h,0f9h,084h,001h,0fch,084h,003h,0f9h	; bc02  ................
	defb 081h,000h,000h,084h,002h,03bh,081h,000h,000h,084h,003h,0f9h,081h,000h,000h,084h	; bc12  .....;..........
	defb 002h,0a7h,081h,000h,000h,084h,003h,0f9h,081h,000h,000h,084h,002h,0fah,084h,003h	; bc22  ................
	defb 0f9h,084h,002h,0fah,084h,002h,0a7h,084h,003h,0c0h,084h,001h,0e0h,084h,003h,0c0h	; bc32  ................
	defb 081h,000h,000h,084h,002h,03bh,081h,000h,000h,084h,003h,0c0h,081h,000h,000h,084h	; bc42  .....;..........
	defb 002h,0a7h,081h,000h,000h,084h,003h,0c0h,081h,000h,000h,084h,002h,0fah,084h,003h	; bc52  ................
	defb 0c0h,084h,002h,0fah,084h,002h,0a7h,084h,003h,0f9h,084h,001h,0fch,084h,003h,0f9h	; bc62  ................
	defb 081h,000h,000h,084h,002h,03bh,081h,000h,000h,084h,003h,0f9h,081h,000h,000h,084h	; bc72  .....;..........
	defb 002h,0a7h,081h,000h,000h,084h,003h,0f9h,081h,000h,000h,084h,002h,0fah,084h,003h	; bc82  ................
	defb 0f9h,084h,002h,0fah,084h,002h,0a7h,084h,003h,0c0h,084h,001h,0e0h,084h,003h,0c0h	; bc92  ................
	defb 084h,002h,03bh,084h,003h,0c0h,084h,002h,0a7h,084h,003h,0c0h,084h,002h,0fah,084h	; bca2  ..;.............
	defb 002h,0a7h,051h,000h,000h,058h,003h,0c0h,081h,000h,000h,0fch,048h,001h,0fch,048h	; bcb2  ..Q..X......H..H
	defb 002h,0cfh,048h,001h,0fch,048h,002h,0cfh,048h,001h,0fch,048h,002h,0cfh,048h,001h	; bcc2  ..H..H..H..H..H.
	defb 0fch,048h,002h,0cfh,0fdh,003h,084h,003h,0f9h,081h,000h,000h,084h,003h,0f9h,084h	; bcd2  .H..............
	defb 003h,0f9h,084h,003h,0f9h,081h,000h,000h,084h,003h,0f9h,081h,000h,000h,084h,003h	; bce2  ................
	defb 0f9h,084h,003h,0f9h,084h,003h,0f9h,081h,000h,000h,084h,003h,0f9h,081h,000h,000h	; bcf2  ................
	defb 084h,003h,0f9h,081h,000h,000h,0fch,084h,003h,0f9h,081h,000h,000h,084h,003h,0f9h	; bd02  ................
	defb 084h,003h,0f9h,084h,003h,0f9h,081h,000h,000h,084h,003h,0f9h,081h,000h,000h,0fdh	; bd12  ................
	defb 004h,0a2h,003h,0c0h,0a2h,002h,0fah,0a2h,002h,081h,0a2h,002h,0fah,0fch,0feh,0fdh	; bd22  ................
	defb 002h,084h,000h,0feh,084h,000h,0feh,084h,000h,0feh,084h,000h,0feh,084h,000h,0feh	; bd32  ................
	defb 081h,000h,000h,084h,001h,01dh,081h,000h,000h,084h,000h,0feh,081h,000h,000h,084h	; bd42  ................
	defb 001h,01dh,081h,000h,000h,084h,001h,053h,084h,001h,01dh,084h,000h,0feh,084h,001h	; bd52  .......S........
	defb 01dh,084h,000h,0f0h,084h,000h,0f0h,084h,000h,0f0h,084h,000h,0f0h,084h,000h,0f0h	; bd62  ................
	defb 081h,000h,000h,084h,000h,0feh,081h,000h,000h,084h,000h,0f0h,081h,000h,000h,084h	; bd72  ................
	defb 000h,0feh,081h,000h,000h,084h,001h,01dh,084h,000h,0feh,084h,000h,0f0h,084h,001h	; bd82  ................
	defb 01dh,084h,000h,0feh,084h,000h,0feh,084h,000h,0feh,084h,000h,0feh,084h,000h,0feh	; bd92  ................
	defb 081h,000h,000h,084h,001h,01dh,081h,000h,000h,084h,000h,0feh,081h,000h,000h,084h	; bda2  ................
	defb 001h,01dh,081h,000h,000h,084h,001h,053h,084h,001h,01dh,084h,000h,0feh,084h,001h	; bdb2  .......S........
	defb 01dh,084h,000h,0f0h,084h,000h,0f0h,084h,000h,0f0h,084h,000h,0f0h,084h,000h,0f0h	; bdc2  ................
	defb 081h,000h,000h,084h,000h,0feh,081h,000h,000h,0a2h,000h,08fh,0a2h,000h,07fh,0a2h	; bdd2  ................
	defb 000h,078h,0a2h,000h,05fh,0a2h,000h,078h,0a2h,000h,07fh,0a2h,000h,08fh,0a2h,000h	; bde2  .x.._..x........
	defb 0aah,0a2h,000h,08fh,0a2h,000h,0aah,0a2h,000h,0beh,0a2h,000h,0f0h,0a2h,000h,0beh	; bdf2  ................
	defb 0a2h,000h,0f0h,0a2h,000h,0feh,0a2h,000h,0f0h,0fch,0fdh,004h,068h,001h,02eh,068h	; be02  ............h..h
	defb 000h,0cah,068h,000h,0d6h,068h,001h,01dh,0fch,011h,000h,000h,0a4h,000h,0feh,0a4h	; be12  ..h..h..........
	defb 000h,0f0h,01dh,000h,0aah,051h,000h,000h,0a4h,000h,0feh,0a4h,000h,0f0h,01dh,000h	; be22  .....Q..........
	defb 0aah,051h,000h,000h,0a4h,000h,0feh,0a4h,000h,0f0h,048h,000h,0aah,0a4h,000h,0feh	; be32  .Q........H.....
	defb 0a4h,000h,0f0h,039h,000h,0aah,0fdh,004h,0a2h,001h,07dh,0a2h,001h,040h,0a2h,001h	; be42  ...9......}..@..
	defb 00dh,0a2h,001h,040h,0fch,0feh,043h,000h,035h,0ffh,043h,000h,028h,0ffh,0a1h,001h	; be52  ...@..C.5.C.(...
	defb 0d6h,0a1h,0a4h,0a1h,084h,0a1h,06bh,0ffh,063h,003h,057h,063h,002h,081h,0feh,0a1h	; be62  ......k.c.Wc....
	defb 000h,000h,0a1h,001h,010h,0a1h,050h,0a1h,020h,0a1h,060h,0a1h,030h,0a1h,070h,0a1h	; be72  ......P. .`.0.p.
	defb 040h,0a1h,080h,0ffh,084h,004h,075h,064h,003h,0f9h,084h,003h,08ah,083h,003h,057h	; be82  @.....ud.......W
	defb 083h,003h,057h,083h,003h,057h,083h,003h,057h,061h,000h,000h,083h,003h,057h,083h	; be92  ..W..W..Wa....W.
	defb 003h,057h,083h,003h,057h,083h,003h,057h,061h,000h,000h,083h,002h,0cfh,083h,002h	; bea2  .W..W..Wa.......
	defb 0cfh,083h,002h,0cfh,083h,002h,0cfh,061h,000h,000h,083h,002h,0cfh,083h,002h,0cfh	; beb2  .......a........
	defb 083h,002h,0cfh,083h,002h,0cfh,061h,000h,000h,083h,002h,0fah,083h,002h,0fah,083h	; bec2  ......a.........
	defb 002h,0fah,083h,002h,0fah,061h,000h,000h,083h,003h,08ah,083h,003h,08ah,083h,003h	; bed2  .....a..........
	defb 08ah,083h,003h,08ah,061h,000h,000h,064h,003h,057h,083h,002h,03bh,064h,002h,0a7h	; bee2  ....a..d.W..;d..
	defb 083h,002h,03bh,048h,003h,057h,0ffh,084h,001h,01dh,064h,000h,0feh,084h,000h,0e2h	; bef2  ..;H.W....d.....
	defb 055h,001h,01dh,083h,001h,0ach,081h,000h,000h,041h,000h,000h,083h,002h,03bh,083h	; bf02  U........A....;.
	defb 001h,0fch,083h,001h,0ach,083h,001h,0c5h,083h,001h,068h,083h,001h,01dh,083h,001h	; bf12  ..........h.....
	defb 068h,081h,000h,000h,083h,001h,0c5h,064h,002h,03bh,055h,001h,0c5h,083h,002h,03bh	; bf22  h......d.;U....;
	defb 083h,001h,0fch,083h,001h,07dh,083h,001h,040h,083h,000h,0feh,083h,001h,040h,083h	; bf32  .....}..@.....@.
	defb 001h,07dh,064h,002h,03bh,055h,001h,0fch,083h,001h,0c5h,064h,001h,01dh,083h,001h	; bf42  .}d.;U.....d....
	defb 053h,064h,001h,07dh,083h,001h,053h,048h,001h,0ach,0ffh,041h,000h,000h,055h,000h	; bf52  Sd.}..SH...A..U.
	defb 0d6h,083h,000h,0aah,081h,000h,000h,083h,001h,01dh,064h,000h,0feh,055h,000h,0d6h	; bf62  ..........d..U..
	defb 083h,000h,0beh,083h,000h,0b4h,083h,000h,08fh,083h,000h,07fh,083h,000h,071h,081h	; bf72  ..............q.
	defb 000h,000h,083h,000h,08fh,064h,000h,07fh,055h,000h,08fh,083h,000h,0b4h,083h,000h	; bf82  .....d..U.......
	defb 0beh,083h,000h,0aah,083h,000h,0a0h,083h,000h,07fh,083h,000h,0a0h,083h,000h,0beh	; bf92  ................
	defb 064h,000h,0e2h,055h,000h,0d6h,083h,000h,0beh,064h,000h,0d6h,083h,001h,01dh,064h	; bfa2  d..U.....d.....d
	defb 001h,040h,083h,001h,01dh,048h,001h,053h,0ffh,0fdh,018h,007h,03ah,093h,0e1h,04fh	; bfb2  .@...H.S....:..O
	defb 006h,000h,009h,006h,016h,011h,040h,018h,0c5h,0e5h,001h,020h,000h,0cdh,05ch,000h	; bfc2  ......@.... ..\.
	defb 011h,020h,000h,019h,0ebh,0e1h,03ah,00ah,0e0h,0feh,005h,028h,009h,0feh,001h,028h	; bfd2  . ....:....(...(
	defb 005h,001h,060h,000h,018h,003h,001h,020h,000h,009h,0c1h,010h,0dbh,0c9h,000h,000h	; bfe2  ..`.... ........
	defb 000h,000h,000h,080h,0c0h,0e0h,060h,0c0h,080h,000h,000h,000h,000h,000h	; bff2  ......`.......
