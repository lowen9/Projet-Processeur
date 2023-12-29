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
    mov r1, #1       //PC = 8        
	mov r2, #10      //PC = 12
	bl  func         //PC = 16
    mov r5, r4       //PC = 20
    add r5, r4, #0   //PC = 24
	b _good          //PC = 28

func :
    add r3, r1, r2   //PC = 32 r1+r2 = 11
    add r4, r3, r3   //PC = 36 (r1+r2)*2 = 22
    @ mov r15, r14   // on change PC
    bx  r14          //PC = 40
	nop
    add r4, r4, #1   //PC = 

_bad :						
	nop				//PC = 
	nop				//PC = 
_good :
	nop				//PC = 
	nop				//PC = 
AdrStack:  .word 0x80000000
