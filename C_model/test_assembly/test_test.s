/*----------------------------------------------------------------
//           test test                                          //
----------------------------------------------------------------*/
	.text
	.globl	_start 

_start:               
	/* 0x00 Reset Interrupt vector address */
    mov r2, #1000  
	add r2, r2, r2 //R2 = 1000+1000
    add r0, r2, r2 //R0 = 2000+2000
    mov r1, #12
    add r3, r2, r2
    add r4, r1, r1
    b _good
	
	/* 0x04 Undefined Instruction Interrupt vector address */
	b	_bad     //PC = 36

startup :

	b _good         //PC = 56

_bad :						
	nop						 //PC = 60
	nop						 //PC = 64
_good :
	nop						 //PC = 68
	nop						 //PC = 72
AdrStack:  .word 0x80000000
