/*----------------------------------------------------------------
//           load_store_test                                     //
----------------------------------------------------------------*/
	.text
	.globl	_start 

_start:               
	/* 0x00 Reset Interrupt vector address */
	b	startup  

	/* 0x04 Undefined Instruction Interrupt vector address */
	b	_bad

startup :
    ldr  r0, data0
    ldr  r1, data1
	add  r2, r0, r1   
    sub  r3, r1, r1
    str  r2, data2
    str  r3, data3
    ldr  r4, data2
    ldr  r5, data3
    mov  r4, r4
    movs r5, r5   
	beq  _good        

_bad :						
	nop						 
	nop						 
_good :
	nop						
	nop			

data0   :  .word 0x00000010
data1   :  .word 0x12345678
data2   :  .word 0x00000000
data3   :  .word 0x14385012	
AdrStack:  .word 0x80000000
