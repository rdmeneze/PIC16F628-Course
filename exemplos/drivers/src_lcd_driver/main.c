/***************************************************
* Module name: 
*	main.c	
* 
* License information... 
*
* Author: Sergio Prado (sergiosiena@gmail.com)
* date: 10/2007
*
* Module Description:
* 	Example project for LCD Display Driver.
*
***************************************************/


/***************************************************
*	Include section
***************************************************/
#include "drv_lcd.h"
#include "p18f452.h"


/**************************************************
* Description:
* 	Main() function
* 
* Parameters:
* 	none
* 
* Return:
* 	none
* 
* Comments:
* 
**************************************************/
void main()
{
	// init display
	el_lcd_init();
	
	while (1) {
		
		// message in line 1
		el_lcd_clear();
		el_lcd_gotoxy(1, 1);
		el_lcd_cursor(LCD_ON, LCD_ON);
		el_lcd_print("Line 1");
		lcd_delay(2);
		
		// message in line 2
		el_lcd_clear();
		el_lcd_gotoxy(2, 2);
		el_lcd_cursor(LCD_ON, LCD_OFF);
		el_lcd_print("Line 2");
		lcd_delay(2);
		
		// message in line 3
		el_lcd_clear();
		el_lcd_gotoxy(3, 3);
		el_lcd_cursor(LCD_OFF, LCD_ON);
		el_lcd_print("Line 3");
		lcd_delay(2);
		
		// message in line 4
		el_lcd_clear();
		el_lcd_gotoxy(4, 4);
		el_lcd_cursor(LCD_OFF, LCD_OFF);
		el_lcd_print("Line 4");
		lcd_delay(2);
	}
}
