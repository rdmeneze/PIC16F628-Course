;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PICmicro PIC16F688. This file contains the      *
;   basic code building blocks to build upon.  As a project minimum   *
;   the 16F688.lkr file will also be required for this file to        *
;   correctly build. The .lkr files are located in the MPLAB          *
;   directory.                                                        *
;                                                                     *
;   If interrupts are not used all code presented between the         *
;   code section "INT_VECTOR and code section "MAIN" can be removed.  *
;   In addition the variable assignments for 'w_temp' and             *
;   'status_temp' can be removed.                                     *
;                                                                     *
;   If interrupts are used, as in this template file, the 16F688.lkr  *
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
;                    16F688.lkr                                       *
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

	list      p=16F688           	; list directive to define processor
	#include <p16F688.inc>        	; processor specific variable definitions

	errorlevel  -302              	; suppress message 302 from list file

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for additional information on configuration word settings.

	__CONFIG    _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_OFF & _FCMEN_OFF & _IESO_OFF



;***** VARIABLE DEFINITIONS (examples)

; example of using Shared Uninitialized Data Section
INT_VAR		UDATA_SHR	0x71   
w_temp		RES     1		; variable used for context saving 
status_temp	RES     1		; variable used for context saving
pclath_temp	RES	1		; variable used for context saving


;**********************************************************************
RESET_VECTOR	CODE	0x000		; processor reset vector
		goto    main            ; go to beginning of program


INT_VECTOR	CODE	0x004		; interrupt vector location
		movwf   w_temp          ; save off current W register contents
		movf	STATUS,w        ; move status register into W register
		movwf	status_temp     ; save off contents of STATUS register
		movf	PCLATH,W        ; move pclath register into W register
		movwf	pclath_temp	; save off contents of PCLATH register


; isr code can go here or be located as a call subroutine elsewhere


		movf	pclath_temp,W	; retrieve copy of PCLATH register
		movwf	PCLATH		; restore pre-isr PCLATH register contents
		movf    status_temp,W   ; retrieve copy of STATUS register
		movwf	STATUS          ; restore pre-isr STATUS register contents
		swapf   w_temp,F
		swapf   w_temp,W        ; restore pre-isr W register contents
		retfie                  ; return from interrupt


main
; remaining code goes here



; initialize eeprom locations

EE		CODE	0x2100
		DE	0x00, 0x01, 0x02, 0x03


		END                       ; directive 'end of program'

