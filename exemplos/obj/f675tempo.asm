;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PICmicro PIC12F675. This file contains the      *
;   basic code building blocks to build upon.  As a project minimum   *
;   the 12F675.lkr file will also be required for this file to        *
;   correctly build. The .lkr files are located in the MPLAB          *
;   directory.                                                        *
;                                                                     *
;   If interrupts are not used all code presented between the         *
;   code section "INT_VECTOR and code section "MAIN" can be removed.  *
;   In addition the variable assignments for 'w_temp' and             *
;   'status_temp' can be removed.                                     *
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
;                    12F675.lkr                                       *
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

	list      p=12f675           ; list directive to define processor
	#include <p12f675.inc>        ; processor specific variable definitions

	errorlevel  -302              ; suppress message 302 from list file

	__CONFIG   _CP_OFF & _CPD_OFF & _BODEN_OFF & _MCLRE_OFF & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT  

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for additional information on configuration word settings.



;***** VARIABLE DEFINITIONS (examples)

; example of using Shared Uninitialized Data Section
INT_VAR		UDATA_SHR	0x20   
w_temp		RES     1		; variable used for context saving 
status_temp	RES     1		; variable used for context saving


;**********************************************************************
RESET_VECTOR	CODE	0x000		; processor reset vector
		goto    main              ; go to beginning of program


INT_VECTOR	CODE	0x004		; interrupt vector location
		movwf   w_temp            ; save off current W register contents
		movf	STATUS,w          ; move status register into W register
		movwf	status_temp       ; save off contents of STATUS register


; isr code can go here or be located as a call subroutine elsewhere


		movf    status_temp,w     ; retrieve copy of STATUS register
		movwf	STATUS            ; restore pre-isr STATUS register contents
		swapf   w_temp,f
		swapf   w_temp,w          ; restore pre-isr W register contents
		retfie                    ; return from interrupt


; these first 4 instructions are not required if the internal oscillator is not used
main
		call    0x3FF             ; retrieve factory calibration value
		bsf     STATUS,RP0        ; set file register bank to 1 
		movwf   OSCCAL            ; update register with factory cal value 
		bcf     STATUS,RP0        ; set file register bank to 0


; remaining code goes here




; initialize eeprom locations

EE		CODE	0x2100
		DE	0x00, 0x01, 0x02, 0x03


		END                       ; directive 'end of program'

