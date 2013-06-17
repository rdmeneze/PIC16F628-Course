

	#include "defs.inc"
	#include "macros.inc"
	
    GLOBAL InitSerialPort
    GLOBAL TrataIntSerialPort
    
;--------------------------------------    
BUFFER_TAM  EQU 8        
;--------------------------------------    
    UDATA
bCheckSum           res 1
cSerialBuffer       res BUFFER_TAM
cContSerialBuf      res 1
cEstado             res 1
cFlagsSerial        res 1
cDado               res 1
;--------------------------------------        

    CODE
    
;------------------------------------------

InitSerialPort:
    ;   configura porta serial com 
    ;   comunicação em 8 bits, 
    ;   dois bits de parada e 
    ;   baudrate de 9600bps
    BANKSEL TXSTA
    movlw   0x04
    movwf   TXSTA

    movlw   25
    movwf   SPBRG

    BANKSEL RCSTA
    movlw   0x90
    movwf   RCSTA 
    
    BANKSEL bCheckSum
    clrf    bCheckSum
    
    BANKSEL cContSerialBuf
    clrf    cContSerialBuf
    
    BANKSEL cFlagsSerial  
    clrf    cFlagsSerial  
       
    return;

;------------------------------------------

TrataIntSerialPort:
    ; verificar se tem 
    ;   erros na comunicação...  Ainda não!

    BANKSEL RCREG
    movf    RCREG,W
    movwf   cDado
    
    BANKSEL cEstado
    movf    cEstado,W
    btfsc   STATUS,Z
    goto    ESTADO_0

    xorlw   0x01
    btfsc   STATUS,Z
    goto    ESTADO_1

    movf    cEstado,W
    xorlw   0x02
    btfsc   STATUS,Z
    goto    ESTADO_2

    movf    cEstado,W
    xorlw   0x03
    btfsc   STATUS,Z
    goto    ESTADO_3

    movf    cEstado,W
    xorlw   0x04
    btfsc   STATUS,Z
    goto    ESTADO_4

    movf    cEstado,W
    xorlw   0x05
    btfsc   STATUS,Z
    goto    ESTADO_5
    goto    ESTADO_ERRO    
    
ESTADO_0:
    CJNE    cDado, 0x02, ESTADO_ERRO    
    
    BANKSEL bCheckSum
    clrf    bCheckSum
    
    BANKSEL cEstado
    movlw   1
    movwf   cEstado
    
    BANKSEL cContSerialBuf       
    clrf    cContSerialBuf       
    
    goto    ESTADO_SAI
    
ESTADO_1:
ESTADO_2:    
ESTADO_3:    
    BANKISEL    cSerialBuffer
    movlw       cSerialBuffer
    
    BANKSEL     cContSerialBuf
    addwf       cContSerialBuf, W
    movwf       FSR
    
    BANKSEL     cDado
    movf        cDado, W
    movwf       INDF
    
    BANKSEL     cContSerialBuf
    incf        cContSerialBuf,W
    
    BANKSEL     bCheckSum
    movf        bCheckSum,W
    BANKSEL     cDado
    xorwf       cDado,W
    BANKSEL     bCheckSum
    movwf       bCheckSum
    
    BANKSEL     cEstado
    incf        cEstado,W
    
        
    goto ESTADO_SAI

ESTADO_4:  
    CFJEQ   cDado, bCheckSum, ESTADO_ERRO
    BANKSEL cEstado
    incf    cEstado,F
    goto    ESTADO_SAI

ESTADO_5: 



ESTADO_ERRO:    
    BANKSEL cEstado
    clrf    cEstado
    BANKSEL cContSerialBuf
    clrf    cContSerialBuf
    
ESTADO_SAI:    
    return;
    
;------------------------------------------
    
    END;