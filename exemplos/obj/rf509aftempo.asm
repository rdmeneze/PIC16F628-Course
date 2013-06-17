;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PICmicro rfPIC12C509AF. This file contains the  *
;   basic code building blocks to build upon.  As a project minimum   *
;   the 12C509AF.lkr file will also be required for this file to      *
;   correctly build. The .lkr files are located in the MPLAB          *  
;   directory.                                                        *
;                                                                     *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler and linker (Document DS33014).          *
;                                                                     *
;   Refer to the respective PICmicro data sheet for additional        *
;   information on the instruction set.                               *
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

	list      p=RF509AF      ; list directive to define processor
	#include <RF509AF.inc>       ; processor specific variable definitions

	__CONFIG   _CP_OFF & _WDT_OFF & _MCLRE_OFF & _IntRC_OSC 

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.




;***** VARIABLE DEFINITIONS
TEMP_VAR      UDATA   0x07
temp          RES     1           ;example variable definition







;**********************************************************************
		CODE    0x3FF             ; processor reset vector
; Internal RC calibration value is placed at location 0x3FF by Microchip
; as a movlw k, where the k is a literal value.

MAIN    CODE                      ; coding begins here
        movwf   OSCCAL            ; update register with factory cal value 
         
        movlw   0xFF              ; example code
        banksel temp              ; ensure GPR bank is selected 
        movwf   temp              ; initialize variable "temp"

; remaining code goes here





		END                       ; directive 'end of program'

