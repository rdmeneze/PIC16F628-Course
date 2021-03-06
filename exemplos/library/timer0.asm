;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   
;   Biblioteca opera��o com timer 0
;   @Author  :  Rafael Dias Menezes
;   @Data    :  Jul/2009
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    #include <defs.inc>
    
TMR0_REL    EQU -(250-1)
;TMR0_REL    EQU -(3-1)

INIT_SEC_COUNT  EQU 10
_ONESEC					EQU	250
    
	GLOBAL	InitTimer0, TrataTimer0
	GLOBAL  iSecCounter
	
	UDATA
iEvntCounter    res 2           ; contador de eventos do timer0. Dever� contar de 1 at� 1000 para dar 1 segundo
iSecCounter     res 1           ; contador para aparecer no display

    CODE
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   InitTimer0:
;   Inicializa o timer 0 para interrup��o a cada 1ms
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InitTimer0:
    ; timer 0 inicializado como temporizador de aproximadamente 1ms.
    ; para isso devemos utilizar o m�dulo contador de 8 bits (T0) em conjunto com o prescaler.
    
    BANKSEL INTCON
    bcf     INTCON, GIE
    
    BANKSEL iSecCounter
    movlw   INIT_SEC_COUNT
    movwf   iSecCounter
    
    BANKSEL iEvntCounter
    clrf    iEvntCounter
    clrf    iEvntCounter+1
    
    ; configura o 55663066
    BANKSEL OPTION_REG
    movlw   0x81            ; RBPU      = 1 -> sem pull-up
                            ; INTEDG    = 0 -> irrelevante
                            ; TOCS      = 0 -> fonte do clock para o timer 0 : clock intern + preescaler
                            ; TOSE      = 0 -> irrelevante
                            ; PSA       = 0 -> preescaler atribuido ao TIMER0
                            ; PS        = 1 -> preescaler de 1:4
    movwf   OPTION_REG
    
    BANKSEL TMR0            ; 
    movlw   TMR0_REL
    movwf   TMR0

    BANKSEL INTCON
    bcf     INTCON, PEIE
    bsf     INTCON, T0IE
    bsf     INTCON, GIE
    return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;]    


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;]
;
;   TrataTimer0:
;   Realiza tratamento da interrup��o do timer0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TrataTimer0:
    BANKSEL TMR0    ; recarrega timer
    movlw   TMR0_REL
    movwf   TMR0
    
    BANKSEL iEvntCounter
    incf    iEvntCounter+1,F    ; incrementa contador
    btfsc   STATUS,Z
    incf    iEvntCounter,F
    
    movlw   LOW _ONESEC            ; verifica se o contador � igual a 1000. Se for, zera, incrementa  e continua
    xorwf   iEvntCounter+1,W
    btfsc   STATUS,Z
    goto    $+2                 ; continua com a valida��o de iEvntCounter == 1000
    goto    TrataTimer0_END     ; vai para o final
    movlw   HIGH _ONESEC
    xorwf   iEvntCounter,W
    btfsc   STATUS,Z
    goto    $+2
    goto    TrataTimer0_END
    
    clrf    iEvntCounter
    clrf    iEvntCounter+1
    
    BANKSEL iSecCounter
    incf    iSecCounter,F
    movlw   100
    xorwf   iSecCounter,W
    btfsc   STATUS,Z
    clrf    iSecCounter
    
TrataTimer0_END:
    bcf   INTCON, T0IF
    return
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    

	end