; 
;	delay.asm
;	Modulo para implementação de funções para delay de tempo
;
    

    LIST p=16f628A
    RADIX dec
    #include p16f628a.inc
    
    GLOBAL delay1ms
    
    
    UDATA_OVR
i RES 1
j RES 1
    
    CODE
delay1ms:
    NOP;
    
    MOVLW 100
    BANKSEL i
    MOVWF   i
    MOVLW   200
    BANKSEL j
    MOVLW   j
    
    DECFSZ  j, F
    GOTO    $-1
    
    BANKSEL i
    DECFSZ  i, F
    GOTO    $-5
    RETURN;


    END