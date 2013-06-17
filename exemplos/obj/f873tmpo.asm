;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PICmicro PIC16F873. This file contains the      *
;   basic code building blocks to build upon.  As a project minimum   *
;   the 16f873.lkr file will also be required for this file to        *
;   correctly build. The .lkr files are located in the MPLAB          *  
;   directory.                                                        *
;                                                                     *
;   If interrupts are not used all code presented between the         *
;   code section "INT_VECTOR and code section "MAIN" can be removed.  *
;   In addition the variable assignments for 'w_temp' and             *
;   'status_temp' can be removed.                                     *                         
;                                                                     *
;   If interrupts are used, as in this template file, the 16f873.lkr  *
;   file will need to be modified. Refer to the readme.tmp file for   *
;   this information.                                                 *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler and linker (Document DS33014F).         *
;                                                                     *
;   Refer to the respective PICmicro data sheet for additional        *
;   information on the instruction set.                               *
;                                                                     *
;   Template file built using MPLAB V4.00 with MPASM V2.20.00 and     *
;   MPLINK 1.20.00 as the language tools.                             *
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


	list      p=16f873            ; list directive to define processor
	#include <p16f873.inc>        ; processor specific variable definitions
	
	__CONFIG _CP_OFF & _WDT_ON & _BODEN_ON & _PWRTE_ON & _RC_OSC & _WRT_ENABLE_ON & _LVP_ON & _CPD_OFF

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.






;***** VARIABLE DEFINITIONS
w_temp        EQU     0x20        ; variable used for context saving 
status_temp   EQU     0x21        ; variable used for context saving
count         EQU     0x22        ; temporary variable






;**********************************************************************
RESET_VECTOR  CODE    0x000       ; processor reset vector
	   	movlw  high  start        ; load upper byte of 'start' label
        movwf  PCLATH             ; initialize PCLATH
        goto   start              ; go to beginning of program


INT_VECTOR   CODE    0x004        ; interrupt vector location
		movwf   w_temp            ; save off current W register contents
		movf	STATUS,w          ; move status register into W register
		bcf	    STATUS,RP0        ; ensure file register bank set to 0
		movwf	status_temp       ; save off contents of STATUS register


; isr code can go here or be located as a call subroutine elsewhere


		bcf     STATUS,RP0        ; ensure file register bank set to 0
		movf    status_temp,w     ; retrieve copy of STATUS register
		movwf	STATUS            ; restore pre-isr STATUS register contents
		swapf   w_temp,f
		swapf   w_temp,w          ; restore pre-isr W register contents
		retfie                    ; return from interrupt


MAIN    CODE
start

        nop                       ; code starts here (example)
        banksel  count            ; example
        clrf   count              ; example

; remaining code goes here






		END                       ; directive 'end of program'

