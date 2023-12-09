/*----------------------------------------------------------------
//           Mon premier programme                              //
----------------------------------------------------------------*/
        .text
        .globl  _start
_start:
        /* 0x00 Reset Interrupt vector address */
        mov r1, #3
        nop
        add r0, r1, #2

        /* 0x04 Undefined Instruction Interrupt vector address */

_bad :  nop
        nop

_good : nop
        nop
