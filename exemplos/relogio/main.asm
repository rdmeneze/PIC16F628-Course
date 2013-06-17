;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   
;   Programa para exemplo de utilização do PORTB com interrupção
;   @Author  :  Rafael Dias Menezes
;   @Data    :  Jul/2009
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    #include <defs.inc>

    __config	_XT_OSC & _PWRTE_OFF & _WDT_OFF & _CP_OFF & _MCLRE_ON	    
    
    
    EXTERN  InitTimer0
    EXTERN  Delay_1ms
    EXTERN  Delay_500ms
    EXTERN	Delay_Xms
    
    EXTERN  Init7SEG
    EXTERN  Refresh7SEG
    
    EXTERN  TrataTimer0
    EXTERN  iSecCounter
    
    EXTERN  B_REG
    
    EXTERN  LCD_Init 
    EXTERN  LCD_cmd
    EXTERN  LCD_data
    EXTERN  LCD_Putc    
    EXTERN  LCD_GotoXY
    
    
    UDATA
W_TEMP          res 1
STATUS_TEMP     res 1    
    
    
MAIN    code    0x000
    goto Inicio
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
INTERR  code    0x004
; salva contexto atual
    BANKSEL W_TEMP
    movwf   W_TEMP
    swapf   STATUS,W
    
    BANKSEL STATUS_TEMP
    movwf   STATUS_TEMP

; ISR
; Rotina de tratamento de interrupção
    btfsc   INTCON, T0IF    ; testa flag de sinalização de interrupção do timer 0
    call    TrataTimer0;

;   recupera contexto anterior
    BANKSEL STATUS_TEMP
    SWAPF   STATUS_TEMP,W
    MOVWF   STATUS
    
    BANKSEL W_TEMP
    SWAPF   W_TEMP,F
    SWAPF   W_TEMP,W
    RETFIE;    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
Inicio:

    ;call    InitTimer0
    ;call    Init7SEG
    call    LCD_Init
    
loop_princ:
    call    Delay_500ms;
    
    movlw   1
    call    LCD_cmd
    
    BANKSEL iSecCounter
    movfw   iSecCounter
    
;    call    Refresh7SEG

    movlw   0x80
    call    LCD_cmd
    
    movlw   'A'
    call    LCD_Putc
    
    goto    loop_princ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        

    END