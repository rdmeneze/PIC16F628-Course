# MPLAB IDE generated this makefile for use with GNU make.
# Project: teste.mcp
# Date: Wed Sep 02 00:24:27 2009

AS = MPASMWIN.exe
CC = mcc18.exe
LD = mplink.exe
AR = mplib.exe
RM = rm

teste.cof : funcoes.o interrupt.o main.o timer.o delay.o LCD.o gps.o serial.o
	$(LD) /p18F4620 /l"C:\MCC18\lib" "funcoes.o" "interrupt.o" "main.o" "timer.o" "delay.o" "LCD.o" "gps.o" "serial.o" /u_CRUNTIME /z__MPLAB_BUILD=1 /m"teste.map" /w /o"teste.cof"

funcoes.o : funcoes.c funcoes.h ../../../../../../MCC18/h/ctype.h funcoes.c defs.h ../../../../../../MCC18/h/stddef.h
	$(CC) -p=18F4620 "funcoes.c" -fo="funcoes.o" -mL -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-

interrupt.o : interrupt.c timer.h serial.h interrupt.c defs.h ../../../../../../MCC18/h/stddef.h processor.h ../../../../../../MCC18/h/p18cxxx.h ../../../../../../MCC18/h/p18f4620.h interrupt.h
	$(CC) -p=18F4620 "interrupt.c" -fo="interrupt.o" -mL -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-

main.o : main.c timer.h ../../../../../../MCC18/h/stdio.h LCD.h delay.h ../../../../../../MCC18/h/string.h main.c defs.h ../../../../../../MCC18/h/stddef.h processor.h ../../../../../../MCC18/h/p18cxxx.h ../../../../../../MCC18/h/p18f4620.h ../../../../../../MCC18/h/stdarg.h gps.h
	$(CC) -p=18F4620 "main.c" -fo="main.o" -mL -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-

timer.o : timer.c timer.h funcoes.h ../../../../../../MCC18/h/string.h timer.c defs.h ../../../../../../MCC18/h/stddef.h processor.h ../../../../../../MCC18/h/p18cxxx.h ../../../../../../MCC18/h/p18f4620.h
	$(CC) -p=18F4620 "timer.c" -fo="timer.o" -mL -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-

delay.o : delay.c timer.h delay.c defs.h ../../../../../../MCC18/h/stddef.h processor.h ../../../../../../MCC18/h/p18cxxx.h ../../../../../../MCC18/h/p18f4620.h
	$(CC) -p=18F4620 "delay.c" -fo="delay.o" -mL -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-

LCD.o : LCD.C timer.h ../../../../../../MCC18/h/stdio.h lcd.h delay.h funcoes.h LCD.C defs.h ../../../../../../MCC18/h/stddef.h processor.h ../../../../../../MCC18/h/p18cxxx.h ../../../../../../MCC18/h/p18f4620.h ../../../../../../MCC18/h/stdarg.h
	$(CC) -p=18F4620 "LCD.C" -fo="LCD.o" -mL -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-

gps.o : gps.c serial.h delay.h funcoes.h ../../../../../../MCC18/h/string.h ../../../../../../MCC18/h/stdlib.h ../../../../../../MCC18/h/ctype.h gps.c gps.h defs.h ../../../../../../MCC18/h/stddef.h processor.h ../../../../../../MCC18/h/p18cxxx.h ../../../../../../MCC18/h/p18f4620.h ports.h
	$(CC) -p=18F4620 "gps.c" -fo="gps.o" -mL -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-

serial.o : serial.c serial.h funcoes.h ../../../../../../MCC18/h/delays.h serial.c defs.h ../../../../../../MCC18/h/stddef.h processor.h ../../../../../../MCC18/h/p18cxxx.h ../../../../../../MCC18/h/p18f4620.h
	$(CC) -p=18F4620 "serial.c" -fo="serial.o" -mL -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-

clean : 
	$(RM) "funcoes.o" "interrupt.o" "main.o" "timer.o" "delay.o" "LCD.o" "gps.o" "serial.o" "teste.cof" "teste.hex" "teste.map"

