/***************************************************
* Module name: 
*	port_drv_lcd.h	
* 
* License information... 
*
* Author: Sergio Prado (sergiosiena@gmail.com)
* date: 10/2007
*
* Module Description:
* 	Port file for LCD Display Driver.
*
***************************************************/
#ifndef __PORT_DRV_LCD_H
#define __PORT_DRV_LCD_H


/***************************************************
*	Include section
***************************************************/

/* include here your specific plataform files */
#include "p18f452.h"

/* include here your compiler specifics files */
#include "delays.h"


/***************************************************
*	Defines section
***************************************************/

/* display information */
#define NUMBER_OF_LINES 	4
#define NUMBER_OF_COLLUMS	16

/* DDRAM addresses */
#define LINE1_DDRAM_ADDR	0x00
#define LINE2_DDRAM_ADDR	0x40
#define LINE3_DDRAM_ADDR	0x10
#define LINE4_DDRAM_ADDR	0x50

/* Define your interface type: 8-bit or 4-bit */
#define BIT8	1

/* When in 4-bit interface define if the data is in the upper
 * or lower nibble. */  
#define UPPER	0
#define LOWER	0

/* define if the hardware has support to read the display */
#define READ_ENABLED	0

/* Define the port to which the LCD data lines are connected */
#define DATA_PORT      PORTD
#define TRIS_DATA_PORT TRISD

/* Define the port/mask where ENABLE pin are connected */
#define E_PIN		PORTE
#define TRIS_E		TRISE
#define ENABLE_E	0b00000010
#define DISABLE_E	0b11111101

/* Define the port/mask where RS pin are connected */
#define RS_PIN		TRISE
#define TRIS_RS		TRISE
#define ENABLE_RS	0b00000100
#define DISABLE_RS	0b11111011

/* Define the port/mask where RW pin are connected */
#if READ_ENABLED == 1
#define RW_PIN		PORTE
#define TRIS_RW		TRISE
#define ENABLE_RW	0b00000001
#define DISABLE_RW	0b11111110
#endif


/***************************************************
*	Macro Section
***************************************************/

/* clock data/command to display */
#define CLOCK() E_PIN |= ENABLE_E; DELAYMS(1); E_PIN &= DISABLE_E; DELAYMS(1)

/* clear pins */
#define CLEAR_E()	E_PIN  &= DISABLE_E
#define CLEAR_RS()	RS_PIN &= DISABLE_RS
#if READ_ENABLED == 1
#define CLEAR_RW()	RW_PIN &= DISABLE_RW
#else
#define CLEAR_RW()	
#endif

/* set pins */
#define SET_E()		E_PIN  |= ENABLE_E
#define SET_RS()	RS_PIN |= ENABLE_RS
#if READ_ENABLED == 1
#define SET_RW()	RW_PIN |= ENABLE_RW
#else
#define SET_RW()		
#endif

/* configure pins as inputs */
#define CFG_IN_DATA()	TRIS_DATA_PORT = 0xff
#define CFG_IN_RS()		TRIS_RS |= ENABLE_RS
#define CFG_IN_E()		TRIS_E  |= ENABLE_E
#if READ_ENABLED == 1
#define CFG_IN_RW()		TRIS_RW |= ENABLE_RW
#else
#define CFG_IN_RW()		
#endif

/* configure pins as outputs */
#define CFG_OUT_DATA()	TRIS_DATA_PORT = 0
#define CFG_OUT_RS()	TRIS_RS &= DISABLE_RS	
#define CFG_OUT_E()		TRIS_E  &= DISABLE_E
#if READ_ENABLED == 1
#define CFG_OUT_RW()	TRIS_RW &= DISABLE_RW
#else
#define CFG_OUT_RW()	
#endif

/* delay in microseconds */
#define DELAYMS(x) lcd_delayms(x)

/* delay in seconds */
#define DELAY(x) lcd_delay(x)


/***************************************************
*	Function Prototype Section
***************************************************/
void lcd_delay(char seconds);
void lcd_delayms(char mseconds);


#endif
