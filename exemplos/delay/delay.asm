   list	 p=16f628a
    #include p16f628a.inc

    __config	_XT_OSC & _PWRTE_OFF & _WDT_OFF & _CP_OFF & _MCLRE_ON

	; uso com cristal de 4MHz
	; ciclo de instrução de 1us

	I 	EQU 0x20
	J	EQU	0x21


	org 0x0000
		goto INICIO
	
	org 0x0004
		retfie
	
INICIO:
	call delay1ms
	goto $

; funções

delay1ms:
	movlw 	.1   ;.5
	movwf 	I
	movlw 	.10  ;.66
	movwf	J
	
	decfsz	J,F; 1(2)cc
	goto 	$-1;  2 cc
	decfsz  I,F; 1(2)cc
	goto 	$-5;2
	return

	end
