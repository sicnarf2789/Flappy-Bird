/**
main function
main
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
        bl InitGPIO


drawMenu:
	
	mov r0, #0
	mov r1, #0
	mov r2, #1024
	mov r3, #768
	ldr r4, =flappyLogo
	bl drawImage

        ldr r0, =0x113        
        //mov r0, #275
	mov r1, #400
	mov r2, #150
	mov r3, #94
	ldr r4, =startButton
	bl drawImage

        //ldr r0, =0x226
        mov r0, #600	
        mov r1, #400
	mov r2, #150
	mov r3, #94
	ldr r4, =quitButton
	bl drawImage
        
        mov r0, #600	
        mov r1, #400
	mov r2, #150
	mov r3, #94
	ldr r4, =quitButton
	bl drawImage
 

        


readButtons:
       push            {r9, r10}               // r9 - x pos of bird, r10 y pos of bird    
       mov             r7, #0                  // toggles game mode on/off. 1 game is unpaused

waitInput:					//waits until the user presses a button
	
	ldr             r5, =0xFFFF	
	bl              readSNES
	cmp             r2, r5
	beq             waitInput

            
	ldr		r6, =0xEFFF		// mask for the start button
	cmp		r2, r6			// compare if user pressed Start
        beq		pressedStart

        ldr		r6, =0xF7FF		// mask for the UP button
	cmp		r2, r6			// compare if user pressed UP
	beq		pressedUp
        
        ldr             r6, =0xFEFF             
        cmp		r2, r6			// compare if user pressed Start
	beq		cursorOnQuit


        ldr             r6, =0xFDFF             
        cmp		r2, r6			// compare if user pressed Start
	beq		cursorOnStart
 

	b		readButtons		// branch back and wait for user to press A


cursorOnStart:

        b               pressedStart
cursorOnQuit:

        b               quit
        bl              waitInput
	
pressedStart:
	cmp		r7, #0			// cursor points to start game flag
	beq		startGame		// starts game is user pressed A on start game option
	bne		pauseGame		
  

pressedUp:
        
        cmp             r7, #1
        bne             waitInput       //pressing up on menu does not work

        ldr             r5, =0xFFFF	
	bl              readSNES
	cmp             r2, r5
	beq             birdGoesDown

        mov             r0, r9
        mov             r1, r10
	mov             r2, #80
	mov             r3, #80
	bl              clearScreen
     
        
        add             r9, #10
        sub             r10,#10
	mov             r0, r9
	mov             r1, r10
	mov             r2, #80
	mov             r3, #80
	ldr             r4, =birdAvatar
	bl              drawImage
      


	b		waitInput		// branch back to read snes controller


birdGoesDown:

        ldr             r5, =0xF7FF	
	bl              readSNES
	cmp             r2, r5
	beq             pressedUp

       
        mov             r0, r9
        mov             r1, r10
	mov             r2, #80
	mov             r3, #80
	bl              clearScreen
     
        
        add             r9, #10
        add             r10,#1
	mov             r0, r9
	mov             r1, r10
	mov             r2, #80
	mov             r3, #80
	ldr             r4, =birdAvatar
	bl              drawImage
      
        b		birdGoesDown	

startGame:


	mov             r0, #0
	mov             r1, #0
	mov             r2, #1024
	mov             r3, #768
	ldr             r4, =pipesBackground
	bl              drawImage
   
        mov             r0, #0
        mov             r9, r0
	mov             r1, #384
        mov             r10, r1
	mov             r2, #80
	mov             r3, #80
	ldr             r4, =birdAvatar
	bl              drawImage
       

        mov             r7, #1  

        
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

             
        mov r0, #0	
        mov r1, #0
	mov r2, #1024
	mov r3, #768
	bl clearScreen
        pop             {r9, r10}
        

.globl haltLoop$
haltLoop$:
	b		haltLoop$

	


	
