//******************************************************************
//                        lcdkey1.C
//                     18 FEBRUARY 1999
//
// Description:
// A test program for the LCD/Keyboard General purpose PCB
//
// Author: Michael Pearce
//         Chemistry Dept, University of Canterbury
//
// Started: NOVEMBER 1998
//******************************************************************

#include	<pic.h>

#include <string.h>

#define	XTAL_FREQ	20MHZ
#include	"delay.h"
#include "delay.c"
#include	"lcd.h"
#include "lcd.c"
#include "stdio.h"


#define KeyAddr PORTC
#define KeyInPort PORTB

char DecodeKey(char keycode);
void ScrollMessage(char row,const char Message[]);
unsigned char KeyRead(void);

void putch(char c)
{
	char str[2];
	str[0]=c;
	str[1]=0;
	lcd_puts(str);
}

void main(void)
{
	unsigned int count;
	unsigned char tempc,temps[5]="0";

 OPTION=0x00;
 GIE=0;
 TRISA=0xCF;    //-- Control Pins PA4,PA5 as output
 TRISB=0xF0;    //-- Port B bit 0 to 3 as output
 TRISC=0xF8;    //-- Low 3 bits used for keyboard array

	DelayMs(100);
	//-- initialise LCD --
 lcd_init();

 //-- Clear the display --
 lcd_clear();
 //-- Display opening message --
 lcd_puts("Testing the L.C.D.");
 lcd_goto(40);
 lcd_puts("This is on Row 2 ?");

 //-- 5 second delay ---
 for(count=0;count<1000;count++)
 {
  DelayMs(3);
 }

 lcd_clear();
 lcd_puts("Testing Scrolling..");
 ScrollMessage(1,"    Software Written By Michael Pearce, Chemistry Department, University of Canterbury     Firmware Ver 1.00   ");
 //-- 5 second delay ---
 for(count=0;count<1000;count++)
 {
  DelayMs(3);
 }

 lcd_clear();
 lcd_puts("Please press Keys..");
 while(1)
 {
	 tempc=KeyRead();
	 temps[0]=DecodeKey(tempc);
//	 itoa(tempc,temps,10);
  lcd_goto(40);
  lcd_puts("Key Pressed = ");
  lcd_puts(temps);
//  printf("Key Num = %d    ",tempc);
  if(temps[0]=='Z')
  {
	  ScrollMessage(1,"      You Wally! You are only ment to press one key at a time!!!!      ");
  }
	 DelayMs(100);
 }
}
//---------------------------------------------------------
void ScrollMessage(unsigned char row,const char Message[])
{
 char TempS[30];
 unsigned int  MHead=0,Done=0,count;
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
  DelayMs(200);
 }
}
//-----------------------------------------------------
unsigned char KeyRead(void)
{
	unsigned char line,data,result=0;
	for(line=0;line <8;line++)
	{
		KeyAddr=line;      //-- Set Row To Read
		DelayMs(1);
		data = KeyInPort;  //-- Read in the data
		data = data >> 4;  //-- shift to lower nibble
		data	|= 0xF0;      //-- set upper nibble to 1s
		data ^= 0xFF;      //-- invert everything (XOR)
		if(data !=0)
		{
			result=line<<4;
			result+=data;
			line=10;
		}
	}
	return(result);
}

//-------------------------------------------
char DecodeKey(char keycode)
{
 switch(keycode)
 {
  case 1:
   return('v');
  case 2:
   return('E');
  case 4:
   return('0');
  case 8:
   return('C');


  case 17:
   return(0x7E);
  case 18:
   return('3');
  case 20:
   return('2');
  case 24:
   return('1');


  case 33:
   return(0x7F);
  case 34:
   return('6');
  case 36:
   return('5');
  case 40:
   return('4');


  case 49:
   return(0x5E);
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
   return('Z');


  default:
   break;
 }


 return(0);
}








