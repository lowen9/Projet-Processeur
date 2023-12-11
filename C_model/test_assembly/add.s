/*----------------------------------------------------------------
//           Mon premier programme                              //
----------------------------------------------------------------*/
        .text
        .globl  _start
_start:
        /* 0x00 Reset Interrupt vector address */
        mov r0, #100
        mov r1, #205
        add r2, r0, r1 // 305
        sub r3, r1, r0 // 105
        sub r4, r0, r1 //-105
        mov r2, r4     //-105
        add r5, r3, r4 // 0
        /* 0x04 Undefined Instruction Interrupt vector address */

_bad :  nop
        nop

_good : nop
        nop
