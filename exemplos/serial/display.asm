;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   
;   Biblioteca de controle de display 7 segmentos
;   @Author  :  Rafael Dias Menezes
;   @Data    :  Jul/2009
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    #include <defs.inc>

    GLOBAL  Refresh7SEG
    GLOBAL  Init7SEG
    EXTERN  Int2BCD
    

    UDATA_OVR
RF_TMP      res 1
TMP1        res 1

    CODE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   Init7SEG:
;   Inicializa o portB para trabalhar com o display de 7 segmentos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Init7SEG:
    BANKSEL TRISB
    movlw   b'00000110' ; -> vide esquemático
    movwf   TRISB
    BANKSEL PORTB
    movlw   b'00001001'
    movwf   PORTB
    return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   Refresh7SEG:
;   Mostra no display de 7 segmentos um número de 0-99
;   \param  WORK_REG valor a ser mostrado   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Refresh7SEG:
    call    Int2BCD     ; converte o número inteiro presente no acumulador em seu correspondente BCD
    BANKSEL RF_TMP
    movwf   RF_TMP
    
    BANKSEL TMP1
    movwf   TMP1
    
    ; agora devo carregar o valor do acumulador, deslocar quatro vezes e jogar no portb
    swapf   TMP1,F
    movlw   0xF0
    andwf   TMP1,F
    
    ; movimenta os bits no nibble superior, para o inferior, trocando a ordem : 4->3, 5->2, 6->1, 7->0
    ; Qual é o motivo disso???  Veja com o lazarento que projetou a placa.
    btfsc   TMP1,4
    bsf     TMP1,3
    btfsc   TMP1,5    
    bsf     TMP1,2
    btfsc   TMP1,6    
    bsf     TMP1,1
    btfsc   TMP1,7    
    bsf     TMP1,0
    swapf   TMP1,F
    movlw   0xF0
    andwf   TMP1,F
    
    movlw   b'00001001' ; lembre-se que o LE é ativo em ZERO
    iorwf   TMP1,F
    movf   TMP1,W
    
    BANKSEL PORTB
    movwf   PORTB
    
    nop
    nop
    nop
    nop
    bcf     PORTB,3
    
    nop
    nop
    nop
    nop
    bsf     PORTB,3
    
    BANKSEL RF_TMP
    movf    RF_TMP,W
    
    BANKSEL TMP1
    movwf   TMP1
    
    ; agora devo carregar o valor do acumulador, deslocar quatro vezes e jogar no portb
    ;swapf   TMP1,F
    movlw   0xF0
    andwf   TMP1,F
    
    ; movimenta os bits no nibble superior, para o inferior, trocando a ordem : 4->3, 5->2, 6->1, 7->0
    ; Qual é o motivo disso???  Veja com o lazarento que projetou a placa.
    btfsc   TMP1,4
    bsf     TMP1,3
    btfsc   TMP1,5    
    bsf     TMP1,2
    btfsc   TMP1,6    
    bsf     TMP1,1
    btfsc   TMP1,7    
    bsf     TMP1,0
    swapf   TMP1,F
    movlw   0xF0
    andwf   TMP1,F
    
    movlw   b'00001001' ; lembre-se que o LE é ativo em ZERO
    iorwf   TMP1,F
    movf    TMP1,W
    
    BANKSEL PORTB
    movwf   PORTB
    
    nop
    nop
    nop
    nop
    bcf     PORTB,0
    
    nop
    nop
    nop
    nop
    bsf     PORTB,0    
    
    return;

    END

