///////////////////////////////////////////////////////////////////////////////
//                                                                           // 
//                    Placa de desenvolvimento ACE PIC 40                    // 
//                                                                           //
// Projeto:    Fazer com que os Displays de 7 segmentos funcionem            //
// Obs.:       Fechar os Jumpers DSP1, DSP2 DSP3 e DSP4                      //
// Compilador: CCS C                                                         //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

#include <16F877A.H>
#use delay(clock=8000000)
#fuses HS,NOWDT,PUT,NOBROWNOUT,NOLVP

void main(void)
{
Set_Tris_A(0x00);

Output_D(0xFF);
           Output_low(PIN_A5);
           Output_High(PIN_A2);
           delay_ms(500);
           Output_D(0xFF);
           Output_low(PIN_A2);
           Output_High(PIN_A3);
           delay_ms(500);
           Output_D(0xFF);
           Output_low(PIN_A3);
           Output_high(PIN_A4);
           delay_ms(500);
           Output_D(0xFF);
           Output_low(PIN_A4);
           Output_high(PIN_A5);
           delay_ms(500);

while(true)
           {
           Output_D(0xFF);
           Output_low(PIN_A5);
           Output_High(PIN_A2);
           delay_ms(5);
           Output_D(0xFF);
           Output_low(PIN_A2);
           Output_High(PIN_A3);
           delay_ms(5);
           Output_D(0xFF);
           Output_low(PIN_A3);
           Output_high(PIN_A4);
           delay_ms(5);
           Output_D(0xFF);
           Output_low(PIN_A4);
           Output_high(PIN_A5);
           delay_ms(5);
           }
}
