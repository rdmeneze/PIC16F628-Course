/*
 *	LCD interface header file
 *	See lcd.c for more info
 */

/* write a byte to the LCD in 4 bit mode */

extern void lcd_write(unsigned char);

/* Clear and home the LCD */

extern void lcd_clear(void);

/* write a string of characters to the LCD */

extern void lcd_puts(const char * s);

/* Go to the specified position */

extern void lcd_goto(unsigned char pos);
	
/* intialize the LCD - call before anything else */

extern void lcd_init(void);

#define SCROLL_LEFT   0
#define SCROLL_RIGHT  1
#define CURSOR_OFF    0
#define CURSOR_ON     1


extern void lcd_scroll(char Direction);         //-- scrolls LCD to left or Right
extern void lcd_home(void);                    //-- homes the LCD
extern void lcd_cursor(char onoff);             //-- turns cursor on or off

