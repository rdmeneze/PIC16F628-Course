/**********************************************************************
*                     High Speed Pulse Generator
*
*                    Michael Pearce 26 March 2001
*
* Electronics Workshop, Chemistry Department, University of Canterbury
***********************************************************************
Processors Used: PIC16C74A
***********************************************************************
Disclaimer:
The following code has been released so that someone may possibly find
something useful in them. The Author and the company he works for takes
no responsibilty for the use of this code or any damage that may be
caused by using part of all of this code.
***********************************************************************
Overview:
I have included this code as an Example of using a 20x2 character LCD,
I2C EEPROM and basic I/O Control, it also has a ascii to unsigned long
function that I created to convert entered text into a useable number.

The HSPG project is a specialised piece of hardware for accurately
generating pulses on a rather large piece of equipment (Takes up a large room).
This unit has a resolution of 20ns and a 24 bit counter
(0 to approx 0.335 sec in 20ns Steps) and all the pulse outputs are
fibre optic for noise reduction, earth loop elimination and speed.
This is the only piece of equipment like it in the world that we know of,
and hence it is restriced, so circuit diagrams WILL NOT be supplied.
But if you want to buy a complete unit (With updated firmware)...
... not a prob if you have a spear US$10,000...
  ... but you still won't get the diagrams!!!

The code here just runs a simple menu system and allows editing of
numbers on a display. The data is stored on an individual I2C EEPROM for
each channel and is uploaded to each channels hardware.
Since the Hardware is where all the fancy stuff happens, and all the
Code does is send data around the place, the code has not been modified
in any way because it is totally useless without the hardware.

But it should give you a good idea of how to use the LCD, I2C and some
other routines.

Here is a list of the files:

MAIN.C
IOPORTS.H
VARIABLE.H
KEYPAD.C
LCD.H
LCD.C
M_I2C_1.C
ATOUL.C
DELAY.H
DELAY.C

*************************** MAIN.C **************************
USES:
ioports.h, variable.h, delay.h, delay.c,lcd.h, lcd.c, m_i2c_1.c,
atoul.c

DESCRIPTION:
The main program that does all the hard work.
Looking in this one to see how all the different things are used.


*************************** IOPORTS.H **************************
DESCRIPTION:
A seperate file for looking after all the hardware declairations
and initialisation.
Useful to do this in bigger projects

*************************** VARIABLE.H **************************
DESCRIPTION:
A seperate file for looking after all the variable declairations
and initialisation.
Useful to do this in bigger projects

*************************** KEYPAD.C **************************
DESCRIPTION:
Routines to read and translate a 4x4 Array keypad
kgetch() and khit() are the functions.

*************************** LCD.H **************************
DESCRIPTION:
Header file for the LCD functions


*************************** LCD.C **************************
DESCRIPTION:
Driver functions for up to a 40x2 or 20x4 Hitachi based LCD
Functions are:
void lcd_write(unsigned char);
void lcd_clear(void);
void lcd_puts(const char * s);
void lcd_goto(unsigned char pos);
void lcd_init(void);
void lcd_scroll(char Direction);
void lcd_home(void);
void lcd_cursor(char onoff);



*************************** M_I2C_1.C **************************
DESCRIPTION:
A complete set of bit banged, software driven I2C routines I
created - and they work!!

Functions are:
char I2C_Send(char Address,char *Data,char Num);
char I2C_Read(char Address,char *Data,char Num);
char i2csendbyte(char byte);
char i2cgetbyte(void);
char i2cgetack(void);
void i2csendack(void);
void i2cdelay(char delay);
void i2cstart(void);
void i2cstop(void);
void i2cclock(void);
char i2creadbit(void);

*************************** ATOUL.C **************************
DESCRIPTION:
Converts ASCII to unsigned Long
Used to convert the 12 digit display value to unsigned Long for
storage and uploading.

************************* DELAY.H *******************************
Modified version of the delay.h routines supplied by HiTech PICC

************************* DELAY.C *******************************
Modified version of the delay.h routines supplied by HiTech PICC

********************************************************************/

