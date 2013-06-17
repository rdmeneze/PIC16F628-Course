;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PICmicro PIC16F505. This file contains the      *
;   basic code building blocks to build upon.  As a project minimum   *
;   the 16F505.lkr file will also be required for this file to        *
;   correctly build. The .lkr files are located in the MPLAB          *  
;   directory.                                                        *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler and linker.                             *
;                                                                     *
;   Refer to the respective PICmicro data sheet for additional        *
;   information on the instruction set.                               *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     * 
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files required:                                                  *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************

	list      p=16F505            ; list directive to define processor
	#include <p16F505.inc>        ; processor specific variable definitions

	__CONFIG   _MCLRE_OFF & _CP_OFF & _WDT_OFF & _IntRC_OSC_RB4EN

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file. 
; See respective data sheet for additional information on configuration word.




;***** VARIABLE DEFINITIONS
TEMP_VAR    UDATA
temp        RES     1             ;example variable definition






;**********************************************************************
RESET_VECTOR	CODE   0x3FF      ; processor reset vector

; Internal RC calibration value is placed at location 0x3FF by Microchip
; as a movlw k, where the k is a literal value.
	
MAIN	CODE    0x000
	movwf   OSCCAL            ; update register with factory cal value 


start	
	nop                       ; example code
	movlw   0xFF              ; example code
	movwf   temp              ; example code

; remaining code goes here





	END                       ; directive 'end of program'

