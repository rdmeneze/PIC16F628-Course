#ifndef __PORTS__
#define __PORTS__

#include "processor.h"

// GPS ports definitions
#define GPS_TX      LATCbits.LATC6     // data out
#define GPS_RX      LATCbits.LATC7     // data out
#define GPS_TX_DIR  TRISCbits.TRISC6
#define GPS_RX_DIR  TRISCbits.TRISC7
#define GPS_RST     LATCbits.LATC2
#define GPS_RST_DIR TRISCbits.TRISC2

#endif
