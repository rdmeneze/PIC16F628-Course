/**
 *  Module to control the time run in the application
 *  Autor   :   Rafael Dias Menezes (rdmeneze@yahoo.com.br)
 *  Date    :   Ago/2009
 */

#ifndef __TIMER__
#define __TIMER__

#include "defs.h"
#include "processor.h"

/** 
 *  Initialize the timer engine
 */
void InitTimer( void );

/**
 *  Get the actual tick timer counter value
 *  \return DWORD   tick count
 */
DWORD GetTickCount( void );

/**
 *  \brief Get a timer handle to a dwTimeValue timer value
 *  \param dwTime time (in time units) to signal
 *  \return BYTE timer handle
 */
BYTE GetTimer( DWORD dwTime );

/**
 *  \brief Release a timer
 *  \param handle Handle of timer to release
 */
void ReleaseTimer( BYTE * handle );

/**
 *  \brief  Verify if the timer overflows
 *  \param  handle  Handle to timer
 *  \return Overflow condition
 */
BYTE IsTimerTimeOut( BYTE handle );

/**
 *  \brief  Increase the counter 
 */
void IncTickCount( void );

#endif
