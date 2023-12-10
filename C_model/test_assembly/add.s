/*----------------------------------------------------------------
//           Mon premier programme                              //
----------------------------------------------------------------*/
        .text
        .globl  _start
_start:
        /* 0x00 Reset Interrupt vector address */
        mov r0, #2
        b cool
        mov r1, #2
        mov r6, #2
        mov r7, #2
cool :
        add r2, r0, r0
        /* 0x04 Undefined Instruction Interrupt vector address */

_bad :  nop
        nop

_good : nop
        nop
