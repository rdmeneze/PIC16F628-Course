;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   
;   Biblioteca de funções de manipulação de string
;   @Author  :  Rafael Dias Menezes
;   @Data    :  Jul/2009
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	#include <defs.inc>


	EXTERN 	TBL_PTR, TBL_Read, END_CSTR
	
	UDATA
STR_PTR 		res 2

	UDATA_SHR
STR_COUNT		res 1
W_TMP				res	1
	
	GLOBAL	STR_Len, STR_PTR

	CODE
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
;   STR_Len
;   \brief  calcula o tamanho de uma string armazenada em ROM
;		\param	STR_PTR ponteiro para a string a ser determinada o tamanho
;   \return WREG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
STR_Len:
	BANKSEL	STR_COUNT
	clrf		STR_COUNT
		
STR_LEN_L1:
	BANKSEL	STR_PTR
	movf		STR_PTR,W
	BANKSEL	TBL_PTR
	movwf		TBL_PTR
	
	BANKSEL	STR_PTR+1
	movf		STR_PTR+1,W
	BANKSEL	TBL_PTR+1
	movwf		TBL_PTR+1
	
	BANKSEL	STR_COUNT
	movf		STR_COUNT,W
	
	PAGESEL	TBL_Read
	call		TBL_Read
	
	xorlw		END_CSTR
	btfsc		STATUS,Z
	goto		STR_LEN_END
	
	BANKSEL	STR_COUNT
	incf		STR_COUNT,F
	movf		STR_COUNT,W	
	goto 		STR_LEN_L1
	
STR_LEN_END:
	BANKSEL	STR_COUNT
	movf		STR_COUNT,W
	return;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    	
	
	

	END