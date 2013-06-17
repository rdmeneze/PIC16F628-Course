#include "xLCD.h"
#include "delay.h"

//----------------------------------------------
#define EN_Strobe E_PIN = 1; \
                  Nop(); \
                  Nop(); \
                  E_PIN = 0;\
                  Nop();

//----------------------------------------------

void xLCD_Init(void){
  BYTE bTimer;
  BYTE i;
  
  TRIS_xLCD_PORT = TRIS_LCD_MASK;
  xLCD_PORT = 0x00;
  
  TRIS_E  = 0;
  TRIS_RS = 0;
  
  E_PIN   = 0;
  RS_PIN  = 0;
  
  delay(60);
    
  for ( i = 0; i < 3; i++ ){
    xLCD_PORT = 0x03;
    delay(10);  
  } 
  
  xLCD_PORT = 0x02;
  delay( 15 );
  
  xLCD_SendCmd( 0x28 );
  delay( 2 );
  
  xLCD_SendCmd( 0x08 );
  delay( 2 );
  
  xLCD_SendCmd( 0x01 );
  delay( 2 );
  
  xLCD_SendCmd( 0x06 );
  delay( 2 );
  
  xLCD_SendCmd( 0x0C );
  delay( 2 );
  
  return;  
}

void xLCD_SendCmd( BYTE cmd ){
#ifdef DATA_BIT8
#else
  RS_PIN = 0;
  xLCD_PORT   = (cmd >> 4) &  0x0F;
  EN_Strobe;
  
  xLCD_PORT   = (cmd) &  0x0F;
  EN_Strobe;
 
#endif
}

void xLCD_SendData( BYTE data ){
}

void xLCD_puts( char * data ){
}
