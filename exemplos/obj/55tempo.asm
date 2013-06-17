;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PICmicro PIC1655. This file contains the        *
;   basic code building blocks to build upon.  As a project minimum   *
;   the 16c55.lkr file will also be required for this file to         *
;   correctly build. The .lkr files are located in the MPLAB          *  
;   directory.                                                        *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler and linker (Document DS33014F).         *
;                                                                     *
;   Refer to the respective PICmicro data sheet for additional        *
;   information on the instruction set.                               *
;                                                                     *
;   Template file built using MPLAB V3.99.18 with MPASM V2.15.06 and  *
;   MPLINK 1.10.11 as the language tools.                             *
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

	list      p=16c55             ; list directive to define processor
	#include <p16c5x.inc>         ; processor specific variable definitions

	__CONFIG   _CP_OFF & _WDT_ON & _RC_OSC

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file. 
; See respective data sheet for additional information on configuration word.




;***** VARIABLE DEFINITIONS
TEMP_VAR    UDATA
temp        RES     1             ;example variable definition






;**********************************************************************
RESET_VECTOR   CODE   0x1FF       ; processor reset vector
		goto    start

MAIN    CODE    0x000
start	
        nop                       ; example code
        movlw   0xFF              ; example code
        movwf   temp              ; example code

; remaining code goes here





		END                       ; directive 'end of program'

