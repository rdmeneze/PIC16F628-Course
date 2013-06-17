;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   
;   Programa para exemplo de utilização do PORTB com interrupção
;   @Author  :  Rafael Dias Menezes
;   @Data    :  Jul/2009
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    list p=16F628A
    #include <p16F628A.inc>
    RADIX   dec

    __config	_XT_OSC & _PWRTE_OFF & _WDT_OFF & _CP_OFF & _MCLRE_ON	    
    
END_CSTR    EQU 0
	    
LED_INT0    EQU 0x001
LED_DELAY   EQU 0x002
	    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; variáveis globais:
    UDATA
W_TEMP      res 1
STATUS_TEMP res 1
COUNT       res 1
TMP         res 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 
	; objetos externos a main.asm
	; delay
    EXTERN  Delay_1ms
    EXTERN  Delay_500ms
    
    ; funcoes
    EXTERN  TBL_PTR
    EXTERN  TBL_Read
    EXTERN  Int2BCD
    EXTERN  BCD2Int
    
    ;Math
    EXTERN  B_REG
    EXTERN	DIV_8
    EXTERN	MUL_8
    

MAIN    code 0x000
    GOTO inicio;
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    
; ponto de entrada de interrupção
;
INTERR  code 0x004
; salva contexto atual
    BANKSEL W_TEMP
    MOVWF   W_TEMP
    SWAPF   STATUS,W
    
    BANKSEL STATUS_TEMP
    MOVWF   STATUS_TEMP

; ISR
; Rotina de tratamento de interrupção
    BTFSC   INTCON, INTF    ; testa flag de sinalização de interrupção externa INT0
    CALL    TrataINT0;
    
    BTFSC   INTCON, RBIF
    CALL    TrataRBInt;

;   recupera contexto anterior
    BANKSEL STATUS_TEMP
    SWAPF   STATUS_TEMP,W
    MOVWF   STATUS
    
    BANKSEL W_TEMP
    SWAPF   W_TEMP,F
    SWAPF   W_TEMP,W
    RETFIE;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; rotina para configuração da interrupção INT0
ConfigINT0:
    BCF     INTCON,GIE          ; desabilita as interrupções
    BANKSEL OPTION_REG
    BCF     OPTION_REG, INTEDG  ; interrupção INT0 por borda de descida
    BSF     INTCON,INTE         ; habilita a interrupção externa
    BSF     INTCON,GIE          ; desabilita as interrupções
    RETURN;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; rotina de tratamento da interrupção INT0
TrataINT0:
    BANKSEL PORTB
    BTFSS   PORTB, LED_INT0
    GOTO    ON_LED_INT0
    GOTO    OFF_LED_INT0
ON_LED_INT0:  
    BSF     PORTB, LED_INT0
    GOTO    SAI_CTRL_LED_INT0
OFF_LED_INT0:    
    BCF     PORTB, LED_INT0
    GOTO    SAI_CTRL_LED_INT0
SAI_CTRL_LED_INT0:   
    BCF     INTCON, INTF 
    RETURN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TrataRBInt:
    RETURN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

inicio:

	BANKSEL	B_REG
	MOVLW	202
	MOVWF	B_REG
	
	MOVLW   129
	CALL	MUL_8
	CALL	DIV_8

	MOVLW	35
	CALL	Int2BCD
	
	CALL    BCD2Int

    ; desabilita comparador analógico 
    BANKSEL CMCON
    MOVLW   0x07
    MOVWF   CMCON

    ; configura PORTA como entrada    
    BANKSEL TRISA
    MOVLW   b'11111111'
    MOVWF   TRISA
    
    BANKSEL TRISB
    MOVLW   b'11111001' ; PORTB:0       Entrada
                        ; PORTB:1       saida
                        ; PORTB:2       saida
                        ; PORTB:[3-7]   entrada
    MOVWF   TRISB
    
    BANKSEL PORTB
    MOVLW   b'11111001'
    MOVWF   PORTB       ; apago os leds de saída do PORTB

    ; configurar interrupção
    CALL    ConfigINT0;

    BANKSEL COUNT
    CLRF    COUNT
    
    BANKSEL TMP
    CLRF    TMP
    
loop_principal:

    BANKSEL COUNT
    MOVF    COUNT,W
    ADDLW   1
    MOVWF   COUNT
    
    PAGESEL Delay_500ms;
    CALL    Delay_500ms;

    BANKSEL PORTB    
    BTFSS   PORTB, LED_DELAY
    GOTO    LIGA_LED_DELAY
    GOTO    DESLIGA_LED_DELAY
LIGA_LED_DELAY:    
    BSF     PORTB, LED_DELAY
    GOTO    SAI_CTRL_LED_DELAY
DESLIGA_LED_DELAY:    
    BCF     PORTB, LED_DELAY
    GOTO    SAI_CTRL_LED_DELAY
SAI_CTRL_LED_DELAY:   



    ;realiza a leitura da tabela MSG_TESTE
    BANKSEL TMP
    CLRF    TMP
MSG_TESTE_READ:    
    BANKSEL TBL_PTR
    MOVLW   HIGH (MSG_TESTE)
    MOVWF   TBL_PTR
    MOVLW   LOW (MSG_TESTE)
    MOVWF   TBL_PTR+1
    BANKSEL TMP
    MOVF    TMP,W 
    PAGESEL TBL_Read
    CALL    TBL_Read
    XORLW   END_CSTR        ; é final de string?
    BTFSS   STATUS,Z
    GOTO    MSG_TESTE_NEXT
    GOTO    MSG_TESTE_END
    
MSG_TESTE_NEXT:
    BANKSEL TMP
    INCF    TMP,F
    PAGESEL Delay_500ms
    CALL    Delay_500ms
    CALL    Delay_500ms
    GOTO    MSG_TESTE_READ
    
MSG_TESTE_END:
     
    GOTO    loop_principal;


MSG_TESTE   DT  "TESTE",0
    
    
    END