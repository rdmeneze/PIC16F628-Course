;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   
;   Biblioteca de controle de display LCD em modo 4 bits
;   @Author  :  Rafael Dias Menezes
;   @Data    :  Ago/2009
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	#include <defs.inc>
	#include <macros.inc>
	#include <lcd_cmd.inc>
	
LCD_EN			EQU	4   ; 0 : desabilita / 1 : habilita
LCD_RW			EQU	5   ; 0 : escrita / 1 : leitura
LCD_RS			EQU	6   ; 0 : instrução / 1 : dado
LCD_PORT		EQU	PORTB
LCD_TRIS        EQU	TRISB

LCD_LINES		EQU	2
LCD_COLS		EQU	16
LCD_ADDR_L1		EQU	0x00
LCD_ADDR_L2		EQU	0x40

LCD_DDRAM           EQU 0x80
LCD_TRIS_CFG        EQU 0x00


	GLOBAL LCD_Init, LCD_Print, LCD_cmd, LCD_data, LCD_Putc, LCD_GotoXY
	
	
	EXTERN	Delay_1ms, Delay_Xms, B_REG
	
; variaveis locais
	UDATA
tmp	res 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;    macros locais  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCDStrobeEN MACRO
	nop
	bsf         LCD_PORT,LCD_EN
	nop
	nop
	bcf         LCD_PORT,LCD_EN
	nop
    ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
	
	CODE
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	LCD_cmd
;	\brief envia um comando ao LCD em modo 4 bits
;	\param	WREG comando a ser enviado ao display 
;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_cmd:
	BANKSEL	    tmp
	movwf		tmp
	
    PAGESEL     Delay_Xms
    movlw       5
    call        Delay_Xms    
	
	;primeiro devo enviar o nibble superior
	swapf		tmp,W
	andlw		0x0F
	BANKSEL	    LCD_PORT
	movwf		LCD_PORT
    LCDStrobeEN	
    
	; envio nibble inferior
	BANKSEL	    tmp
	movf		tmp,W
	andlw		0x0F
	BANKSEL	    LCD_PORT
	movwf		LCD_PORT
    LCDStrobeEN	

	return;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	LCD_data
;	\brief envia um dado ao LCD em modo 4 bits
;	\param	WREG dado a ser enviado ao display 
;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_data:
	BANKSEL	    tmp
	movwf		tmp

    PAGESEL     Delay_Xms
    movlw       5
    call        Delay_Xms    
	
	;primeiro devo enviar o nibble superior
	swapf		tmp,W
	andlw		0x0F
	BANKSEL	    LCD_PORT
	movwf		LCD_PORT
	bsf         LCD_PORT,LCD_RS
	nop
	nop
	LCDStrobeEN
	;bcf         LCD_PORT,LCD_RS
	nop
	
	; envio do nibble inferior
	BANKSEL	    tmp
	movf		tmp,W
	andlw		0x0F

	BANKSEL	    LCD_PORT
	movwf		LCD_PORT
	bsf         LCD_PORT,LCD_RS
	nop
	nop
	LCDStrobeEN
	bcf         LCD_PORT,LCD_RS

	
	return;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	LCDInit
;	\brief INicializa o display LCD em modo 4 bits
;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_Init:
    BANKSEL     LCD_TRIS
    movlw       LCD_TRIS_CFG
    movwf       LCD_TRIS
    
	BANKSEL	    LCD_PORT
	bcf			LCD_PORT, LCD_RW
	
	PAGESEL	    LCD_Reset
	call		LCD_Reset
	
    movlw       0x28            ;4-bit, 2 line, 5x7 dots
    PAGESEL     LCD_cmd
    call        LCD_cmd         ;
    
    MOVLW       0x08              ;
    PAGESEL     LCD_cmd
    call        LCD_cmd         ;

    MOVLW       0X01              ;
    PAGESEL     LCD_cmd
    call        LCD_cmd         ;

    MOVLW       0X06              ; 
    PAGESEL     LCD_cmd
    call        LCD_cmd         ;

    MOVLW       0X0C              ; 
    PAGESEL     LCD_cmd
    call        LCD_cmd         ;
	
	return	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	LCD_Reset
;	\brief Sequencia de reset do LCD
;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_Reset:
	movlw		100
	PAGESEL	    Delay_Xms
	call		Delay_Xms
	
	movlw		0x03                ; Data = 0x30, LCD_EN = 1
	BANKSEL	    LCD_PORT								
	movwf		LCD_PORT
	LCDStrobeEN
	movlw		64										; delay 15ms
	PAGESEL	    Delay_Xms
	call		Delay_Xms
	
	movlw		0x03                ; Data = 0x30, LCD_EN = 1
	BANKSEL	    LCD_PORT								
	movwf		LCD_PORT
	LCDStrobeEN
	movlw		32;5											 	; delay 5ms
	PAGESEL	    Delay_Xms
	call		Delay_Xms
	
	movlw		0x03
	BANKSEL	    LCD_PORT
	movwf		LCD_PORT
	LCDStrobeEN
	movlw		32
	PAGESEL	    Delay_Xms
	call		Delay_Xms
	
	movlw		0x02                ; seleciona largura dos dados (20H -> 4bits)
	BANKSEL	    LCD_PORT
	movwf		LCD_PORT
	LCDStrobeEN
	movlw		16
	PAGESEL	    Delay_Xms
	call		Delay_Xms
	
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	LCDprint
;	\brief Escreve um texto no display.
;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_Print:
	return	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	LCD_Putc
;	\brief envia um caracter ao display.
;	\param	W_REG	dado a ser enviado
;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_Putc:
	BANKSEL	    tmp
	movwf		tmp
	CJEQ        tmp, '\r', LCD_Putc_BRK
	goto		LCD_Putc_
LCD_Putc_BRK:
	BANKSEL	    B_REG
	movlw		1
	movwf		B_REG
	movlw		0
	PAGESEL	    LCD_GotoXY
	call		LCD_GotoXY

LCD_Putc_:
	BANKSEL	    tmp
	movf		tmp,W
	PAGESEL	    LCD_data
	call 		LCD_data
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	LCD_GotoXY
;	\brief vai a uma posição do display.
;	\param	W_REG	posisão X, B_REG posicçao Y para salto du cursor.
;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_GotoXY:
	BANKSEL     tmp
	movwf		tmp
	
	BANKSEL	    B_REG
	movf		B_REG,W
		
	btfsc		STATUS,Z
	goto		LCD_GotoXY_L1
	goto		LCD_GotoXY_L2
	
LCD_GotoXY_L1:
	BANKSEL	    tmp
	movf		tmp,W
	addlw		LCD_ADDR_L1
    goto		LCD_GotoXY_cmd
	
LCD_GotoXY_L2:
	BANKSEL	    tmp
	movf		tmp,W
	addlw		LCD_ADDR_L2
	goto		LCD_GotoXY_cmd
	
LCD_GotoXY_cmd:	
    iorlw       LCD_DDRAM
    PAGESEL	    LCD_cmd    
	call		LCD_cmd
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

	
	
	END