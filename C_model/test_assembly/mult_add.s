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
	mov r2, #0  //PC = 16 initialisation de la sortie
	mov r0, #5  //PC = 8
	mov r1, #5  //PC = 12

_loop : 
	add r2, r2, r1  //PC = 20 r2 <= r2 + r1
	subs r0, r0, #1 //PC = 24 r0 <= r0 - 1   1er boucle Z = 0
	bne _loop       //PC = 28 --> 28+8-4*4

	mov r5, #0
	add r2, r2, #0
	mov r5, #0   
 	b _good         //PC = 32

_bad :			   
	nop				//PC = 36		
	nop				//PC = 40	 
_good :
	nop			    //PC = 44
	nop				//PC = 48
AdrStack:  .word 0x80000000
