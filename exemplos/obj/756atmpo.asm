;**********************************************************************
;   This file is a basic code template  for object module code        *
;   generation on the PICmicro PIC17C756A. This file contains the     *
;   basic code building blocks to build upon. As a project minimum    *
;   the 17c756.lkr file will also be required for this file to        *
;   correctly build. The .lkr files are located in the MPLAB          *  
;   directory.                                                        *
;                                                                     *
;   If interrupts are not used all code presented for that interrupt  *
;   can be removed or commented out with semicolons. Also the         *                         
;   interrupt code is structured for the microcontroller, extended    *
;   microcontroller or microprocessor modes (up to 64K words of       *
;   program memory). If only using up to 8K words of program memory   *
;   the computed long goto instructions (instructions used at the     *
;   interrupt vector location) can be replaced with a single goto     *
;   instruction.                                                      *
;                                                                     *
;   Note: While basic interrupt context save/restore code has been    *
;   provided the user must decide if there are more or less           *
;   registers to be saved. In addition the interrupt structure shown  *
;   in this template does not support reintrant interrupts.           *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler and linker (Document DS33014F).         *
;                                                                     *
;   Refer to the respective PICmicro data sheet for additional        *
;   information on the instruction set.                               *
;                                                                     *
;   Template file assembled with MPASMWIN V2.80.12                    *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:      xxx.asm                                           *
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

	list p=17c756a, f=INHX32 ;directive to define processor and file format
	#include <p17c756a.inc>	 ;processor specific variable definitions
	
	__CONFIG   _XT_OSC & _WDT_OFF & _MC_MODE & _BODEN_ON

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.




;*******    INTERRUPT CONTEXT SAVE/RESTORE VARIABLES
INT_VAR       UDATA_SHR  0x1A
TEMP_WREG       RES     1
TEMP_ALUSTA     RES     1
TEMP_BSR        RES     1
TEMP_PCLATH     RES     1




;*******    MACROS
PUSH        MACRO                 ;macro for saving registers
            movpf   WREG,TEMP_WREG
            movpf   ALUSTA,TEMP_ALUSTA
            movpf   BSR,TEMP_BSR
            movpf   PCLATH,TEMP_PCLATH
            ENDM


POP         MACRO                 ;macro for restoring registers
            movfp   TEMP_PCLATH,PCLATH
            movfp   TEMP_BSR,BSR
            movfp   TEMP_ALUSTA,ALUSTA
            movfp   TEMP_WREG,WREG
            ENDM

	


;**********************************************************************
RESET_VECTOR    CODE    0x0000
;you may want to clear PCLATH and ALUSTA registers here      
                goto   start	


;************   INT PIN INTERRUPT VECTOR
INT_VECTOR      CODE    0x0008
                PUSH              ;save specific registers
                movlw  high  intpin_isr_handler
                movwf  PCLATH
                movlw  low   intpin_isr_handler
                movwf  PCL
                       

;************   TIMER0 INTERRUPT VECTOR
TIMER0_VECTOR   CODE    0x0010
                PUSH	          ;save specific registers
                movlw  high  timer0_isr_handler
                movwf  PCLATH
                movlw  low   timer0_isr_handler
                movwf  PCL
        

;************   T0CKI PIN INTERRUPT VECTOR
T0CKI_VECTOR    CODE    0x0018
                PUSH              ;save specific registers
                movlw  high  t0cki_isr_handler
                movwf  PCLATH
                movlw  low   t0cki_isr_handler
                movwf  PCL
               

;************   PERIPHERAL INTERRUPT VECTOR
PIV_VECTOR      CODE    0x0020
                PUSH              ;save specific registers
                movlw  high  piv_isr_handler
                movwf  PCLATH
                movlw  low   piv_isr_handler
                movwf  PCL



;************************************************************************
;*****	MAIN PROGRAM *****
MAIN   CODE
start		

              NOP                 ;first line of code (example)

; main program code goes here









; *************************************************************
; ********************* INTERRUPT HANDLER ROUTINES ************
INT_ISR      CODE 
;****** INT PIN INTERRUPT SERVICE HANDLER
intpin_isr_handler

;isr code goes here


                POP               ;restore registers
                retfie            ;return from interrupt




TIMER0_ISR   CODE
;****** TIMER0 INTERRUPT SERVICE HANDLER
timer0_isr_handler

;isr code goes here

                
                POP               ;restore registers
                retfie            ;return from interrupt




TOCKI_ISR    CODE
;****** T0CKI INTERRUPT SERVICE HANDLER
t0cki_isr_handler

;isr code goes here


                POP               ;restore registers
                retfie            ;return from interrupt




PIV_ISR    CODE
;****** PERIPHERAL INTERRUPT SERVICE HANDLER
piv_isr_handler

;isr code goes here


                POP               ;restore registers
                retfie            ;return from interrupt


                END	              ;required directive
