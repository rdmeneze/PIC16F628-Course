;
; exemplo de utilização de instruções de movimentação, teste e de desvio
; Autor: Rafael Dias 
; Data : jun/2009
;

    list	 p=16f628a
    #include p16f628a.inc

    __config	_XT_OSC & _PWRTE_OFF & _WDT_OFF & _CP_OFF & _MCLRE_ON


TRISA_CNF 	EQU	b'00000001'
TRISB_CNF	EQU	b'00000000'


    extern delay1ms
    ;extern  mpy

; vetor de reset
MAIN CODE 0x000
	GOTO inicio;

; vetor de interrupcao
INTERR  CODE 0x004
	retfie

;-------------------------------------

inicio:
    PAGESEL delay1ms
    CALL    delay1ms
    
    ;PAGESEL mpy
    ;CALL    mpy
    
	BANKSEL CMCON
    MOVLW 0x07 
    MOVWF CMCON 
	
	BANKSEL TRISA
	MOVLW 	TRISA_CNF
	MOVWF	TRISA
	
	BANKSEL TRISB
	MOVLW   TRISB_CNF
	MOVWF   TRISB

    GOTO inicio;
	END;