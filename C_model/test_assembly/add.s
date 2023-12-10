/*----------------------------------------------------------------
//           Mon premier programme                              //
----------------------------------------------------------------*/
        .text
        .globl  _start
_start:
        /* 0x00 Reset Interrupt vector address */
        mov r0, #2147483649
        mov r1, #2147483649
        add r2, r0, r1
        /* 0x04 Undefined Instruction Interrupt vector address */

_bad :  nop
        nop

_good : nop
        nop
