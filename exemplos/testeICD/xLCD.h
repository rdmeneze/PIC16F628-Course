/**
 *  Module for control the LCD port
 *  Author  : Rafael Dias Menezes
 *  Date    : Ago/2009
 */

#ifndef __XLCD__
#define __XLCD__

#include "defs.h"
#include "processor.h"


/*#define DATA_BIT8*/

#define LCD_MASK        0x0F
#define TRIS_LCD_MASK   0xF0


#define xLCD_PORT         LATD
#define TRIS_xLCD_PORT    TRISD

/* CTRL_PORT defines the port where the control lines are connected.
 * These are just samples, change to match your application.
 * Note : I don't using the RW port
 */
#define RS_PIN   LATEbits.LATE0        /* PORT for RS */ 
#define TRIS_RS  TRISEbits.TRISE0     /* TRIS for RS */ 
#define E_PIN    LATEbits.LATE1        /* PORT for D  */ 
#define TRIS_E   TRISEbits.TRISE1     /* TRIS for E  */


/* Display ON/OFF Control defines */
#define DON         0b00001111  /* Display on      */
#define DOFF        0b00001011  /* Display off     */
#define CURSOR_ON   0b00001111  /* Cursor on       */
#define CURSOR_OFF  0b00001101  /* Cursor off      */
#define BLINK_ON    0b00001111  /* Cursor Blink    */
#define BLINK_OFF   0b00001110  /* Cursor No Blink */

/* Cursor or Display Shift defines */
#define SHIFT_CUR_LEFT    0b00010011  /* Cursor shifts to the left   */
#define SHIFT_CUR_RIGHT   0b00010111  /* Cursor shifts to the right  */
#define SHIFT_DISP_LEFT   0b00011011  /* Display shifts to the left  */
#define SHIFT_DISP_RIGHT  0b00011111  /* Display shifts to the right */

/* Function Set defines */
#define FOUR_BIT   0b00101111  /* 4-bit Interface               */
#define EIGHT_BIT  0b00111111  /* 8-bit Interface               */
#define LINE_5X7   0b00110011  /* 5x7 characters, single line   */
#define LINE_5X10  0b00110111  /* 5x10 characters               */
#define LINES_5X7  0b00111011  /* 5x7 characters, multiple line */



/**
 *  \brief xLCDInit  Initialize a xLCD 
 */
void xLCD_Init(void);

/**
 *  xLCD_SendCmd  send a command to xLCD 
 *  \param  cmd Command to send
 */
void xLCD_SendCmd( BYTE cmd );

/**
 *  xLCD_SendData  send a data to xLCD 
 *  \param  data Data to send
 */
void xLCD_SendData( BYTE data );

#define xLCD_putc xLCD_SendData

/**
 *  xLCD_puts  send a string to xLCD 
 *  \param  *data String to send
 */
void xLCD_puts( char * data );




#endif
