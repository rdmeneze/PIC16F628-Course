;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PICmicro PIC16F716. This file contains the      *
;   basic code building blocks to build upon.  As a project minimum   *
;   the 16F716.lkr file will also be required for this file to        *
;   correctly build. The .lkr files are located in the MPLAB          *
;   directory.                                                        *
;                                                                     *
;   If interrupts are not used all code presented between the         *
;   code section "INT_VECTOR and code section "MAIN" can be removed.  *
;   In addition the variable assignments for 'w_temp' and             *
;   'status_temp' can be removed.                                     *
;                                                                     *
;   If interrupts are used, as in this template file, the 16F716.lkr  *
;   file will need to be modified as follows: Remove the lines        *
;     CODEPAGE   NAME=vectors  START=0x0      END=0x4      PROTECTED  *
;   and                                                               *
;     SECTION    NAME=STARTUP  ROM=vectors                            *
;   and change the start address of the page0 section from 0x5 to 0x0 *
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
;                    16F716.lkr                                       *
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

	list      p=16F716           	; list directive to define processor
	#include <p16F716.inc>        	; processor specific variable definitions

	errorlevel  -302              	; suppress message 302 from list file

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for additional information on configuration word settings.

	__CONFIG    _CP_OFF & _VBOR_25 & _BOREN_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC


;***** VARIABLE DEFINITIONS (examples)

; example of using Shared Uninitialized Data Section
INT_VAR		UDATA	0x20   
w_temp		RES     1		; variable used for context saving 
status_temp	RES     1		; variable used for context saving

INT_VAR1	UDATA	0xA0		
w1_temp		RES	1		;bank 1 w_temp register

;**********************************************************************
RESET_VECTOR	CODE	0x000		; processor reset vector
		goto    main            ; go to beginning of program


INT_VECTOR	CODE	0x004		; interrupt vector location
		movwf   w_temp          ; save off current W register contents
		movf	STATUS,w        ; move status register into W register
		bcf	STATUS,RP0	; select bank0
		movwf	status_temp     ; save off contents of STATUS register

; isr code can go here or be located as a call subroutine elsewhere


		bcf	STATUS,RP0	; select bank0
		movf    status_temp,W   ; retrieve copy of STATUS register
		movwf	STATUS          ; restore pre-isr STATUS register contents
		swapf   w_temp,F
		swapf   w_temp,W        ; restore pre-isr W register contents
		retfie                  ; return from interrupt


main
; remaining code goes here



		END                     ; directive 'end of program'

