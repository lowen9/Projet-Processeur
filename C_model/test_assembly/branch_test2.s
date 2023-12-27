/*----------------------------------------------------------------
//           test add                                           //
----------------------------------------------------------------*/
	.text
	.globl	_start 

_start:               
	    /* 0x00 Reset Interrupt vector address */
	    b	startup //PC = 0
        
	    /* 0x04 Undefined Instruction Interrupt vector address */
	    b	_bad   //PC = 4

startup :
  mov r0, #1       //PC = 8        
	mov r1, #10      //PC = 12
	add r2, r1, r0   //PC = 16
	sub r3, r0, r1   //PC = 20
	eor r4, r0, r1   //PC = 24
	sbc r5, r1, r0   //PC = 28
	b _good   //PC = 32

_bad :						
	nop						 //PC = 36
	nop						 //PC = 40
_good :
	nop						 //PC = 44
	nop						 //PC = 48
AdrStack:  .word 0x80000000
