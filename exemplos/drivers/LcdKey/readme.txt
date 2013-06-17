/**********************************************************************
*                         LCD/Keypad Project
*
*                    Michael Pearce 26 March 2001
*
* Electronics Workshop, Chemistry Department, University of Canterbury
***********************************************************************
Processors Used So Far: PIC12C50x/67x PIC16C64/74/84/
***********************************************************************
Disclaimer:
The following code has been released so that someone may possibly find
something useful in them. The Author and the company he works for takes
no responsibilty for the use of this code or any damage that may be
caused by using part of all of this code.
***********************************************************************
Overview:
This project was for the first version of the High Speed Pulse Generator,
but was scrapped due to technology restrictions of the time. But the
board has been used for testing character LCDs and keypads, and does
make a reasonable general purpose display & keypad type controller with
a number of control lines avaliable.

The code here shows how to use the LCD and Keypad routines.

The Schematic is also provided.


Here is a list of the files:

SCHEMATIC.JPG
LCDKEY1.S01
LCDKEY1.C
LCDKEY2.C
LCD.H
LCD.C
DELAY.H
DELAY.C


********************** SCHEMATIC.JPG *************************
A JPG of the schematic file for the LCD/Keypad Project

*********************** LCDKEY1.S01 **************************
The Autotrax Schematic of the project (DOS VERSION)

*********************** LCDKEY1.C **************************
DESCRIPTION:
 A simple test program for the hardware and functions.

*********************** LCDKEY2.C **************************
DESCRIPTION:
 The original menu system that was going to be used for the
 HSPG project.

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


************************* DELAY.H *******************************
Modified version of the delay.h routines supplied by HiTech PICC

************************* DELAY.C *******************************
Modified version of the delay.h routines supplied by HiTech PICC

********************************************************************/





