/*----------------------------------------------------------------
//           test add                                           //
----------------------------------------------------------------*/
	.text
	.globl	_start 
_start:               
	/* 0x00 Reset Interrupt vector address */
  mov r0, #1 //PC = 0
	mov r1, #1 //PC = 4
	b	startup  //PC = 8
	mov r1, #10 //PC = 12
	sub r1, r1, #1 //PC = 16
	eor r1, r2, #2 //PC = 20
	mov r1, #2 //PC = 24
	mov r1, #2 //PC = 28
	mov r1, #2 //PC = 32
	
	/* 0x04 Undefined Instruction Interrupt vector address */
	b	_bad     //PC = 36

startup :
	add r2, r1, r0 //PC = 40
	b _good
	nop

_bad :
	nop
	nop
_good :
	nop
	nop
AdrStack:  .word 0x80000000
