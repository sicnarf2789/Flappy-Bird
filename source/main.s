/**
main function

*/

.section .init
.globl _start

_start:
    b main
    
.section .text

main:
        mov sp, #0x8000
	bl EnableJTAG
	bl InitFrameBuffer


drawMenu:
	
	mov r0, #0
	mov r1, #0
	mov r2, #1024
	mov r3, #768
	ldr r4, =flappyLogo
	bl drawImage


readButtons:

        mov             r8, #0                  // toggles game mode on/off

waitInput:					//waits until the user presses a button
	
	ldr             r5, =0xFFFF	
	bl              readSNES
	cmp             r2, r5
	beq             waitInput

            
	ldr		r6, =0xEFFF		// mask for the start button
	ldr		r7, =0x3FEF		// mask for the UP button
	cmp		r2, r6			// compare if user pressed Start
	beq		pressedStart
	cmp		r2, r7			// compare if user pressed UP
	beq		pressedUp

	b		readButtons		// branch back and wait for user to press A
	
pressedStart:
	cmp		r8, #0			// cursor points to start game flag
	beq		startGame		// starts game is user pressed A on start game option
	bne		pauseGame		// quits game (clears screen to black) if user pressed A on quit game option

pressedUp:
        
        //code for moving bird        
     

	b		quit		// branch back to read snes controller


startGame:


	mov             r0, #0
	mov             r1, #0
	mov             r2, #1024
	mov             r3, #768
	ldr             r4, =pipesBackground
	bl              drawImage
        mov             r8, #1  
        
	b		waitInput		// branch back to read snes controller

pauseGame:
	
	mov             r0, #0
	mov             r1, #0
	mov             r2, #1024
	mov             r3, #768
	ldr             r4, =pauseBackground
	bl              drawImage
        mov             r8, #0 
        
	b		waitInput		


quit:

        bl              clearScreen

.globl haltLoop$
haltLoop$:
	b		haltLoop$

	


	
