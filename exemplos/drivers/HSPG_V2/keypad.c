//****************************************************************
//                          keypad.c
//                       Version 0.1.1
//
// The following routines allow the control and decoding of the
// two keypad matrisees attached to the HSPG V2 Controller
//
// External Functions:
//     kgetch()  - waits for a keypad input and returns the keys character
//
//     khit() - scans the keypad once - if hit - indicates so (+ stores it)
//
//****************************************************************
//                    VERSION INFORMATION
//****************************************************************
// V0.1.1
// 27 June 2000
// Changed Pulse timing to a #define value so can play with it
//----------------------------------------------------------------
// V0.1.0
// 20 June 2000
// Original Writing of these Routines
// Scan the Keypad and convert the data
//
//****************************************************************

#define SCANPULSE 1     //-- Length of time for the Address Clock

//----- VARIABLES ---------
char k_buffer;


//----- FUNCTION DECLARATIONS -----
char kgetch(void);
char khit(void);

//void ktest(void); //-- Just scans keypad and prints number

//****************************************************************
//                      kgetch()
//
// Scan Keyboard until key pressed - return the decoded character
//****************************************************************
char kgetch(void)
{
 char c;
 while (!khit());   //-- Wait for Key Press
 c=k_buffer;
 while(khit());     //-- Wait for Key release

 switch(c)          //-- Decode the data
 {
  case 13:
   return('0');

  case 30:
   return('1');

  case 29:
   return('2');

  case 27:
   return('3');

  case 46:
   return('4');

  case 45:
   return('5');

  case 43:
   return('6');

  case 62:
   return('7');

  case 61:
   return('8');

  case 59:
   return('9');

  case 55:
   return('U');

  case 7:
   return('D');

  case 39:
   return('L');

  case 23:
   return('R');

  case 14:
   return('C');

  case 11:
   return('E');

  case 78:
   return('M');

  case 77:
   return('a');

  case 75:
   return('b');

  case 71:
   return('c');

 }
 return(0);
}

//****************************************************************
//                 char khit(void)
//****************************************************************
char khit(void)
{
 char count; //pulse,num=1;
 //-- Reset the Keypad counter
 KRR=0;
 DelayMs(SCANPULSE);
 KRR=1;
 DelayMs(SCANPULSE);
 k_buffer=0;


 for(count=0;count<8;count++)
 {
  if((KDI & 0x0F)!= 0x0F)  //-- check if any of the lower 4 bits is LOW
  {
   //-- New data so combine the position Value and the data
   count=count<<4;
   k_buffer=KDI & 0x0F;
   k_buffer |= count;
   return(1);
  }

   KRCK=1;
   DelayMs(SCANPULSE);
   KRCK=0;
   DelayMs(SCANPULSE);
 }

 return(0);
}


//****************************************************************
//                  void ktest(void)
//          Just scans keypad and prints number
//****************************************************************
/*
void ktest(void)
{
 lcd_clear();
 printf("Key Test");
 Pause(1);
 while(1)
 {
  while(!khit());
  lcd_clear();
  printf("Key =  %d  ",k_buffer);
  Pause(1);
 }
}
*/

//****************************************************************
//
//****************************************************************



