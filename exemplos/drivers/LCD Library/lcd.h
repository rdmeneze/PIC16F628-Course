#ifndef __LCD_H
#define __LCD_H

#define lcd_rs LATBbits.LATB1          // define RS Pin
#define lcd_e LATBbits.LATB0	       // define E Pin

#define lcd_DB7 LATAbits.LATA3         // define LCD Data Bit 7
#define lcd_DB6 LATAbits.LATA2         // define LCD Data Bit 6
#define lcd_DB5 LATAbits.LATA1         // define LCD Data Bit 5
#define lcd_DB4 LATAbits.LATA0         // define LCD Data Bit 4

#define lcd_db_tris TRISB	           // define LCD Data Bits TRIS
#define lcd_cnt_tris TRISA	           // define LCD Control Bits TRIS


#define Line1 0x80
#define Line2 0xC0

void lcd_init(void);
void lcd_e_togg (void);
void lcd_cmd (unsigned char cmd);
void lcd_char (unsigned char tchar);
void lcd_string (char *, char Line);
void lcd_nybble(unsigned char data,char rs);
void lcd_clr_line(char line);
void def_custom(unsigned char bank,unsigned char r1,unsigned char r2,unsigned char r3,unsigned char r4,unsigned char r5,unsigned char r6,unsigned char r7,unsigned char r8);
#endif