//! 
//!   Modulo para controle da interface serial
//!   Autor : Rafael Dias
//!   Data  : Ago/2009
//!

#include "serial.h"
#include "processor.h"
#include "funcoes.h"
#include <delays.h>

#define BRGH  1
#define BRG16 1


/**
 * Possiveis baudrates
 */
const DWORD BaudRate[] = {  
                      300L,
                      1200L,
                      2400L,
                      9600L,
                      19200L,
                      38400L,
                      57600L,
                      115200L  
                      };
               
#if ( BRGH == 1 ) && (BRG16 == 1)
/**
 * valores prá-calculados para a carga de BRG:BRGU
 */                      
const WORD  BRGValues[] = { 
                      6666L,
                      1666L,
                      832L,
                      207L,
                      103L,
                      51L,
                      34L,
                      16L
                    };
#else
  #error  "BRGH or BRG16 don't defined values"
#endif

SERIALCOMFUNC   *isrSerialFunc;       //! ponteiro para função qye será responsável pelo tratamento dos dados recebidos via serial.
                                      //! com isso, a responsabilidade de tratamento de dados será passada para o modulo que chamou o 
                                      //! módulo de comunicaçõao serial
BYTE        cSerialBaudRate;      
BYTE        cSerialStopBits;
BYTE        cSerialParidade;

//--------------------------------------------------------------------------------------------

void InitSerial( BYTE port, BYTE baudRate, BYTE stopBits, BYTE par, SERIALCOMFUNC*  func ){
  
  WORD wTmp;
  BYTE i;
  
  // configuração do port serial
  INTCON  &= ~(BIT6 | BIT7);    //  GIE = 0; PEIE = 0;
  PIR1    &= ~(BIT4 | BIT5);    //  RCIF = 0
  PIE1    &= ~(BIT4 | BIT5);    //  RCIE = 0
  IPR1    &= ~(BIT4 | BIT5);    //  RCIP = 0
  RCSTA   &= ~(BIT7 | BIT2 | BIT1);  
  
  if ( baudRate > GET_VEC_NUM_MEMBERS(BaudRate) ){
    baudRate = BR_9600;
  }
  
  if ( stopBits > ST_2 ){
    stopBits = ST_1;
  }
  
  if ( par > PR_EVEN ){
    par = PR_NONE;
  }
  
  cSerialBaudRate = baudRate;
  cSerialParidade = par;
  cSerialStopBits = stopBits;
  
  // atribui o valor do baudrate
  wTmp = BRGValues[cSerialBaudRate];
  SPBRG = wTmp;
  
  #if (BRG16 == 1)
    SPBRGH = wTmp/256;
  #endif
  
  // configura portas como entrada
  TRISC |= (BIT7 | BIT6);       // TRISC.7 e TRISC.6 => entradas
  
  #if (BRG16 == 1)
    BAUDCON |= BIT3;
  #endif
  
  PIR1    |= BIT5;    //  RCIF = 1
  PIE1    |= BIT5;    //  RCIE = 1
  RCSTA   |= (BIT7 | BIT4);  // SPEN = 1
                             // CREN = 1
  INTCON  |= (BIT6 | BIT7);
                             
  if ( func != NULL ){
    isrSerialFunc = func;
  }
  
  return;
}

//--------------------------------------------------------------------------------------------

BYTE GetSerialBaudRate( void ){
  return cSerialBaudRate;
}

//--------------------------------------------------------------------------------------------

BYTE GetSerialStopBits( void ){
  return cSerialStopBits;
}

//--------------------------------------------------------------------------------------------

BYTE GetSerialParidade( void ){
  return cSerialParidade;
}

//--------------------------------------------------------------------------------------------

BYTE SerialGetchar( void ){
  return RCREG;
}

//--------------------------------------------------------------------------------------------

void SerialPutc( BYTE c ){
  
  while( PIR1bits.TXIF == 0 && TXSTAbits.TRMT == 0 );
  
  TXREG = c;
  
  while( PIR1bits.TXIF == 0 && TXSTAbits.TRMT == 0 );
  
  Delay100TCYx( 5 );
}

//--------------------------------------------------------------------------------------------

void ReceiveOff( void ){
  RCSTAbits.CREN  = 0;
  RCSTAbits.SPEN  = 0;
  PIR1bits.RCIF   = 0;
  PIE1bits.RCIE   = 0;
  
  return;  
}

//--------------------------------------------------------------------------------------------

void ReceiveOn( void ){
  RCSTAbits.CREN = 1;
  RCSTAbits.SPEN = 1;
  PIE1bits.RCIE = 1;

	while ( PIR1bits.RCIF ) {
  	
  	if ( RCSTAbits.FERR ) {
    	RCSTAbits.FERR = 0;
    	continue;
    }

    if ( RCSTAbits.OERR ) {
    	RCSTAbits.OERR = 0;
    	continue;
    }
  	SerialGetchar();
  }
  return;
}

//--------------------------------------------------------------------------------------------
