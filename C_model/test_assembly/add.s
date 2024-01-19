/*-----------------------------------------
//               Add _test               //
-----------------------------------------*/
        .text
        .globl  _start
_start:
        /* 0x00 Reset Interrupt vector address */
        mov r0, #1000
        mov r1, #2000
        add r2, r0, r1 // 3000
        sub r3, r1, r0 // 1000
        sub r4, r0, r1 //-1000
        mov r2, r4     //-1000
        add r5, r3, r4 // 0
        b _good
        /* 0x04 Undefined Instruction Interrupt vector address */

_bad :  nop
        nop

_good : nop
        nop
