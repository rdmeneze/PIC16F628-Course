#include <p18F248.h>
#include <stdio.h>

#pragma config WDT = OFF, OSC = HS, LVP = OFF
char string[16];

void main (void){
    lcd_init();                             //Launch Initialize function

	sprintf(string,"    AtomSoft    ",0);   //Set our character array(string) (max 16 Chars)
	lcd_string(string,1);                   //Send our string.

	sprintf(string,"   Technology   ",0);   //Set our character array(string) (max 16 Chars)
	lcd_string(string,2);                   //Send our string.

    while(1);                               //Main Loop
}