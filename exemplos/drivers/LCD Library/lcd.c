#include "lcd.h"
#include "delay.h"

void lcd_init(void)
{

    //ADCON1 = 0x07;
    lcd_db_tris = 0x00;
    lcd_cnt_tris = 0x00;

//This is our lcd initialization function
    delay_ms(20);                   // Wait at least 16 mS after powerup

	lcd_nybble(0x03,0);             //send 0x03 cmd 3 times to initialize
	delay_ms(5);

	lcd_e_togg();                   //Since 0x03 nybble is on the port already
	delay_us(160);                  // we just toggle 2 more times

	lcd_e_togg();
	delay_us(160);

	lcd_nybble(0x02,0);             //Enable 4 bit mode
	delay_ms(1);

	lcd_cmd(0x28);					//set 4-bit mode and 2 lines @ 5x7
	delay_us(160);

	lcd_cmd(0x10);					//cursor move & shift left
	delay_us(160);

	lcd_cmd(0x06);					//entry mode = increment
	delay_us(160);

	lcd_cmd(0x0d);					//display on - cursor blink on
	delay_us(160);

	lcd_cmd(0x01);					//clear display
	delay_us(160);

    delay_ms(5);
}

void lcd_e_togg (void)
{
//This is our toggle E line function to 
//tell lcd to accept data
    lcd_e=1;
    lcd_e=0;
}

void lcd_cmd(unsigned char letter)
{
//This is our Command Function
//The RS is set to 0 to signify this is a command
	unsigned char temp;             //Our temp Variable

	temp=letter;                    //move letter to temp
	temp=temp>>4;                   //shift temp to right by 4
	lcd_nybble(temp,0);             //send the 4 out

	temp=letter;                    //move letter to temp
	temp=temp&0x0f;                 //and out first 4
	lcd_nybble(temp,0);             //send out last 4

    delay_us(10);
}

void lcd_char(unsigned char letter)
{
//This is the same as the lcd_cmd function except
//that is sets RS to 1 telling the lcd this is characters
	unsigned char temp;

	temp=letter;
	temp=temp>>4;
	lcd_nybble(temp,1);

	temp=letter;
	temp=temp&0x0f;
	lcd_nybble(temp,1);
}

void lcd_string(char *senpoint, char Line)
{
    if(Line == 1)
        lcd_cmd(Line1);
    else
        lcd_cmd(Line2);

	while(*senpoint != '\0')            // While we havent seen a \0 (esc) go on
	{
		lcd_char(*senpoint);            // Send 1st char to our char function
		senpoint++;                     // Send next
	}

    delay_us(10);
}
void lcd_nybble(unsigned char nyb,char rs)
{
	char i;
    char x;

    lcd_rs = rs;                    // Set RS Pin (defined in header file)

	for(i=0;i<4;i++){				// Loop through nybble

        if((nyb & 0x08) != 0)       // AND the nybble to 8
			x=1;                    // If the AND == 1 set x
		else
			x=0;                    // If the AND == 0 clear x

	    if(i==0)                    // Select RA3:RA0 and set or clear pins
            lcd_DB7=x;

        if(i==1)
            lcd_DB6=x;

        if(i==2)
            lcd_DB5=x;

        if(i==3)
            lcd_DB4=x;


        nyb=nyb<<1;                 // Shift nybble to the left by 1 (4 times total)
	}

	lcd_e_togg();                   // Toggle E pin (defined in header file)
}

void lcd_clr_line(char line)
{
//This is our clear line command.
    char tline;                             // The line to clear variable
    char x;                                 // loop variable

    if(line==0)                             // Set the variable value based on line
        tline=0x80;                         // 0 = Line 1
    else
        tline=0xA8;                         // 1 = Line 2

    lcd_cmd(tline);                         // Send command to jump to beggining of line (1/2)
    delay_ms(1);

    for(x=0;x<40;x++){                      // Loop through all 40 chars of line (even tho 16 are viewable)
        lcd_char(0x20);                     // Send Blank Character
        delay_us(50);                  
    }

    lcd_cmd(tline);                         // Go back to beggining of line
    delay_ms(1);
}