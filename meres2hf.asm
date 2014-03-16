;*************************************************************** 
;* Feladat: Közlekedési lámpák
;* Rövid leírás:
;*
;* Közlekedési lámpák: az egyik az autósok lámpája a másik pedig a gyalogosoké. 
;* Nappal normal üzemmódban van, éjszaka, pedig az éjszakaiban (sárgán villogó). 
;* A gyalogos tudja jelezni átkelési szándékát. Ekkor egy bizonyos id? múlva átvált. 
;* A kijelz? segítségével be lehet állítani az autósok, és a gyalogosok zöld, és piros, illetve piros-sárga idejét. 
;* Az id?zít? küls? interrupttal fog m?ködni.
; 
;* Szerzõk:
;* - Szell Andras 81
;* - Kecskes Eniko 82
;* Mérõcsoport: SDU2
;*****************************************************************************
;* AVR mérõpanel portkiosztás:
;*****************************************************************************
;*
;* LED0(P):PortC.0          LED4(P):PortC.4
;* LED1(P):PortC.1          LED5(P):PortC.5
;* LED2(S):PortC.2          LED6(S):PortC.6
;* LED3(Z):PortC.3          LED7(Z):PortC.7        INT:PortE.4
;*
;* SW0:PortG.0     SW1:PortG.1     SW2:PortG.4     SW3:PortG.3
;* 
;* BT0:PortE.5     BT1:PortE.6     BT2:PortE.7     BT3:PortB.7
;*
;*****************************************************************************
;*
;* AIN:PortF.0     NTK:PortF.1    OPTO:PortF.2     POT:PortF.3
;*
;*****************************************************************************
;*
;* LCD1(VSS) = GND         LCD9(DB2): -
;* LCD2(VDD) = VCC         LCD10(DB3): -
;* LCD3(VO ) = GND         LCD11(DB4): PortA.4
;* LCD4(RS ) = PortA.0     LCD12(DB5): PortA.5
;* LCD5(R/W) = GND         LCD13(DB6): PortA.6
;* LCD6(E  ) = PortA.1     LCD14(DB7): PortA.7
;* LCD7(DB0) = -           LCD15(BLA): VCC
;* LCD8(DB1) = -           LCD16(BLK): PortB.5 (1=Háttérvilágítás ON)
;*
;*****************************************************************************

		.nolist
		.include "m128def.inc"	; ATMega 128 definíciós fájl 
		.list

		;***** Konstansok *****

.equ	tconst	= 25			; idõzítési konstans (T = 25*10 msec)

		;***** Regiszterkiosztás ***** 

.def	temp	= r16			; ált. segédregiszter 
.def	sstate	= r17			; SW3 állapot tároló

;*****************************************************************************
;* Reset & IT vektorok  
;*****************************************************************************
		
		.cseg 
		
		.org	0x0000		; Kódszegmens kezdõcíme 
	
		jmp		main		; Reset vektor 
		jmp		dummy		; EXTINT0 Handler
		jmp		dummy		; EXTINT1 Handler
		jmp		dummy		; EXTINT2 Handler
		jmp		dummy		; EXTINT3 Handler
		jmp		dummy		; EXTINT4 Handler (INT gomb)
		jmp		dummy		; EXTINT5 Handler
		jmp		dummy		; EXTINT6 Handler
		jmp		dummy		; EXTINT7 Handler
		jmp		dummy		; Timer2 Compare Match Handler 
		jmp		dummy		; Timer2 Overflow Handler 
		jmp		dummy		; Timer1 Capture Event Handler 
		jmp		dummy		; Timer1 Compare Match A Handler 
		jmp		dummy		; Timer1 Compare Match B Handler 
		jmp		dummy		; Timer1 Overflow Handler 
		jmp		t0it		; Timer0 Compare Match Handler 
		jmp		dummy		; Timer0 Overflow Handler 
		jmp		dummy		; SPI Transfer Complete Handler 
		jmp		dummy		; USART0 RX Complete Handler 
		jmp		dummy		; USART0 Data Register Empty Hanlder 
		jmp		dummy		; USART0 TX Complete Handler 
		jmp		dummy		; ADC Conversion Complete Handler 
		jmp		dummy		; EEPROM Ready Hanlder 
		jmp		dummy		; Analog Comparator Handler 
		jmp		dummy		; Timer1 Compare Match C Handler 
		jmp		dummy		; Timer3 Capture Event Handler 
		jmp		dummy		; Timer3 Compare Match A Handler 
		jmp		dummy		; Timer3 Compare Match B Handler 
		jmp		dummy		; Timer3 Compare Match C Handler 
		jmp		dummy		; Timer3 Overflow Handler 
		jmp		dummy		; USART1 RX Complete Handler 
		jmp		dummy		; USART1 Data Register Empty Hanlder 
		jmp		dummy		; USART1 TX Complete Handler 
		jmp		dummy		; Two-wire Serial Interface Handler 
		jmp		dummy		; Store Program Memory Ready Handler 
	
;*****************************************************************************
;* Fõprogram
;*****************************************************************************
		
		.org	0x0046

;***** Stack inicializálása *****

main:	ldi		temp,LOW(RAMEND)	; RAMEND = RAM végcíme
		out		SPL,temp			; (ld."m128def.inc") 
		ldi		temp,HIGH(RAMEND)
		out		SPH,temp

;***** Portok inicializálása *****

	;*** PORTC.0-7: LED0-7 ***

		ldi		temp,0b11111111		; portbitek kimenetek
		out		DDRC,temp			; PORTC kimenet

	;*** PORTG.0,1,3,4: SW 0,1,3,2 ***

		ldi		temp,0b00000000		; portbitek bemenetek
		sts		DDRG,temp			; PORTG bemenet
		ldi		temp,0b11111111		; pull-up engedélyezve
		sts		PORTG,temp			; PORTG bemenetein

;***** Timer 0 inicializálása *****

		ldi		temp,0b00001111
				;	   0.......		; FOC=0
				;	   .0..1...		; WGM=10 (CTC mod)
				;	   ..00....		; COM=00 (kimenet tiltva)
				;	   .....111		; CS0=111 (CLK/1024)
		out		TCCR0,temp			; Timer 0 TCCR0 regiszter
		ldi		temp,108			; 11059200Hz/1024 = 108*100
		out		OCR0,temp			; Timer 0 OCR0 regiszter
		ldi		temp,0b00000010
				;	   000000..		; Timer2,1 IT tiltva
				;	   ......1.		; OCIE0=1
				;	   .......0		; TOIE0=0
		out		TIMSK,temp			; Timer IT Mask regiszter
		sei							; globális IT engedélyezve

;*****************************************************************************

;***** SW3 állapotának beolvasása *****
		
loop:	lds		sstate,PING			; kapcsolók állaptának beolv.
		jmp		loop				; végtelen hurok  

;*****************************************************************************
;* 10 msec Timer IT rutin
;*****************************************************************************


	.dseg			; 
	count:	.byte	1		; Timer számláló, 1 byte helyfoglalás RAM-ban 
;count:	.db	tconst		; az AVR2 assembler ezt a formát (.db) is elfogadja; 
				; így ha nem adatszegmensben lenne, tconst értékkel lenne inicializálva
				; AVR2 választás: Project/AVR Assembler Setup 

	.cseg

t0it:	push	temp					; segédregiszter mentése
		in		temp,SREG			; státusz mentése
		push	temp

		lds		temp,count			; Timer számláló
		dec		temp				; csökkentése
		sts		count,temp			; és tárolása
		brne	t0ite				; ugrás, ha nem járt le
		ldi		temp,tconst			; számláló visszaállítása
		sts		count,temp

		in		temp,PORTC			; LED állapot beolvasása
		clc
		sbrs	sstate,3			; SW3 aktív ?
		jmp		t0it0				; ugrás, ha igen
		rol		temp				; SW3=0: LED-ek léptetése elõre
		brcs	t0it1
		sbr		temp,1
		jmp		t0it1
t0it0:	ror		temp				; SW3=1: LED-ek léptetése vissza
		brcs	t0it1
		sbr		temp,128
t0it1:	out		PORTC,temp			; LED-ek beállítása

t0ite:	pop		temp				; regiszterek visszaállítása
		out		SREG,temp
		pop		temp
dummy:	reti

;*****************************************************************************

.include "led.asm"
