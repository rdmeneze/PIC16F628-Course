/*
 *	LCD interface example
 *	Uses routines from delay.c
 *	This code will interface to a standard LCD controller
 *	like the Hitachi HD44780. It uses it in 4 bit mode, with
 *	the hardware connected as follows (the standard 14 pin
 *	LCD connector is used):
 *
 *	PORTB bits 0-3 are connected to the LCD data bits 4-7 (high nibble)
 *	PORTA bit 4 is connected to the LCD RS input (register select)
 *	PORTA bit 5 is connected to the LCD EN bit (enable)
 *
 *	To use these routines, set up the port I/O (TRISA, TRISB) then
 *	call lcd_init(), then other routines as required.
 *
 */


//static bit LCD_RS	@ ((unsigned)&PORTA*8+4);	// Register select
//static bit LCD_EN	@ ((unsigned)&PORTA*8+5);	// Enable
//#define LCD_DATA   PORTB                    // Low 4 bits is data

#define	LCD_STROBE	((LCD_EN = 1),(LCD_EN=0))



/* write a byte to the LCD in 4 bit mode */

void lcd_write(unsigned char c)
{
 LCD_DATA &= 0xF0;       //-- Clear Low 4 Bits
	LCD_DATA |= (c >> 4);   //-- Move Top 4 bits of data to Low 4 on port
	LCD_STROBE;             //-- Load the data in
 c &= 0x0F;              //-- Clear the top 4 bits of the data
	LCD_DATA &= 0xF0;       //-- Clear low 4 of port
 LCD_DATA |= c;          //-- add low 4 of data to port
	LCD_STROBE;             //-- Load the Data in
	DelayUs(40);
}


/*
void lcd_write(unsigned char c)
{
	PORTB = c >> 4;
	LCD_STROBE;
	PORTB = c & 0x0F;
	LCD_STROBE;
	DelayUs(40);
}
*/

/*
 * 	Clear and home the LCD
 */

void lcd_clear(void)
{
	LCD_RS = 0;
	lcd_write(0x1);   //-- Clear the Display
	DelayMs(3);
	lcd_write(0x02);  //-- Home the display
	DelayMs(3);
}

/* write a string of chars to the LCD */

void lcd_puts(const char * s)
{
	LCD_RS = 1;	// write characters
	while(*s)
		lcd_write(*s++);
}

/*
 * Go to the specified position
 */

void lcd_goto(unsigned char pos)
{
	LCD_RS = 0;
	lcd_write(0x80+pos);           //-- sets the DDRAM Address
 DelayMs(1);
}

/* initialise the LCD - put into 4 bit mode */

void lcd_init(void)
{
 T_LCD_RS=0;                    //-- Set TRIS for output on port
 T_LCD_EN=0;                    //   For RS and EN pins
 T_LCD_DATA &=0xF0;             //-- Set Data as output

	LCD_RS = 0;	// write control bytes
	DelayMs(15);	// power on delay
 LCD_DATA &=0xF0;
	LCD_DATA |= 0x3;	// attention!
	LCD_STROBE;
	DelayMs(5);
	LCD_STROBE;
	DelayUs(100);
	LCD_STROBE;
	DelayMs(5);
 LCD_DATA &=0xF0;
 LCD_DATA = 0x2;	// set 4 bit mode
	LCD_STROBE;
	DelayUs(60);
	lcd_write(0x28);	// 4 bit mode, 1/16 duty, 5x8 font
	lcd_write(0x08);	// display off
	lcd_write(0x0F);	// display on, blink curson on
	lcd_write(0x06);	// entry mode
 DelayUs(100);
}

void putch(char c)
{
	LCD_RS=1;    //- write characters
	lcd_write(c);
}

void puts(char *s)
{
	LCD_RS = 1;	// write characters
	while(*s)
		lcd_write(*s++);
}

void lcdprint(unsigned char x,unsigned char *str)
{
 lcd_goto(x);
 lcd_puts(str);
}


//*************************************************************************
void lcd_scroll(char Direction)
{
 LCD_RS=0;     //-- write command
 if(Direction==SCROLL_LEFT)
 {
  lcd_write(0x18);        //- S/C=1 R/L=0   => Scroll LEFT
 }
 else
 {
  lcd_write(0x1b);        //- S/C=1 R/L=1   => Scroll RIGHT
 }
 DelayMs(2);
}
//****************** END OF lcd_scroll

//*************************************************************************
//lcd_home - sends LCD to the Home Position
//*************************************************************************
void lcd_home(void)
{
 LCD_RS=0;                //-- write command
 lcd_write(0x02);         //-- Home Everything
 DelayMs(3);
}
//****************** END OF lcd_home

//*************************************************************************
//lcd_cursor - turns cursor on or off
//*************************************************************************
void lcd_cursor(char onoff)
{
 LCD_RS=0;
 if(onoff==CURSOR_OFF)          //-   0000 1DCB
 {                              //- D= Display C= Cursor B=Blink
  lcd_write(0x0C);              //- D on/off= 1 C on/off=0 B on/off=0
 }
 else
 {
  lcd_write(0x0F);              //- D=1 C=1 B=1   => Cursor ON + Blink
 }
 DelayMs(2);
}
//****************** END OF lcd_cursor

