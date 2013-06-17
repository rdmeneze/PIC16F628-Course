/***************************************************
* Module name: 
*	port_drv_lcd.c	
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


/***************************************************
*	Include section
***************************************************/
#include "port_drv_lcd.h"


/**************************************************
* Description:
* 	Delay in seconds
* 
* Parameters:
* 	seconds: number of seconds
* 
* Return:
* 	none
* 
* Comments:
* 
**************************************************/
void lcd_delay(char seconds)
{
	int i;
	
	for (i = 0; i < seconds; i++)
		Delay10KTCYx(160);
}


/**************************************************
* Description:
* 	Delay in miliseconds
* 
* Parameters:
* 	mseconds: number of miliseconds (1 - 150)
* 
* Return:
* 	none
* 
* Comments:
* 
**************************************************/
void lcd_delayms(char mseconds)
{
	unsigned char qtd = mseconds / 0.6;
	
	Delay1KTCYx(qtd);
}
