//*************************************************************************
//                             main.c
//             User Interface and Hardware Control for
//                        HSPG V2 Hardware
//                        Software V0.3.5
//                         30 June 2000
//
// This software controls the HSPG user interface, and communicates and
// configures the seperate HSPG Output channels as well as giving the user
// the ability to Pause the clock.
//
//
// Author: Michael Pearce
//         Chemistry Department, University of Canterbury
//
// Started: 14 June 2000
//
// Controller Used: PIC16C74A
//
//*************************************************************************
//                         VERSION NOTES
//                      (Latest to oldest...)
//*************************************************************************
// Ver 0.3.5
// 30 June 2000
// Added OUTPUT_DIFFERENCE to counter for the difference between the Electronic
// Pulse and the Optical output pulse.
// Added minimum pulse length calculator.
//
//-------------------------------------------------------------------------
// Ver 0.3.4
// 28 June 2000
// Altered some menus Text
// Added Value checking on Start and Stop Data while editing - should work.
//
//-------------------------------------------------------------------------
// Ver 0.3.3
// 28 June 2000
// Load Card Routine Timing has been change to #defines so can play with them
// Added Delays to selectslot and deselect slot functions
// Corrected deselcslot - was holding low when should have released the port
// Found Problem with More than 3 cards - needed stronger pullup on A1 line.
//
//-------------------------------------------------------------------------
// Ver 0.3.2
// 27 June 2000
// Added deselectslot() to all routines that selected slot but never released
// Found Assembly faults in board so what I thought were S/W Probs were H/W
// Have found a problem when more than 3 output boards loaded in - wont write
// the Stop Data to the card (Not sure if HSPG Clock Problem or Data Problem)
//
//-------------------------------------------------------------------------
// Ver 0.3.1
// 27 June 2000
// Added Clock Speed Message to start up
// Changed Edit display to Start Time and Pulse Length (From Start pulse)
// Need to add Data Range checking at some stage.
// Removed some debuging and pauses.
//
//-------------------------------------------------------------------------
//
// Ver 0.3.0
// 26 June 2000
// Lots of little things fixed and some stuff added.
// Fixed Card Register Select address problems (Was Hardware and Software)
// Added ns calculations so actual times can be displayed.
// Data is now writing to cards - but when bin 100 is written its like 1000 has
// been written - not sure if Hard or Soft problem.
// Added Software Version Display
// Changed extra menu/option messages
//
//-------------------------------------------------------------------------
// Ver 0.2.0
// 21 June 2000
// Fixed I2C reading problems (added the ACK from Master!!!)
// Added Reading/Writing data from EEPROM Routines
// Functional Number Editing Routine
// Theoretically data is written to the Card - but have not checked.
// Run / Pause option operational
// Enough of the menus complete to operate the unit
//-------------------------------------------------------------------------
// Ver 0.1.0
// 20 June 2000
// LCD and KEYPAD Functional
// I2C Operational
// Some Menus done and reading Card I.D. from I2C working.
// Think it's time to back it up as what is runnin is working good
//
//-------------------------------------------------------------------------
// Ver 0.0.0
// 14 June 2000
// Software Project Started
// *************************************************************************

#define VERSION "HSPG SW V0.3.5"
#define SPEED   "50Mhz => 20ns"

#define XTAL_FREQ 20MHZ    //-- uC Crystal frequency used - for delay calcs

#define COUNT_RES 20L            //-- nS resolution
#define MIN_PULSE 40L            //-- Minimum Pulse Length Possible 
#define OUTPUT_DIFFERENCE 31L    //-- Diff between Gen Pulse and Optic Pulse



#define LC_DATASETTLE 5    //-- Load Card Data Settle Time in ms
#define LC_WRITE      2    //-- Load Card Write Pulse Length in ms

#define SELECTSLOT    5    //-- ms Time to wait after select slot
#define DESELECTSLOT  5    //-- ms Time to wait after Deselecting slot


// INCLUDES
#include <pic.h>
#include <stdio.h>
#include <stdlib.h>


#include "ioports.h"
#include "variable.h"
#include "delay.c"
#include "lcd.h"
#include "lcd.c"
#include "m_i2c_1.c"
#include "keypad.c"
#include "atoul.c"


// FUNCTION DECLARATIONS
void initports(void);
void selectslot(char num);
void deselectslot(void);
void selectregister(char num);
void scanslots(void);
unsigned char readeeprom(char bank,char addr);

void menu_edit(void);
void menu_info(void);
void menu_pause(void);
void menu_second(void);
void editslotdata(char slot);

void load_card(char slot);
void read_slot_data(char slot);
void write_slot_data(char slot);


//void programdevice(void);  //-- For initial E2PROM setup of cards

void main(void)
{
 char c;
 DelayMs(50);
 initports();                //-- Initialise the Ports
 DelayMs(50);
 lcd_init();                 //-- Initialise the LCD

 lcd_clear();
 lcd_puts(VERSION);
 lcd_goto(0x40);
 lcd_puts(SPEED);
 Pause(1);

// programdevice();

 scanslots();

 //************** MAIN MENU *********************
 while(1)
 {
  lcd_clear();
  lcd_puts("STATUS: ");
  if(Status_Run)
  {
   lcd_puts("Running");
  }
  else
  {
   lcd_puts("Paused");
  }
  lcd_goto(0x40);
  lcd_puts("Menu ");
  if(Status_Run)
  {
   lcd_puts("Pause");
  }
  else
  {
   lcd_puts(" Run ");
  }
  lcd_puts(" Edit Info");

  //***** Get Input and select Option ***********
  c=kgetch();
  putch(c);
  switch(c)
  {
   case 'a':
    //-- PAUSE/RUN TOGGLE
    menu_pause();
    break;

   case 'b':
    menu_edit();
    break;

   case 'c':
    menu_info();
    break;

   case 'M':
    menu_second();
    break;
  }
 }
}


//****************************************************************
//                     initports()
//
// initialises the I/O Port settings
//****************************************************************
void initports(void)
{

 ADCON1=0x0F;  //-- Ensure A/D pins are set to DIGITAL I/O
 OPTION=0xC8;  //-- 11001000 - initial settings
 INTCON=0x00;  //-- No Interrupts



 CNTE=0;       //-- Disable the count
 T_CNTE=0;     //-- Port as output
 Status_Run=0;

 WR=1;         //-- Dont Write
 T_WR=0;

 RD=1;         //-- Dont read
 T_RD=0;

 SSEL=1;       //-- Dont select slot
 T_SSEL=0;



 SA0=0;        //-- All address pins initially set to 0
 SA1=0;
 SA2=0;
 A0=0;
 A1=0;
 A2=0;
 TRISA=0x00;  //-- All of Port A are outputs (SA0-SA2 and A0-A2)

 SS=0;        //-- Unused bit - Possibly use as buzzer later
 T_SS=1;

 SCL=0;
 T_SCL=1;
 SDA=0;
 T_SDA=1;

 T_KDI |=0x0F; //-- Lower 4 bits are Keyboard Input
 KRCK=1;       //-- Keyboard Row Count output
 T_KRCK=0;
 KRR=0;        //-- Keyboard Row Reset
 T_KRR=0;

}

//****************************************************************
//                     selectslot(num)
//
// selects the slot to perform read/write functions to
//****************************************************************
void selectslot(char num)
{
 SSEL=1;        //- disable Slot Select

 SA0 = num & 0x01;     //-- Send low bit to first addr port
 num = num >>1;        //-- Shift data Right 1
 SA1 = num & 0x01;     //-- Send low bit to second addr port
 num = num >>1;        //-- shift data Right 1
 SA2 = num & 0x01;     //-- Send low bit to third Addr port

 SSEL=0;       //-- Select the Slot
 DelayMs(SELECTSLOT);
}

//****************************************************************
//                      deselectslot()
//****************************************************************
void deselectslot(void)
{
 SSEL=1;      //-- disable slot selection
 DelayMs(DESELECTSLOT);
}

//****************************************************************
//                    selectregister(num)
//
// Selects Register on currently selected slot
//****************************************************************
void selectregister(char num)
{
 //-- Make sure all Address ports are in output mode.
 A0=0;A1=0;A2=0;

 if(num & 0x01) A0=1;     //-- Send low bit to first addr port

 if(num & 0x02) A1=1;     //-- Send low bit to second addr port

 if(num & 0x04) A2=1;     //-- Send low bit to third Addr port

/*
 A0 = num & 0x01;     //-- Send low bit to first addr port
 num = num >>1;        //-- Shift data Right 1
 A1 = num & 0x01;     //-- Send low bit to second addr port
 num = num >>1;        //-- shift data Right 1
 A2 = num & 0x01;     //-- Send low bit to third Addr port
*/

/*
 A2 = num & 0x01;     //-- Send low bit to first addr port
 num = num >>1;        //-- Shift data Right 1
 A1 = num & 0x01;     //-- Send low bit to second addr port
 num = num >>1;        //-- shift data Right 1
 A0 = num & 0x01;     //-- Send low bit to third Addr port
*/


}


//****************************************************************
//                   void scanslots(void)
//
// Scans each slot and stores the info in the slot data array
//****************************************************************
void scanslots(void)
{
 char count;
 lcd_clear();
 lcd_puts("Scanning ");
  for (count=0;count<8;count++)
 {

  selectslot(count);
  SlotData[count]=readeeprom(1,0);   //-- read from Bank 1, Address 0.

  if(SlotData[count]==162)  //-- Check for valid card
  {
   read_slot_data(count);   //-- Read in data from the EEPROM
   load_card(count);        //-- Write the data to the Card
   putch('*');
  }
  else
  {
   putch('.');
  }
  DelayMs(10);
 }
 deselectslot();

}


//****************************************************************
//       unsigned char readeeprom(char bank,char addr);
//
// reads one byte from the I2C EEPROM on the currently selected
// slot and returns that byte.
//****************************************************************
unsigned char readeeprom(char bank,char addr)
{
 unsigned char i2caddr=0xA0;   //-- I2C address of device - low bank
 unsigned char data=0;
 if(bank)
 {
  i2caddr=0xA2;               //-- I2C address of device - high bank
 }
 I2C_Send(i2caddr,&data,1);    //-- Send address to read from
 I2C_Read(i2caddr,&data,1);   //-- Read one byte from current address

 return(data);
}

//****************************************************************
//                      programdevice
//****************************************************************
/*
void programdevice(void)
{
 char data[3],count;

 lcd_clear();
 lcd_puts("PROGRAMMING ");

//-- Program Counter I.D.   0x81
 selectslot(0);
 data[0]=0;
 data[1]=0x81;
 I2C_Send(0xA2,data,2);

//-- Program output boards  0xA2
 for(count=1;count<8;count++)
 {
  putch(0+count);
  selectslot(count);
  data[0]=0;
  data[1]=0xA2;
  I2C_Send(0xA2,data,2);
 }

 Pause(2);
}
*/

//****************************************************************
//                    menu_edit()
//
// Menu for editing slot devices settings
//****************************************************************
void menu_edit(void)
{
 char count=0,done=0,c=0;

 //-- Keep editing slots until "Menu" Pressed
 while(!done)
 {
  lcd_clear();
  lcd_puts("Edit: Select Slot #");
  lcd_goto(0x40);

  //-- Indicate editable Slot Numbers
  for(count=0;count<8;count++)
  {
   if(SlotData[count]==162)
   {
    putch(' ');
    putch(count+'0');
   }
  }
  c=kgetch();
  switch(c)
  {
   case 'M':
   case 'C':
   case 'E':
    return;
  }
  if(c >='0' && c <='7')
  {
   if(SlotData[c-'0']==162)
   {
    //**************** EDIT THE SLOT DATA ******************
    editslotdata(c-'0');

   }
   else
   {
    lcd_clear();
    lcd_puts("Invalid Entry");
    Pause(1);
   }
  }
 }
}

//****************************************************************
//                    menu_info()
//
// Menu that displays the slot settings and types
//****************************************************************
void menu_info(void)
{
 lcd_clear();
 lcd_puts("Info Menu-Disabled");
 Pause(1);

}

//****************************************************************
//                    menu_pause()
//
//Toggles the Run Status of the system
//****************************************************************
void menu_pause(void)
{
 if(Status_Run==0)
 {
  Status_Run=1;
  CNTE=1;
 }
 else
 {
  Status_Run=0;
  CNTE=0;
 }
}

//****************************************************************
//                    menu_second()
//
// Secondary Menu - need passcode to use any options
// This menu allows for programming of unprogrammed cards E2PROM
// And maybe some other functions
//****************************************************************
void menu_second(void)
{
 lcd_clear();
 lcd_puts("Extra Menu - NONE!!");
 Pause(1);
}


//****************************************************************
//               void load_card(char slot)
//****************************************************************
void load_card(char slot)
{
	char count;
 selectslot(slot);

 T_DATABUS=0x00;              //-- Ensure Output

// lcd_clear();
 for(count=0;count<4;count++)
 {
  selectregister(count);
  DATABUS=Start.bytes[count]; //-- Output Data to Port

  //-- Send Write Pulse --
  DelayMs(LC_DATASETTLE);                 //-- Delay for data to settle
  WR=0;                       //-- Write Pulse start
  DelayMs(LC_WRITE);
  WR=1;                       //-- Write Pulse Stop
  DelayMs(LC_WRITE);

//  printf("%d ",Start.bytes[count]);

 }

// lcd_goto(0x40);
 for(count=4;count<8;count++)
 {
  selectregister(count);
  DATABUS=Stop.bytes[count-4]; //-- Output Data to Port

  //-- Send Write Pulse --
  DelayMs(LC_DATASETTLE);            //-- Delay for data to settle
  WR=0;                      //-- Write Pulse start
  DelayMs(LC_WRITE);
  WR=1;                      //-- Write pulse stop
  DelayMs(LC_WRITE);

//  printf("%d ",Stop.bytes[count-4]);
 }

 T_DATABUS=0xFF;             //-- Float the Data Bus

// Pause(1);
 deselectslot();
}



//****************************************************************
//                 read_slot_data(char slot)
//
//        Reads slots Data settings from the EEPROM
//****************************************************************
void read_slot_data(char slot)
{
 selectslot(slot);
 //-- read in from I2C and store in Start.bytes[] and Stop.bytes[]
 slot=0;
 I2C_Send(0xA0,&slot,1);          //-- Set EEPROM to Address 0
 I2C_Read(0xA0,Start.bytes,4);    //-- Read Start Word

 slot=4;
 I2C_Send(0xA0,&slot,1);          //-- Set EEPROM to Address 4
 I2C_Read(0xA0,Stop.bytes,4);     //-- read Stop Word
 deselectslot();
}

//****************************************************************
//                write_slot_data(char slot)
//
// Writes current data settings to the EEPROM
//****************************************************************
void write_slot_data(char slot)
{
 char temp[6];

 selectslot(slot);
 //-- Write to I2C and store Start.bytes[] and Stop.bytes[]

 temp[0]=0;                     //-- Start Address of 0
 for(slot=1;slot<5;slot++)      //-- Copy data to be saved to temp
 {
   temp[slot]=Start.bytes[slot-1];
 }
 I2C_Send(0xA0,temp,5);          //-- Send the data
 DelayMs(10);        //-- Give plenty of time for the write cycle to complete

 temp[0]=4;                     //-- Start address of 4
 for(slot=1;slot<5;slot++)      //-- Copy data to temp
 {
  temp[slot]=Stop.bytes[slot-1];
 }
 I2C_Send(0xA0,temp,5);    //-- Send data
 DelayMs(10);                   //-- Delay to allow programming
 deselectslot();
}

//****************************************************************
//              void editslotdata(char slot)
//****************************************************************
void editslotdata(char slot)
{
 char x=0,y=0,c,done=0;
 char StartString[11],StopString[11];
 unsigned long int templong;

 read_slot_data(slot);


 lcd_clear();
 lcd_puts("Start:");
 lcd_goto(0x40);
 lcd_puts("Pulse:");

 while (!done)
 {
  sprintf(StartString,"%010lu",Start.Start*COUNT_RES); //#############################
  //-- Since sprintf wont pad with zeros then do it here
  c=0;
  while(StartString[c]!=0)
  {
 	 if(StartString[c]==' ') StartString[c]='0';
 	 c++;
  }

  if(Stop.Stop >=Start.Start)  //-- Calculate the Pulse Length (not stop Position)
  {
   Stop.Stop -= Start.Start;
  }
  else
  {
   Stop.Stop =0L;
  }



  templong=(Stop.Stop*COUNT_RES);  //-- Convert the pulse length
  if(OUTPUT_DIFFERENCE > templong) //-- Check if < minimum lenght
  {
   templong=MIN_PULSE-OUTPUT_DIFFERENCE;//-- If so indicate the minimum length
  }
  else
  {
   templong-=OUTPUT_DIFFERENCE;   //-- Else display the actual value
  }

  sprintf(StopString,"%010lu",templong); //################################
  //-- Since sprintf wont pad with zeros then do it here
  c=0;
  while(StopString[c]!=0)
  {
 	 if(StopString[c]==' ') StopString[c]='0';
 	 c++;
  }

  lcd_goto(7);
  puts(StartString);
  lcd_puts("ns");
  lcd_goto(0x40+7);
  puts(StopString);
  lcd_puts("ns");

  //-- Place Cursor at current position --
  if(y)
  {
   lcd_goto(0x40+7+x);
  }
  else
  {
   lcd_goto(x+7);
  }
  c=kgetch();
  switch(c)
  {
   case 'U':
    y=0;
    break;

   case 'D':
    y=1;
    break;

   case 'L':
    if(x>0) x--;
    break;

   case 'R':
    if(x<9) x++;
    break;

   case 'C':
   case 'E':
   case 'M':
    done =1;
    break;


//   case 'a':
//   case 'b':
//   case 'c':
//    break;

   default:
    if(c >='0' && c <='9')
    {
     if(y)
     {
      StopString[x]=c;
     }
     else
     {
      StartString[x]=c;
     }
     if(x<9) x++;
    }
  }

  //-- recalculate the values from the data input from User
  Start.Start=atoul(StartString) / COUNT_RES;
  if(Start.Start > 0x00FFFFFFL)
  {
   //-- Limit the start to 24Bit cause it is only a 24 bit card
   Start.Start = 0x00FFFFFFL;
  }
  //-- Recalculate Stop Data by adding it to the start data.
 // Stop.Stop=atoul(StopString)/COUNT_RES + Start.Start;
  templong=atoul(StopString);
  if(templong < OUTPUT_DIFFERENCE)
  {
   Stop.Stop=0;
  }
  else
  {
   Stop.Stop=(atoul(StopString)+ OUTPUT_DIFFERENCE)/COUNT_RES;
  }
  //-- Check if valid Data
  if(Stop.Stop <= (0x00FFFFFFL - Start.Start))
  {
   Stop.Stop+=Start.Start; //-- O.K So add the Start Length
  }
  else
  {
   Stop.Stop=0x00FFFFFFL; //-- Set to Max Length allowed
  }
 } //--- END OF WHILE LOOP

 lcd_clear();
 lcd_puts("  Upload and Save?");
 lcd_goto(0x45);
 lcd_puts("YES   NO");
 if(kgetch()=='a')
 {
  lcd_goto(0x42);
  lcd_puts("Saving......");
  //-- Save the data to EEPROM --
  write_slot_data(slot);

  //-- WRITE Data to the Card
  load_card(slot);
  DelayMs(120);
 }
}


//****************************************************************
//
//****************************************************************



