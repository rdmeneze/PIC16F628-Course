#include "timer.h"
#include "serial.h"
#include "interrupt.h"


extern SERIALCOMFUNC   *isrSerialFunc;

#pragma code high_vector=0x08
void interrupt_at_high_vector(void)
{
  _asm GOTO InterruptHandler _endasm
}
#pragma code /* return to the default code section */


#pragma interrupt InterruptHandler
void InterruptHandler( void )
{
	if ( PIR1bits.TMR2IF )
	{
		IncTickCount( );
		PIR1bits.TMR2IF = 0;
	}

	while ( PIR1bits.RCIF ) {
  	
  	if ( RCSTAbits.FERR ) {
    	//RCSTAbits.FERR = 0;
    	SerialGetchar();
    	continue;
    }

    if ( RCSTAbits.OERR ) {
    	//RCSTAbits.OERR = 0;
    	RCSTAbits.CREN ^= 1;
    	Nop();
      RCSTAbits.CREN ^= 1;    	
    	continue;
    }
    
  	if ( isrSerialFunc ){
    	 (*isrSerialFunc)(); 
    }  	
  }
}

//--------------------------------------------------------

#pragma code low_vector=0x18
void interrupt_at_low_vector(void)
{
  _asm GOTO InterruptHandlerLow _endasm
}
#pragma code /* return to the default code section */


#pragma interrupt InterruptHandlerLow
void InterruptHandlerLow( void )
{
  return;
}
//--------------------------------------------------------
