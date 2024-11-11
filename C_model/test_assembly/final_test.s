/*----------------------------------------------------------------
//           test final                                         //
----------------------------------------------------------------*/
	.text
	.globl	_start 

_start :               
	    /* 0x00 Reset Interrupt vector address */
	    b	startup
        
	    /* 0x04 Undefined Instruction Interrupt vector address */
	    b	_bad   

startup :
    ldr r0, data1         
	ldr r1, data2    
	bl  mutl         
    str r2, res
    ldr r3, res      
	b _good          

mutl :
    subs  r3, r0, r1
    movpl r2, r0
    movpl r0, r1
    movpl r1, r2
    mov   r2, #0 
_loop : 
	add r2, r2, r1  
	subs r0, r0, #1 
	bne _loop       
    bx  r14          
    add r2, r2, #1000   

_bad :						
	nop				
	nop				
_good :
	nop				
	nop				

data1: .word 153206
data2: .word 15
res  : .word 0
AdrStack:  .word 0x80000000
