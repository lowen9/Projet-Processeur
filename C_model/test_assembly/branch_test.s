/*----------------------------------------------------------------
//           test add                                           //
----------------------------------------------------------------*/
	.text
	.globl	_start 
_start:               
	/* 0x00 Reset Interrupt vector address */
  mov r0, #1
	b	_good
	mov r1, #2
	
	/* 0x04 Undefined Instruction Interrupt vector address */
	b	_bad

_bad :
	nop
	nop
_good :
	nop
	nop
AdrStack:  .word 0x80000000
