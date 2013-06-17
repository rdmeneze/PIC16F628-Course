#ifndef	__PROCESSOR__
#define	__PROCESSOR__

/* some include files to work with PIC18 family */
#include <p18cxxx.h>
#include <p18f4620.h>
#include "defs.h"

#define XTAL    8000000
#define PLL     4

#if     PLL==1
#elif   PLL==4
#else
  #error "Wrong value to PLL macro"
#endif

#define FOSC    XTAL*PLL         // oscilator frequency

#endif
