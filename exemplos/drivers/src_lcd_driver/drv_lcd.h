/***************************************************
* Module name: 
*	port_drv_lcd.h	
* 
* License information... 
*
* Author: Sergio Prado (sergiosiena@gmail.com)
* Date: 10/2007
*
* Module Description:
* 	Include file for LCD Display Driver.
*
***************************************************/
#ifndef __DRV_LCD_H
#define __DRV_LCD_H


/***************************************************
*	Include section
***************************************************/
#include "port_drv_lcd.h"
#include "arch.h"


/***************************************************
*	Defines section 
***************************************************/

/* module version */
#define MODULE_VERSION 	"1.0.00"

/* Display ON/OFF Control defines */
#define DON         0b00001100  
#define DOFF        0b00001011  
#define CURSOR_ON   0b00001010  
#define CURSOR_OFF  0b00001101  
#define BLINK_ON    0b00001001  
#define BLINK_OFF   0b00001110  

// Cursor or Display Shift defines
#define SHIFT_CUR_LEFT    0b00010011
#define SHIFT_CUR_RIGHT   0b00010111
#define SHIFT_DISP_LEFT   0b00011011
#define SHIFT_DISP_RIGHT  0b00011111

// Function Set defines 
#define FOUR_BIT   0b00101111
#define EIGHT_BIT  0b00111111

/* commands for display initialization and configuration */
#define INIT_CMD		0x30
#define FUNCTION_SET	EIGHT_BIT
#define DISPLAY_OFF		(DOFF & CURSOR_OFF & BLINK_OFF)
#define DISPLAY_ON		(DON | CURSOR_ON | BLINK_ON)
#define CURSOR_DIR		0x06
#define CLEAR_DISPLAY	0x01
#define SET_DDRAM_ADDR	0x80

/* write types */
#define LCD_WR_DATA		1
#define LCD_WR_COMMAND	2

/* on/off functions */
#define LCD_ON	1
#define LCD_OFF	0


/***************************************************
*	Function Prototype Section
***************************************************/
void el_lcd_init();
void el_lcd_print(string *str);
byte el_lcd_gotoxy(byte line, byte collum);
void el_lcd_clear();
byte el_lcd_cursor(byte cursor, byte blink);


#endif
