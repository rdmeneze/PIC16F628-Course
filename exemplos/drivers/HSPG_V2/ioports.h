//*******************************************************************
//                            ioports.h
//
// This header file defines the port names for the HSPG V2 project
//
//*******************************************************************

#ifndef BITNUM
 #define BITNUM(adr, bit) ((unsigned)(&adr)*8+(bit))  //-- used for port defs
#endif

static bit CNTE       @ BITNUM(PORTC,6);  //-- CNTE - Count Enable
static bit T_CNTE     @ BITNUM(TRISC,6);

static bit WR         @ BITNUM(PORTE,1);  //-- WRITE Control Bit
static bit T_WR       @ BITNUM(TRISE,1);

static bit RD         @ BITNUM(PORTE,0);  //-- READ Control Bit
static bit T_RD       @ BITNUM(TRISE,0);

static bit SSEL       @ BITNUM(PORTC,7);  //-- Slot Select Active Bit
static bit T_SSEL     @ BITNUM(TRISC,7);

static bit SA0        @ BITNUM(PORTA,2);  //-- Slot Select Addr Bit 0
static bit T_SA0      @ BITNUM(TRISA,2);
static bit SA1        @ BITNUM(PORTA,1);  //-- Slot Select Addr Bit 1
static bit T_SA1      @ BITNUM(TRISA,1);
static bit SA2        @ BITNUM(PORTA,0);  //-- Slot Select Addr Bit 2
static bit T_SA2      @ BITNUM(TRISA,0);

static bit SDA        @ BITNUM(PORTC,4);  //-- I2C Serial Data
static bit T_SDA      @ BITNUM(TRISC,4);
static bit SDA_TRIS   @ BITNUM(TRISC,4);
static bit SCL        @ BITNUM(PORTC,5);  //-- I2C Serial Clock
static bit T_SCL      @ BITNUM(TRISC,5);
static bit SCL_TRIS   @ BITNUM(TRISC,5);

#define DATABUS       PORTD               //-- Data bus
#define T_DATABUS     TRISD

static bit A0         @ BITNUM(PORTA,5);  //-- Card Register Address 0
static bit T_A0       @ BITNUM(TRISA,5);
static bit A1         @ BITNUM(PORTA,4);  //-- Card Register Address 1
static bit T_A1       @ BITNUM(TRISA,4);
static bit A2         @ BITNUM(PORTA,3);  //-- Card Register Address 2
static bit T_A2       @ BITNUM(TRISA,3);

static bit SS         @ BITNUM(PORTE,2);  //-- Spear Signal - maybe Buzzer
static bit T_SS       @ BITNUM(TRISE,2);

#define    KDI        PORTC               //-- Keyboard Data In (Low 4 bits)
#define    T_KDI      TRISC
static bit KRCK       @ BITNUM(PORTB,6);  //-- Keyboard Row Sel Clock
static bit T_KRCK     @ BITNUM(TRISB,6);
static bit KRR        @ BITNUM(PORTB,7);  //-- Keyboard Row Sel RESET
static bit T_KRR      @ BITNUM(TRISB,7);

#define    LCD_DATA   PORTB               //-- LCD Data (Low 4 bits)
#define    T_LCD_DATA TRISB
static bit LCD_RS     @ BITNUM(PORTB,4);  //-- LCD RS Control
static bit T_LCD_RS   @ BITNUM(TRISB,4);
static bit LCD_EN     @ BITNUM(PORTB,5);  //-- LCD E Control
static bit T_LCD_EN   @ BITNUM(TRISB,5);
	
