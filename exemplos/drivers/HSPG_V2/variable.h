//********************************************************************
//                        variable.h
//
// this file holds the global variables for the HSPG V2 Project
//
//********************************************************************


//-- Slot Data array --

unsigned char SlotData[8]={0,0,0,0,0,0,0,0};

//-- Start Sequence 32bit value --
union
{
 unsigned long int Start;
 unsigned char bytes[4];
}Start;


//-- Stop sequence 32bit value --
union
{
 unsigned long int Stop;
 unsigned char bytes[4];
}Stop;

//-- Run/Paused status of system --
bit Status_Run;


