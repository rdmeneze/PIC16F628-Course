/*********************************************************************************************
 *  Arquivo principal. Projeto de teste para desenvolvimento de módulos de 
 *  controle de dispositivos em uma plataforma ACEPIC com processador PIC18 
 *  Compilador utilizado: PIC C18
 *  Autor : Rafael Dias Menezes
 *  Data  : Ago/2009
 *
 *  Deve ser dada atenção às palavras de configuração para operação 
 *  do sistema. Vide help do MPLAB.
 *
 *********************************************************************************************/

#include "defs.h"
#include "processor.h"
#include "timer.h"
#include "LCD.h"
#include "gps.h"
#include "delay.h"
#include <stdio.h>
#include <string.h>

// configuration words
#pragma config OSC      = XT
#pragma config PWRT     = OFF
#pragma config BOREN    = ON
#pragma config BORV     = 0
#pragma config WDT      = OFF
#pragma config MCLRE    = ON
#pragma config PBADEN   = OFF
#pragma config LVP      = OFF

//----------------------------------------------------------------------


//----------------------------------------------------------------------

void main( void ){
    BYTE i;
    char cBuffer[16];
    
    
    LCD_Init( );
    InitTimer( );
    
    InitTimer( );
    
    InitGPS(  );
    
    printf( "\f" );
    
    
    for (;;){
      
      i = GPSProcess();
      switch( i ){
        case GPGGA:
          sprintf( cBuffer,"GPGGA prot" );
          break;
        case GPGSA: 
          sprintf( cBuffer,"GPGSA prot" );
          break;
        case GPGSV: 
          sprintf( cBuffer,"GPGSV prot" );
          break;
        case GPRMC: 
          sprintf( cBuffer,"GPRMC prot" );
          break;
        case GPVTG: 
          sprintf( cBuffer,"GPVTG prot" );
          break;
        case GPGLL:
          sprintf( cBuffer,"GPGLL prot" );
          break;
        default:
          i = -1;
      }
      
      if ( i != -1 )
        printf( "%s", cBuffer );
    }
    
    return;
}

