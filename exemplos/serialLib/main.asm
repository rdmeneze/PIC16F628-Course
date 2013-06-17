	#include "defs.inc"

    EXTERN  TrataIntSerialPort
    EXTERN  InitSerialPort

;------------------------------------------
; variáveis locais ao módulo    
    UDATA
    STATUS_TEMP     res 1
    W_TEMP          res 1     

;------------------------------------------

RESET_VEC   code 0x0000
	goto _main

;------------------------------------------
	
ISR code 0x004
    movwf W_TEMP 
    swapf STATUS,W 
    movwf STATUS_TEMP 
    ;
    ; (Interrupt Service Routine (ISR) )
    ;
    swapf STATUS_TEMP,W 
    movwf STATUS 
    swapf W_TEMP,F 
    swapf W_TEMP,W 
    
	retfie
	
;------------------------------------------

_main:

    call InitSerialPort;
    
	goto $
	
	
	
	END