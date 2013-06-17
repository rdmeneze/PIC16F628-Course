//******************************************************************
//                       lcdkey2.C
//
//       Firmware Version 2.01 For the LCD & KEYPAD Controler
//
// Driver software for the LCD and Keypad Interface for
// the High Speed Pulse Generator.
// I/O is using Parallel Slave Port interface.
// Data written to port from outside is displayed on LCD
// Data read from the port is the last key pressed.
//
// If all 4 Menu buttons pressed - a game (or something may appear)
//
// Author: Michael Pearce
//         Electronics Workshop, Chemistry Department
//         University of Canterbury
//
// Started: 5 November 1998
//
//******************** UPDATE INFORMATION **************************
// Version 2.01 12 November 1998
//  Made LCD_L0 and LCD_L1 Clear the line first.
//
//******************************************************************

#include	<pic.h>

#include <string.h>

#define	XTAL_FREQ	8MHZ
#include	"delay.h"
#include "delay.c"
#include	"lcd.h"
#include "lcd.c"
#include "stdio.h"

#define KeyAddr PORTC
#define KeyInPort PORTB

#define SCROLLDELAY 100           //-- ms Delay
#define KEYDELAY    100           //-- us Delay between addressing and reading

//********* LCD CONTROL COMMANDS *********
#define  LCD_CLS   0x10         //-- Clear Screen
#define  LCD_CR    0x11         //-- Carrage Return
#define  LCD_LF    0x12         //-- New Line
#define  LCD_CRLF  0x13         //-- CR and NL
#define  LCD_BEEP  0x14         //-- Makes a beep!!
#define  LCD_L0    0x15         //-- Goes to start of Line 0
#define  LCD_L1    0x16         //-- Goes to start of Line 1
#define  LCD_PUTCH 0x1D         //-- Puts next char direct to LCD bypass Buff
#define  LCD_GOTO  0x1E         //-- Moves Cursor to next byte location
#define  LCD_SHOW  0x1F         //-- Update the display
//****************************************


#define BITNUM(adr, bit)       ((unsigned)(&adr)*8+(bit))
static bit  Beeper   @ BITNUM(PORTC, 3);  //- Beeper Output pin
static bit  ChipSel  @ BITNUM(PORTE, 2);  //- Port Select Pin
static bit  TChipSel @ BITNUM(TRISE, 2);

//------- FLAGS ----------
bit  NewData;
bit  BeepNow;
bit  GotoCommand;
bit  GotoNew;
bit  PutchCommand;
bit  PutchNew;

//------- Global Variables, Buffers etc ----------
unsigned char Buffer[41]="Waiting for data.\0                    \0";
unsigned char Head,count,GotoData,PutchData;
unsigned char KeyPressed,LastKeyPressed;

//------- Functions Used in Program --------
void interrupt GlobalInterrupt(void);
unsigned char KeyRead(void);
char DecodeKey(char keycode);
void DisplayData(void);
void Beep(char time);
//void Beep(void);
//void RunGame(void);
void ScrollMessage(unsigned char row,const char Message[]);


//**********************************************************************
//Main
//**********************************************************************
void main(void)
{
 //-- Setup Variables --
 Beeper=0;
 NewData=0;
 Head=0;
 BeepNow=0;
 GotoCommand=0;
 GotoNew=0;
 GotoData=21;

 //-- Set up Ports --
 TRISA=0xCF;    //-- Control Pins PA4,PA5 as output
 TRISB=0xF0;    //-- Port B bit 0 to 3 as output
 TRISC=0xF0;    //-- bits 0 - 2 used for keyboard array bit 3 for Beep
 TRISD=0xFF;    //-- PSP configured as input
 TRISE=0x07;    //-- PSP Controls as input
 PORTD=0x00;    //-- NULL Output to start with

 //-- Set Chip Sel Pin High to indicate Busy to the master
 ChipSel=1;
 TChipSel=0;


 //-- Set Up Interrupts --
 PSPMODE=0;     //-- Disable the PSP Mode
 PSPIE=0;       //-- Disable PSP Interrupt
 PSPIF=0;       //-- Clear Interrupt Flag
 PEIE=1;        //-- Enable Peripheral Interrupts
 GIE=1;         //-- Enable Global Interrupts

 //-- Initialise the LCD --
 lcd_init();
 lcd_clear();
// ScrollMessage(0,"     LCD & Keypad Driver");
// ScrollMessage(1,"     Firmware Version 2.01       ");
 lcd_puts("LCD & Keypad Driver");
 lcd_goto(40);
 lcd_puts("Version 2.01.1");
 DelayMs(200);
 Beep(100);
 Beep(100);
 Beep(60);
 Beep(60);
 Beep(60);
 Beep(200);
 DisplayData();

 //-- Signal to the Master controller to tell it that ready to recieve!!
 ChipSel=0;     //- Take Pin Low For 10ms
 DelayMs(20);
 PSPIE=1;       //-- Enable PSP Interrupts
 TChipSel=1;    //- Back into High Impedance State
 PSPMODE=1;     //-- Enable PSP Mode

 //-- Main Program Loop --
 while(1)
 {
  if(NewData==1)
  {
	  NewData=0;
   DisplayData();
  }
  if(GotoNew==1)         //-- Move Cursor to selected Position
  {
	  GotoNew=0;
	  lcd_goto(GotoData);
  }
  if(PutchNew==1)       //-- Put Character Directly to LCD Bypassing Buffer
  {
	  PutchNew=0;
	  putch(PutchData);
	 }
  if(BeepNow==1)
  {
   Beep(80);
//   Beep();
   BeepNow=0;
  }
  KeyPressed=KeyRead();
  if(KeyPressed != 0)
  {
   KeyPressed=DecodeKey(KeyPressed);
	  if(KeyPressed != LastKeyPressed)
	  {
		   Beep(50);
	    LastKeyPressed=KeyPressed;
     PORTD=KeyPressed;
	  }
   if(KeyPressed==0xFF)
   {
	   Beep(100);
	   Beep(50);
	   Beep(200);
    // RunGame();  //-- All 4 menu keys were depressed
   }
  }
  else
  {
	  LastKeyPressed=0; //-- Key has been released so allow re pressing
  }
 }
}
//******************* END OF Main

//**********************************************************************
//GlobalInterrupt - exactly what it says!!
//**********************************************************************
void interrupt GlobalInterrupt(void)
{
	char Icount,TempD;
 if(PSPIF)
 {
  if(IBF)            // Input Buffer Full
  {
   TempD=PORTD;
   switch(TempD)
   {
    default:
     if(GotoCommand==1)
     {
	     GotoData=TempD;
	     GotoCommand=0;
	     GotoNew=1;
	     break;
     }
     if(PutchCommand==1)
     {
	     PutchData=TempD;
	     PutchNew=1;
	     PutchCommand=0;
	     break;
     }
     Buffer[Head++]=TempD;     //-- Add Data to the Buffer and point to next
     if(Head < 40) break;      //-- If not off the end then exit ...
     Head=20;                  //-- ... else CR!
     break;

    //**************************************
    case LCD_CRLF:             //-- Combination of CR and LF
     if(Head < 20)
     {
      Head=0;
     }
     else
     {
      Head=20;
     }

    //**************************************
    case LCD_LF:              //-- Line Feed
     if(Head >=20)
     {
      for(Icount=0;Icount<20;Icount++)
      {
       Buffer[Icount]=Buffer[Icount+20];
       Buffer[Icount+20]=0; //-- Clear the data out
      }
     }
     else
     {
      Head+=20;
     }
     break;

    //**************************************
    case LCD_CR:              //-- Carrage Return
     if(Head < 20)
     {
      Head=0;
     }
     else
     {
      Head=20;
     }
     break;

    //**************************************
    case LCD_BEEP:           //-- Force A Beep
     BeepNow=1;
     break;

    //**************************************
    case LCD_CLS:           //-- Clear the buffer
     for(Icount=0;Icount<40;Icount++)
     {
      Buffer[Icount]=0;
     }

    //**************************************
    case LCD_L0:            //-- Go to Start of 1st Line
     Head=0;                //-- Also Clear the Line
     for(Icount=0;Icount<20;Icount++) Buffer[Icount]=0;
     break;

    //**************************************
    case LCD_L1:            //-- Go to Start of 2nd Line
     Head=20;               //-- Also Clear the Line
     for(Icount=20;Icount<40;Icount++) Buffer[Icount]=0;
     break;

    //**************************************
    case LCD_SHOW:          //-- Update the Display
     NewData=1;
     break;

    //**************************************
    case LCD_GOTO:          //-- Put Cursor to location
     GotoCommand=1;         //-- Indicated by next byte
     break;

    //**************************************
    case LCD_PUTCH:         //-- Put next character directly to LCD
     PutchCommand=1;        //-- By Passing the Buffer
     break;
   }
	 }

  if(!OBF)         // Output Buffer has been read
  {
	  PORTD=0x00;       // Put Null into buffer to indicate no key pressed
//	  LastKeyPressed=0; // Allow Beep again on same key
  }
  PSPIF=0;
 }
}
//******************* END OF GlobalInterrupt

//**********************************************************************
//KeyRead
//**********************************************************************
unsigned char KeyRead(void)
{
	unsigned char line,data,result=0;
	for(line=0;line <8;line++)
	{
		KeyAddr=line;      //-- Set Row To Read
		DelayUs(KEYDELAY);
		data = KeyInPort;  //-- Read in the data
		data = data >> 4;  //-- shift to lower nibble
		data	|= 0xF0;      //-- set upper nibble to 1s
		data ^= 0xFF;      //-- invert everything (XOR)
		if(data !=0)
		{
			result=line<<4;   //-- Put line number in upper nibble
			result+=data;     //-- Put Row Bit pattern in lower nibble
			line=10;          //-- Terminate the loop
		}
	}
 DelayUs(KEYDELAY);  //-- We Bit More Delay
	return(result);     //-- Return the result
}
//******************* END OF KeyRead

//**********************************************************************
//DecodeKey
//**********************************************************************
char DecodeKey(char keycode)
{
 switch(keycode)
 {
  case 1:
   return('D');
  case 2:
   return('E');
  case 4:
   return('0');
  case 8:
   return('C');

  case 17:
   return('R');
  case 18:
   return('3');
  case 20:
   return('2');
  case 24:
   return('1');

  case 33:
   return('L');
  case 34:
   return('6');
  case 36:
   return('5');
  case 40:
   return('4');

  case 49:
   return('U');
  case 50:
   return('9');
  case 52:
   return('8');
  case 56:
   return('7');

  case 81:
   return('M');
  case 82:
   return('a');
  case 84:
   return('b');
  case 88:
   return('c');

  case 95:       //-- all function keys hit.
   return(0xFF);

  default:
   break;
 }
 return(0);
}
//******************* END OF DecodeKey

//**********************************************************************
//DisplayData - Displays the Buffer on the LCD Display
//**********************************************************************
void DisplayData(void)
{
// unsigned char count;
 lcd_clear();                      //-- Clear the LCD
 lcd_goto(0);
 for(count=0;count<20;count++)     //-- Display the first line
 {
  if(Buffer[count]==0)
  {
	  count=19;                       //-- Check for end of string character
  }
  else
  {
   putch(Buffer[count]);           //-- Display Character on screen
  }
 }
 lcd_goto(40);                     //-- Move Cursor to second Line
 for(;count<40;count++)            //-- Display the second line
 {
  if(Buffer[count]==0)
  {
	  count=40;                       //-- Check for end of string character
  }
  else
  {
   putch(Buffer[count]);           //-- Display Character on screen
  }
 }
// lcd_goto(21);                     //-- Put cursor off the screen
}
//******************* END OF DisplayData

//**********************************************************************
//Beep - Does a small Beep using the SCL Pin
//**********************************************************************
void Beep(char time)
//void Beep(void)
{
// char count;
 for(count=0;count<0xFF;count++)
 {
  Beeper=1;
  DelayUs(time);
//  DelayUs(100);
  Beeper=0;
  DelayUs(time);
//  DelayUs(100);
 }
}
//******************* END OF Beep

//**********************************************************************
//RunGame - Will possibly run a game of scroll a message or something
//**********************************************************************
void RunGame(void)
{
	ScrollMessage(0,"    Sorry No Game!! ");
	DisplayData();
}

//******************* END OF RunGame

//**********************************************************************
//putch - Prints a single character to the LCD
//**********************************************************************
void putch(char c)
{
	char str[2];
	str[0]=c;
	str[1]=0;
	lcd_puts(str);
}
//******************* END OF putch


//**********************************************************************
//ScrollMessage
//**********************************************************************

void ScrollMessage(unsigned char row,const char Message[])
{
 char TempS[21];
 unsigned int  MHead=0,Done=0;//,count;
 if(row >1) row=1;
 row=row*40;
 while(Done==0)
 {
  for(count=0;count<20;count++)
  {
	  TempS[count]=Message[MHead+count];
	  if(Message[MHead+count+1]==0) Done=1;
	 }
	 MHead++;
  lcd_goto(row);
  lcd_puts(TempS);
  DelayMs(SCROLLDELAY);
 }
}

//******************* END OF ScrollMessage

//**********************************************************************
//
//**********************************************************************

//******************* END OF


//**********************************************************************
//
//**********************************************************************

//******************* END OF



