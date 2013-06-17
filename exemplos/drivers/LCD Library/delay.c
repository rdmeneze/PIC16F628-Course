#include "delay.h"

int d_tmp;              //delay calculation temp
int lt,lt2;             //loop temp

void delay_s(int sec)
{
     d_tmp = (d_mhz / 4) / 10000;

     for(lt=0;lt<sec;lt++)
          Delay10KTCYx(d_tmp);
}
void delay_ms(int msec)
{
     d_tmp = (d_mhz / 4) / 1000000;

     for(lt=0;lt<msec;lt++)
          Delay1KTCYx(d_tmp);
}
void delay_us(int usec)
{
     d_tmp = (d_mhz / 4) / 1000000;

     for(lt=0;lt<usec;lt++) {
          for(lt2=0;lt2<d_tmp;lt2++)
              Delay1TCY();
     }
}