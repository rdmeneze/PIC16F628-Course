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

	org 0x00
	goto inicio;

    org 0x04
        retfie

inicio:
	BANKSEL CMCON
    MOVLW 0x07 
    MOVWF CMCON 
	
	banksel TRISA
	MOVLW 	TRISA_CNF
	MOVWF	TRISA
	
	banksel TRISB
	MOVLW   TRISB_CNF
	MOVWF   TRISB

loop_Princ:
    BANKSEL PORTA
    BTFSS   PORTA,0
    GOTO    setpb0
    GOTO    clrpb0
setpb0:
    BANKSEL PORTB
    BSF     PORTB,0
    GOTO    sai1
clrpb0:
    BANKSEL PORTB
    BCF     PORTB,0
    GOTO    sai1
    
sai1:
	GOTO    loop_Princ;
	end;