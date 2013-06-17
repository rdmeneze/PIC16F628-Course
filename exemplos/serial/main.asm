;	
;	Programa para teste de envio e recepção de dados via porta serial do PIC 16F628A
;	Data : Ago/2009
;	Autor : rdmeneze@yahoo.com.br
;	

#include defs.inc
#include macros.inc


	__config 	_XT_OSC & _MCLRE_ON & _PWRTE_ON
	

RST_VEC   code 0x0000
	goto _main
	
	
INT_VEC  code 0x0004
	retfie
	
	
	

_main 
	movwf	0x00

	end;
