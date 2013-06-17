;*****************************************************************************
;ARQUIVO FONTE CONTENDO ROTINAS DE ACESSO A UM LCD 
;CONFIGURADO PARA TRABALHAR COM 4 BITS DE DADOS
;                                                                              
; 					PIC16F628 COM LCD DE 4 BITS
;                          __________                                          
;                    -RA2 |1       18| RA1---------
;                    -RA3 |2       17| RA0---------                   
;                    -RA4 |3       16| OSC1--------CRISTAL/RESSONADOR CERÂMICO                        
;         ----------/MCLR |4       15| OSC2--------CRISTAL/RESSONADOR CERÂMICO                        
;     GROUND----------VSS |5       14| VDD--------- VCC(+5V)                        
;     LCD11(D4)-------RB0 |6       13| RB7---------                   
;     LCD12(D5)-------RB1 |7       12| RB6---------LCD_RS  (LCD PIN 4)         
;     LCD13(D6)-------RB2 |8       11| RB5---------LCD_RW  (LCD PIN 5)           
;     LCD14(D7)-------RB3 |9       10| RB4---------LCD_EN   (LCD PIN 6)         
;                          ----------                                          
;                                                                              
; ****************************************************************************
#INCLUDE<P16F628A.INC>

 __CONFIG _CP_OFF&_LVP_OFF&_BODEN_OFF&_MCLRE_ON&_PWRTE_ON&_WDT_OFF&_XT_OSC  


	EXTERN  TBL_PTR 
	EXTERN 	TBL_Read

; ****************************************************************************
LCD_BUSY EQU    3                 ; BUSY BIT (BIT D7 NA LEITURA)
LCD_EN   EQU    4                 ; 0=DISABLE(DESABILITA), 1=ENABLE(HABILITA)
LCD_RW  EQU     5                 ; 0=WRITE(ESCRITA), 1=READ(LEITURA)
LCD_RS  EQU     6                 ; 0=INSTRUCAO, 1=DADA

; ****************************************************************************
        CBLOCK  0X20              
	        LCD_CHAR                  
    	    LCD_READ                 
        	TIMER1                   
	        TIMER2                  
    	    RS_FLAG   
    	    W_TMP
        ENDC                    

; ****************************************************************************             
        ORG     0X0000                
RESET
        GOTO    START   
         
; *****************************************************************************
START
        CLRF    INTCON            
        MOVLW   0X07              
        MOVWF   CMCON             
        BSF     STATUS,RP0      
        MOVLW   0XFF              
        MOVWF   TRISA             
        CLRF    TRISB             
        BCF     STATUS,RP0      
        CALL    INIT_LCD

; *****************************************************************************
PRINCIPAL     
		;CALL	WRITE_MENU_LINE1
		;CALL	WAIT_256MS
		;CALL	WRITE_MENU_LINE2
		;CALL	WAIT_256MS
		movlw	0x80
		CALL	CMD_LCD
		
		BANKSEL W_TMP
		CLRF	W_TMP
STR_LOOP:
	    BANKSEL TBL_PTR
	    MOVLW   HIGH (MSG_TESTE1)
	    MOVWF   TBL_PTR
	    MOVLW   LOW (MSG_TESTE1)
	    MOVWF   TBL_PTR+1
	    BANKSEL W_TMP
	    MOVF    W_TMP,W 
	    CALL    TBL_Read
	    XORLW   0        ; é final de string?
	    BTFSS   STATUS,Z		
	    GOTO    MSG_TESTE_NEXT
	    GOTO    MSG_TESTE_END
    
MSG_TESTE_NEXT:
		call	DATA_LCD
	    BANKSEL W_TMP
	    INCF    W_TMP,F
	    CALL    WAIT_256MS
	    GOTO    STR_LOOP
    
MSG_TESTE_END:
	    
		
		
		MOVLW	0X01
		CALL	CMD_LCD
		CALL	WAIT_256MS
		GOTO	PRINCIPAL

; *****************************************************************************
; ROTINAS PARA TRABALHAR COM O LCD CONFIGURADO PARA 4 BITS
; *****************************************************************************
; RESUMO DO COMPORTAMENTO DO LCD
;	RS	R//W	Função
;	0	0		Escrita no LCD
;	0	1		Leitura do bit D7 (Busy Flag): busy(ocupado)=1
;	1	0		Escrita na DDRAM ou CGRAM
;	1	1		Leitura da DDRAM ou CGRAM
;
;	EN		Função
;	L>H		Habilita LCD (transição de nível lógico baixo para alto)
; *****************************************************************************
;INIT_LCD
;TRANSFERE PARA O LCD AS CONDIÇOES DE INICIALIZAÇAO 
;LOGO AO LIGAR/RESETAR O MICROCONTROLADOR
INIT_LCD
        CALL    WAIT_64MS         ;
        MOVLW   0X03              ;               
        MOVWF   PORTB             ;                 
        BSF     PORTB,LCD_EN       ;
        BCF     PORTB,LCD_EN       ;
        CALL    WAIT_64MS         ; 
        
        MOVLW   0X03              ;            
        MOVWF   PORTB             ;               
        BSF     PORTB,LCD_EN       ; 
        BCF     PORTB,LCD_EN       ;  
        CALL    WAIT_32MS         ;   
        
        MOVLW   0X03              ;            
        MOVWF   PORTB             ;             
        BSF     PORTB,LCD_EN       ;
        BCF     PORTB,LCD_EN       ; 
        CALL    WAIT_32MS         ; 
        
        MOVLW   0X02              ;          
        MOVWF   PORTB             ;                 
        BSF     PORTB,LCD_EN       ; 
        BCF     PORTB,LCD_EN       ;  
        CALL    WAIT_16MS         ;   
        
        MOVLW   0X28              ;
        CALL    CMD_LCD          ; 
        MOVLW   0X08              ;
        CALL    CMD_LCD          ;
        MOVLW   0X01              ;
        CALL    CMD_LCD          ;
        MOVLW   0X06              ; 
        CALL    CMD_LCD          ;
        MOVLW   0X0C              ; 
        CALL    CMD_LCD          ;
        RETURN                    ; 

; *****************************************************************************
;BUSY_CHECK
;VERIFICA SE B.F (BUSY FLAG) QUE INDICA SE O LCD
;ESTÁ OU NAO PRONTO PARA RECEBER NOVO DADO/COMANDO
;PARA ISSO O BIT DB7 DO LCD ESTÁ LIGADO AO RB3 DO PIC
BUSY_CHECK
        CLRF    PORTB             ; 
        BSF     STATUS,RP0        ;BANK1 
        MOVLW   B'00001000'       ;RB3 PARA ENTRADA (BUSY FLAG)
        MOVWF   TRISB             ; 
        BCF     STATUS,RP0        ;BANK0 
        BCF     PORTB,LCD_EN      ;DESABILITA LCD (EN=0)
        BCF     PORTB,LCD_RS      ;HABILITA LEITURA DO LCD(RS = 0) 
        BSF     PORTB,LCD_RW      ;HABILITA LEITURA DO LCD (RW = 1)  
LCD_IS_BUSY
        BSF     PORTB,LCD_EN      ;HABILITA LCD (EN=1)
        MOVF    PORTB,W           ;LE PORTB
        MOVWF   LCD_READ          ;GUARDA EM "LCD_READ" PARA POSTERIOR USO
        BCF     PORTB,LCD_EN      ;DESABILITA LCD (EN=0)
		CALL	WAIT_4MS
        BTFSC   LCD_READ,LCD_BUSY ;TESTA SE B.F =0
        GOTO    LCD_IS_BUSY       ;SE B.F=1 LCD VOLTA PARA TESTAR NOVAMENTE O BIT
NOT_BUSY
        RETURN                    ; 

; *****************************************************************************
;CMD_LCD
;ENTRADA EM "W" PARA O COMANDO QUE SERÁ ENVIADO AO LCD
;VERIFICAR TABELA DE COMANDOS
CMD_LCD 
        MOVWF   LCD_CHAR         ;GUARDA COMANDO EM UM BUFFER
        CLRF    RS_FLAG          ;ZERA REGISTRADOR RS_FLAG
        BCF     PORTB,LCD_RS      ;RS=0
        GOTO    WRITE_LCD         ;ESCREVE NO LCD

; *****************************************************************************
;DATA_LCD  
;;ENTRADA EM "W" QUE SERÁ O CARACTERE ENVIADO AO LCD
DATA_LCD  
        MOVWF   LCD_CHAR          ;
        BSF     RS_FLAG,0        ; 
        BSF     PORTB,LCD_RS      ;
WRITE_LCD
        CALL    BUSY_CHECK        ; 
        CLRF    PORTB             ; 
        BSF     STATUS,RP0      ; 
        MOVLW   0X00              ; 
        MOVWF   TRISB             ; 
        BCF     STATUS,RP0      ; 
        BCF     PORTB,LCD_RW      ; 
        BCF     PORTB,LCD_RS      ;        
        BTFSC   RS_FLAG,0        ; 
        BSF     PORTB,LCD_RS      ;                   
;TRANSFERE 4 BITS MSB PARA O LCD
        MOVLW   0XF0              ;                                    
        ANDWF   PORTB,F           ;      
        SWAPF   LCD_CHAR,W        ;         
        ANDLW   0X0F              ;           
        IORWF   PORTB,F           ;      
        BSF     PORTB,LCD_EN       ; 
        NOP                       ;  
        BCF     PORTB,LCD_EN       ;  
;TRANSFERE 4 BITS LSB PARA O LCD
        MOVLW   0XF0              ;                                     
        ANDWF   PORTB,F           ;                    
        MOVF    LCD_CHAR,W        ;                
        ANDLW   0X0F              ;                
        IORWF   PORTB,F           ;       
        BSF     PORTB,LCD_EN       ; 
        NOP                       ;  
        BCF     PORTB,LCD_EN       ;  
        RETURN

; *****************************************************************************
;WRITE_MENU_LINE1
;CONTEM OS CARACTERES QUE SERÃO MOSTRADOS NA PRIMEIRA LINHA DO LCD
WRITE_MENU_LINE1
        MOVLW   0X80              ;POSICIONO PARA PRIMEIRA LINHA
        CALL    CMD_LCD          ;

        MOVLW   '*'               ;               
        CALL    DATA_LCD          ;
        MOVLW   'S'               ;               
        CALL    DATA_LCD          ;
        MOVLW   'E'               ;                   
        CALL    DATA_LCD          ;
        MOVLW   'N'               ;                 
        CALL    DATA_LCD          ;
        MOVLW   'A'               ;                
        CALL    DATA_LCD          ;
        MOVLW   'I'               ;                
        CALL    DATA_LCD          ;
        MOVLW   ' '               ;               
        CALL    DATA_LCD          ;
        MOVLW   'A'               ;               
        CALL    DATA_LCD          ;        
        MOVLW   'N'               ;               
        CALL    DATA_LCD          ;
        MOVLW   'C'               ;                
        CALL    DATA_LCD          ;
        MOVLW   'H'               ;              
        CALL    DATA_LCD          ;
        MOVLW   'I'               ;               
        CALL    DATA_LCD          ;
        MOVLW   'E'               ;               
        CALL    DATA_LCD          ;
        MOVLW   'T'               ; 
        CALL    DATA_LCD          ;
        MOVLW   'A'               ; 
        CALL    DATA_LCD          ;
        MOVLW   '*'               ; 
        CALL    DATA_LCD          ;
		RETURN
		
; *****************************************************************************
;WRITE_MENU_LINE2
;CONTEM OS CARACTERES QUE SERÃO MOSTRADOS NA SEGUNDA LINHA DO LCD
WRITE_MENU_LINE2
        MOVLW   0XC3              ;POSICIONO PARA SEGUNDA LINHA
        CALL    CMD_LCD          ;

        MOVLW   '*'               ;               
        CALL    DATA_LCD          ;
		CALL	WAIT_128MS
        MOVLW   'P'               ;               
        CALL    DATA_LCD          ;
		CALL	WAIT_128MS
        MOVLW   'I'               ;                   
        CALL    DATA_LCD          ;
		CALL	WAIT_128MS
        MOVLW   'C'               ;                 
        CALL    DATA_LCD          ;
		CALL	WAIT_128MS
        MOVLW   '1'               ;                
        CALL    DATA_LCD          ;
		CALL	WAIT_128MS
        MOVLW   '6'               ;                
        CALL    DATA_LCD          ;
		CALL	WAIT_128MS
        MOVLW   'F'               ;               
        CALL    DATA_LCD          ;
		CALL	WAIT_128MS
        MOVLW   '6'               ;               
        CALL    DATA_LCD          ;        
		CALL	WAIT_128MS
        MOVLW   '2'               ;               
        CALL    DATA_LCD          ;
		CALL	WAIT_128MS
        MOVLW   '8'               ;                
        CALL    DATA_LCD          ;
		CALL	WAIT_128MS
        MOVLW   '*'               ; 
        CALL    DATA_LCD          ;
		CALL	WAIT_128MS
		RETURN


; *****************************************************************************
;DELAY
;DIVERSAS SUB ROTINAS DE TEMPORIZAÇÃO POR SOFTWARE
WAIT_A_SEC  ;      
        CALL    WAIT_256MS        ;       
        CALL    WAIT_256MS        ;       
        CALL    WAIT_256MS        ;       
        CALL    WAIT_256MS        ;       
        RETURN
WAIT_HALF_SEC  ;      
        CALL    WAIT_256MS        ;       
        CALL    WAIT_256MS        ;       
WAIT_256MS  ;      
        CALL    WAIT_128MS        ;
        CALL    WAIT_128MS        ;
        RETURN
WAIT_128MS  ;      
        MOVLW   0XFF              ;  
        MOVWF   TIMER1            ;  
        GOTO    OUTER_LOOP        ; 
WAIT_64MS  ;       
        MOVLW   0X80              ;
        GOTO    OUTER_LOOP        ;
WAIT_32MS   ;      
        MOVLW   0X40              ; 
        MOVWF   TIMER1            ;  
        GOTO    OUTER_LOOP        ; 
WAIT_16MS   ;      
        MOVLW   0X20              
        MOVWF   TIMER1            ;  
        GOTO    OUTER_LOOP        ; 
WAIT_8MS   ;       
        MOVLW   0X10              ; 
        MOVWF   TIMER1            ;  
        GOTO    OUTER_LOOP        ;
WAIT_4MS   ;       
        MOVLW   0X8               ; 
        MOVWF   TIMER1            ;  
        GOTO    OUTER_LOOP        ;

WAIT_5US    ;       
        NOP
        RETURN
WAIT_10US   ;       
        CALL     WAIT_5US
        NOP
        RETURN
WAIT_25US   ;       
        CALL     WAIT_10US
        CALL     WAIT_10US
        NOP
        RETURN
WAIT_50US   ;       
        MOVLW    13              
        MOVWF    TIMER2
        MOVLW    1
        MOVWF    TIMER1
        GOTO     INNER_LOOP
WAIT_100US   ;       
        NOP
        NOP
        MOVLW    29
        MOVWF    TIMER2
        MOVLW    1
        MOVWF    TIMER1
        GOTO     INNER_LOOP
WAIT_200US   ;       
        MOVLW    63
        MOVWF    TIMER2
        MOVLW    1
        MOVWF    TIMER1
        GOTO     INNER_LOOP
WAIT_500US   ;       
        MOVLW    163
        MOVWF    TIMER2
        MOVLW    1
        MOVWF    TIMER1
        GOTO     INNER_LOOP
WAIT_1MS   ;       
        CALL     WAIT_500US
        MOVLW    162
        MOVWF    TIMER2
        CALL     WAIT_XUS
        RETURN   
WAIT_2MS   ;       
        CALL     WAIT_1MS
        CALL     WAIT_500US
        MOVLW    161
        MOVWF    TIMER2
        CALL     WAIT_XUS
        RETURN   
; TEMPO É ((TIMER2-1)*3)  (779US MAX QUANDO TIMER2 = 0) 
WAIT_XUS   ;                             
        MOVLW    1
        MOVWF    TIMER1
        GOTO     INNER_LOOP
;
OUTER_LOOP                        
        MOVLW   0XFF               
        MOVWF   TIMER2              
INNER_LOOP
        DECFSZ  TIMER2,F         
        GOTO    INNER_LOOP         
                                 
        DECFSZ  TIMER1,F         
        GOTO    OUTER_LOOP       
                                 
        RETURN                  

; *****************************************************************************
;



;
;
;
MSG_TESTE:	DT "abcdefghijklmn"0
MSG_TESTE1:	DT "teste1"0

        END

