/*----------------------------------------------------------------
//           test add                                           //
----------------------------------------------------------------*/
	.text
	.globl	_start 
_start:               
	/* 0x00 Reset Interrupt vector address */
  movs r0, #100 //Mise à jour flag Z = 0 N = 0 C = 0
  mov  r1, #205
  addeq r2, r0, r1 // 305 si Z = 1 NON
  eorne r3, r1, r1 // 0 si Z = 0 OUI
  addcs r1, r0, r0 //200 si C = 1 NON
  rsbcc r4, r0, r1 //105 si C = 0 OUI
  sbcpl r5, r1, r0 //205-100+C-1 = 104 si N = 0 OUI
  subs  r6, r0, r1 //100-205 = -105 maj flag Z = 0 N = 1 C = 0 V = 0
  //dépendence de lecture des flags la mise à jour (prend un cycle à revenir 1 cycle de gel) non elle prend 0 cycle grave à la lecture rapide
  rscmi r7, r1, r0 //100-205+C-1 = -106 si N = 1 OUI
  mov r8, #0
  mov r9, #1
  b _good
  nop

	/* 0x04 Undefined Instruction Interrupt vector address */
	b	_bad 

_bad :						
	nop						
	nop						 
_good :
	nop						 
	nop						 
AdrStack:  .word 0x80000000
