/*----------------------------------------------------------------
//                         pipeline                             //
----------------------------------------------------------------*/
	.text
	.globl	_start 

_start:               
	    /* 0x00 Reset Interrupt vector address */
        ldr r0, data0 // r0 <= 0x12345678
		mov r0, r0
	    b	_good
        
	    /* 0x04 Undefined Instruction Interrupt vector address */
	    b	_bad   

_bad :						
	nop						
	nop						
_good :
	nop						
	nop						

data0   :  .word 0x12345678
AdrStack:  .word 0x80000000
