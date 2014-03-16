;*********** AUTOS LED SUBROUTINOK **************

SET_AUTOS_ZOLD:
	in	temp, PORTC 		; Port betoltese
	ori	temp, 0b0000100		; Led bekapcsolasa
	andi temp, 0b1111100	;
	out PORTC, temp			; Portra iras
ret	
;*************************

SET_AUTOS_PIROS:
; TODO
ret
;*************************

SET_AUTOS_PIROS_SARGA:
; TODO
ret
;*************************

SET_AUTOS_SARGA:
; TODO
ret
;*************************

SET_AUTOS_SARGA_V:
; TODO
ret

;*********** GYALOGOS LED SUBROUTINOK **************

SET_GYALOGOS_ZOLD:
; TODO
ret	
;*************************

SET_GYALOGOS_PIROS:
; TODO
ret
;*************************

SET_GYALOGOS_PIROS_SARGA:
; TODO
ret
;*************************

SET_GYALOGOS_SARGA:
; TODO
ret
;*************************

SET_GYALOGOS_SARGA_V:
; TODO
ret

