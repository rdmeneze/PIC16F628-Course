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
#include "FSIO.h"
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



char sendBuffer[22] = "This is test string 1";
char send2[2] = "2";
char receiveBuffer[50];

char dirname1[16] = ".\\ONE\\TWO\\THREE";
char dirname2[14] = "ONE\\TWO\\THREE";
char dirname3[14] = "FOUR\\FIVE\\SIX";
char dirname4[60] = "FOUR\\FIVE\\SEVEN\\..\\EIGHT\\..\\..\\NINE\\TEN\\..\\ELEVEN\\..\\TWELVE";
char dirname5[31] = "\\ONE\\TWO\\THREE\\FOUR\\FIVE\\EIGHT";
char dirname6[10] = "FOUR\\NINE";
char dirname7[2];


//----------------------------------------------------------------------

void main( void ){
    BYTE i;
    char cBuffer[16];
    
    FSFILE * pointer;
    char path[30];
    char count = 30;
    char * pointer2;
    SearchRec rec;
    unsigned char attributes;
    unsigned char size = 0;

    while (!MDD_MediaDetect());    
    
    
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

