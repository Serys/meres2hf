;*********** AUTOS LED SUBROUTINOK **************

SET_AUTOS_ZOLD:
	in	temp, PORTC 		; Port betoltese
	ori	temp,  0b00001000	; Led bekapcsolasa
	andi temp, 0b11111000	;
	out PORTC, temp			; Portra iras
ret	
;*************************

SET_AUTOS_SARGA:
	in	temp, PORTC 		; Port betoltese
	ori	temp,  0b00000100	; Led bekapcsolasa
	andi temp, 0b11110100	;
	out PORTC, temp			; Portra iras
ret
;*************************

SET_AUTOS_PIROS:
	in	temp, PORTC 		; Port betoltese
	ori	temp,  0b00000010	; Led bekapcsolasa
	andi temp, 0b11110010	;
	out PORTC, temp			; Portra iras
ret
;*************************

SET_AUTOS_PIROS_SARGA:
	in	temp, PORTC 		; Port betoltese
	ori	temp,  0b00000110	; Led bekapcsolasa
	andi temp, 0b11110110	;
	out PORTC, temp			; Portra iras
ret
;*************************


;*********** GYALOGOS LED SUBROUTINOK **************

SET_GYALOGOS_ZOLD:
	in	temp, PORTC 		; Port betoltese
	ori	temp,  0b10000000	; Led bekapcsolasa
	andi temp, 0b10001111	;
	out PORTC, temp			; Portra iras
ret	
;*************************

SET_GYALOGOS_SARGA:
	in	temp, PORTC 		; Port betoltese
	ori	temp,  0b01000000	; Led bekapcsolasa
	andi temp, 0b01001111	;
	out PORTC, temp			; Portra iras
ret
;*************************

SET_GYALOGOS_PIROS:
	in	temp, PORTC 		; Port betoltese
	ori	temp,  0b00100000	; Led bekapcsolasa
	andi temp, 0b00101111	;
	out PORTC, temp			; Portra iras
ret
;*************************

SET_GYALOGOS_PIROS_SARGA:
	in	temp, PORTC 		; Port betoltese
	ori	temp,  0b01100110	; Led bekapcsolasa
	andi temp, 0b01101111	;
	out PORTC, temp			; Portra iras
ret
;*************************

