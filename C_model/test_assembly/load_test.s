/*----------------------------------------------------------------
//                      Load Test                               //
----------------------------------------------------------------*/
    .text
    .globl  _start

_start :
        /* 0x00 Reset Interrupt vector address */
        ldr r0, data0
        mov r1, r0
        b       startup
        nop
        /* 0x04 Undefined Instruction Interrupt vector address */
        b       _bad

startup :
    b _good

_bad :  nop
        nop

_good : nop
        nop

data0 : .word 0x0000000A //10
data1 : .word 0x000000BC //188
AdrStack:  .word 0x80000000
