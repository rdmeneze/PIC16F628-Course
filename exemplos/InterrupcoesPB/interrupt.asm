


	#include <defs.inc>

LED_INT0    EQU 0x001




	EXTERN MAIN
	
    UDATA
W_TEMP      res 1
STATUS_TEMP res 1



	CODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
RST_VEC    code 0x000
	GOTO MAIN;
	
	
	
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
	
	
	
	END
	