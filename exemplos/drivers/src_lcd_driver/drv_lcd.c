/***************************************************
* Module name: 
*	drv_lcd.c	
* 
* License information... 
*
* Author: Sergio Prado (sergiosiena@gmail.com)
* Date: 10/2007
*
* Module Description:
* 	Architecture-independent LCD Display Driver. 
* 	This routines was written to support Hitachi 
* 	HD44780 LCD controller and similars models.
* 
* TODO:
* 	Support for 4-bit interface mode
* 	Support to read data from display
* 	Suport to set character generator addresses 
*
***************************************************/


/***************************************************
*	Include section
***************************************************/
#include "drv_lcd.h"


/**************************************************
* Description:
* 	This routine reads the busy status of the
* 	lcd display.
* 
* Parameters:
* 	none
* 
* Return:
* 	1: display is busy
* 	0: display is not busy
* 
* Comments:
* 
**************************************************/
static byte el_lcd_busy(void)
{
#if READ_ENABLED == 1
	// Set the control bits for read
	SET_RW();                     
	CLEAR_RS();
	DELAYMS(1);
    
	// Clock in the command
	SET_E();                    
    DELAYMS(1);
        
    // read busy flag
    if(DATA_PORT & 0x80)
    {                 
    	CLEAR_E();    
    	CLEAR_RW();   
        return 1;     
    }
    else              
    {
    	CLEAR_E();    
    	CLEAR_RW();   
        return 0;     
    }
#else
    DELAYMS(1);
    return(0);
#endif
}


/**************************************************
* Description:
* 	Write data to lcd display 
* 
* Parameters:
* 	data: data to write
* 
* Return:
* 	none
* 
* Comments:
* 
**************************************************/
static void el_lcd_write(byte data, byte type)
{
	// set data out
	CFG_OUT_DATA();
    DATA_PORT = data;
    
    // select type (data/command)
    if (type == LCD_WR_DATA)
    	SET_RS();
    else
    	CLEAR_RS();
    CLEAR_RW();
    DELAYMS(1);
    
    // clock out data
    CLOCK();
    
    // clear pins and data
    CLEAR_RS();                     
    CFG_IN_DATA();
}


/**************************************************
* Description:
* 	Set cursor
* 
* Parameters:
* 	cursor: LCD_OFF=off, LCD_ON=on
* 	blink:  LCD_OFF=off, LCD_ON=on
* 
* Return:
*	none
* 
* Comments:
* 
**************************************************/
byte el_lcd_cursor(byte cursor, byte blink)
{
	byte cmd;
	
	// format cmd
	cmd = DON;
	if (cursor == LCD_ON)
		cmd |= CURSOR_ON;
	if (blink == LCD_ON)
		cmd |= BLINK_ON;
	
	/* send command to display */
	el_lcd_write(cmd, LCD_WR_COMMAND);
}


/**************************************************
* Description:
* 	Clear display
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
void el_lcd_clear()
{
	el_lcd_write(CLEAR_DISPLAY, LCD_WR_COMMAND);
	DELAYMS(5);
}


/**************************************************
* Description:
* 	Position the cursor in the display
* 
* Parameters:
* 	line: line to position
* 	collum: collum to position
* 
* Return:
* 	0: OK
* 	1: Invalid Parameters
* 
* Comments:
* 
**************************************************/
byte el_lcd_gotoxy(byte line, byte collum)
{
	byte i, ddram;
	
	/* check parameters */
	if (line <= 0 || line > NUMBER_OF_LINES)
		return(1);
	if (collum <= 0 || collum > NUMBER_OF_COLLUMS)
		return(1);
	
	/* calculate DDRAM address */
	switch (line) {
		case 1:
			ddram = LINE1_DDRAM_ADDR;
			break;
		case 2:
			ddram = LINE2_DDRAM_ADDR;
			break;
		case 3:
			ddram = LINE3_DDRAM_ADDR;
			break;
		case 4:
			ddram = LINE4_DDRAM_ADDR;
			break;
	}
	ddram += collum - 1;
	ddram |= SET_DDRAM_ADDR;
	
	/* send command to display */
	el_lcd_write(ddram, LCD_WR_COMMAND);
	
	/* return OK */
	return(0);
}


/**************************************************
* Description:
* 	Print a string in the display
* 
* Parameters:
* 	str: string to print
* 
* Return:
* 	none
* 
* Comments:
* 
**************************************************/
void el_lcd_print(string *str)
{
	int i;
	
	for (i = 0; str[i]; i++)
	{
		while(el_lcd_busy());
        el_lcd_write(str[i], LCD_WR_DATA);
	}
}


/**************************************************
* Description:
* 	Initialize display
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
void el_lcd_init()
{
	// configure the port
	DATA_PORT = 0;
	CFG_IN_DATA();
	
	// all control signals made outputs
	CFG_OUT_RS();
	CFG_OUT_E();
	CFG_OUT_RW();
		
	// clear control pins
	CLEAR_RW();
	CLEAR_RS();
	CLEAR_E();

	// Delay for 30ms to allow for LCD Power on reset
	DELAYMS(30);
	
	// send init cmd
	el_lcd_write(INIT_CMD, LCD_WR_COMMAND);
	DELAYMS(5);
	el_lcd_write(INIT_CMD, LCD_WR_COMMAND);
	DELAYMS(1);
	el_lcd_write(INIT_CMD, LCD_WR_COMMAND);
	DELAYMS(1);
	
    // Delay for at least 4.1ms
	DELAYMS(5);

	// data port as input
	CFG_IN_DATA();

	// Set data interface width, # lines, font
	while(el_lcd_busy());
	el_lcd_write(FUNCTION_SET, LCD_WR_COMMAND);
	
	// Turn the display off
    while(el_lcd_busy());        
    el_lcd_write(DISPLAY_OFF, LCD_WR_COMMAND);
    
    // clear display
    while(el_lcd_busy());          
    el_lcd_write(CLEAR_DISPLAY, LCD_WR_COMMAND);
    
    // set cursor direction
    while(el_lcd_busy());          
    el_lcd_write(CURSOR_DIR, LCD_WR_COMMAND);
    
    // turn the display on
    while(el_lcd_busy());
    el_lcd_write(DISPLAY_ON, LCD_WR_COMMAND);

    // Set entry mode inc, no shift
    while(el_lcd_busy());
    el_lcd_write(SHIFT_CUR_RIGHT, LCD_WR_COMMAND);
      
    // set cursor to line 1 and collum 1
    el_lcd_gotoxy(1, 1);
}
