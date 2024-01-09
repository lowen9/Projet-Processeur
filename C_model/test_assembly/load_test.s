/*----------------------------------------------------------------
//                      Load Test                               //
----------------------------------------------------------------*/
    .text
    .globl  _start

_start :
        /* 0x00 Reset Interrupt vector address */
        b       startup
        nop
        /* 0x04 Undefined Instruction Interrupt vector address */
        b       _bad

startup :
    ldrb r0, data0
    mov r3, r0
    ldr r1, data1
    add r2, r3, r3
    b _good

_bad :  nop
        nop

_good : nop
        nop

data0 : .word 0x12345678 //10
data1 : .word 0x000000BC //188
AdrStack:  .word 0x80000000
