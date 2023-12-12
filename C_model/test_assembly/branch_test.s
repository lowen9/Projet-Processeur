/*----------------------------------------------------------------
//           test add                                           //
----------------------------------------------------------------*/
	.text
	.globl	_start 

_start:               
	/* 0x00 Reset Interrupt vector address */
  mov r0, #1 //PC = 0
	mov r1, #1 //PC = 4
	b	startup  //PC = 8
	mov r1, #10 //PC = 12 chargé par IFECTH
	//freeze du IFTECH                              
	//Renvoie de l'adresse chargement dans IFECTH
	//Ecrassement de PC = 12 dans dec2exe on continue 2cycles de gel
	sub r1, r1, #1 //PC = 16 
	eor r1, r2, #2 //PC = 20
	mov r1, #2 //PC = 24
	mov r1, #2 //PC = 28
	mov r1, #2 //PC = 32
	
	/* 0x04 Undefined Instruction Interrupt vector address */
	b	_bad     //PC = 36

startup :
	add r2, r1, r0 //PC = 40
	adds r3, r1, #100 //PC = 44 //2 cycle de gel 1 du au retour de la boucle donc ifecth vide, et 1 autre du à reg qui doit s'incrémenter à de 40 à 48
	bmi _bad        //PC = 48
	subs r4, r3, r1 //PC = 52
	bpl _good       //PC = 56

_bad :						
	nop						 //PC = 60
	nop						 //PC = 64
_good :
	nop						 //PC = 68
	nop						 //PC = 72
AdrStack:  .word 0x80000000
