/**
 *  Implementation of Timer module
 *  Autor   :   Rafael Dias Menezes
 *  Date    :   Ago/2009
 */

#include "timer.h"
#include "funcoes.h"
#include <string.h>

#define NTIMER  32

// increment timer value
#define TICK_VALUE  1

//  TIMER2 POST CALER
#define T2POST_1_1    0
#define T2POST_1_2    1
#define T2POST_1_3    2
#define T2POST_1_4    3
#define T2POST_1_5    4
#define T2POST_1_6    5
#define T2POST_1_7    6
#define T2POST_1_8    7
#define T2POST_1_9    8
#define T2POST_1_10   9
#define T2POST_1_11   10
#define T2POST_1_12   11
#define T2POST_1_13   12
#define T2POST_1_14   13
#define T2POST_1_15   14
#define T2POST_1_16   15

// TIMER2 PRESCALER
#define T2PRE_1_1     0
#define T2PRE_1_4     1
#define T2PRE_1_16    3

//------------ Module local variables ------------

struct Timer{
  BYTE    bTimer;
  DWORD   dwTime;
};

struct Timer timer[NTIMER];
DWORD   dwTickCount;
BYTE    tmInit = FALSE;

//------------------------------------------------

void InitTimer( void ){
  if ( tmInit == TRUE ){
    return;
  }

  memset( (char*)&timer, -1, sizeof( timer ));
  dwTickCount = 0;
  
  // configures the TIMER 2 module to overflow in TICK_VALUE ms 
  #if TICK_VALUE == 1
    T2CON = (T2POST_1_16 << 3) | T2PRE_1_1;
    PR2   = 124;              // veja cálculo
  #endif
  
  // configures the interruption
  INTCON  &= ~(BIT7 | BIT6);    // desabilita todas as interupções
  PIE1    |=  BIT1;              // habilita interrupção do timer 2  
  IPR1    |=  BIT1;              // atribui a prioridade da interropção do T2 para alta prioridade.
  PIR1    &= ~BIT1;
  RCON    |=  BIT7;
  INTCON  |= (BIT7 | BIT6);  
  
  T2CON   |= BIT2;              // liga o timer 2
  
  tmInit = TRUE;
  
  return;  
}

//------------------------------------------------

DWORD GetTickCount( void ){
  return dwTickCount;
}

//------------------------------------------------

void IncTickCount( void ){
  dwTickCount += TICK_VALUE;
}

//------------------------------------------------

BYTE GetTimer( DWORD dwTime ){
  BYTE i;
  
  if ( tmInit == FALSE ){
    InitTimer();
  }
  
  for ( i = 1; i < GET_VEC_NUM_MEMBERS(timer);i++ ){
    if ( timer[i].bTimer == -1 ){
      timer[i].bTimer     = i;
      timer[i].dwTime     = dwTime + dwTickCount;
      return i;
    }
  }
  
  timer[0].bTimer     = i;
  timer[0].dwTime     = dwTime + dwTickCount;
  return 0;
}

//------------------------------------------------

void ReleaseTimer( BYTE * handle ){

  if ( tmInit == FALSE ){
    InitTimer();
  }
  
  if ( *handle > GET_VEC_NUM_MEMBERS(timer) ){
    return;
  }
  
  memset( (char*)&timer[* handle], -1, sizeof( struct Timer ) );
  return; 
}

//------------------------------------------------

BYTE IsTimerTimeOut( BYTE handle ){
  
  if ( tmInit == FALSE ){
    InitTimer();
  }
  
  if ( handle > GET_VEC_NUM_MEMBERS(timer) ){
    return TRUE;
  }
  
  if ( timer[handle].dwTime < dwTickCount  ) 
    return TRUE;
  
  return FALSE;
}

//------------------------------------------------

