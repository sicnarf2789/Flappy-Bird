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
	
drawMainMenu:
	mov r0, #0
	mov r1, #0
	mov r2, #1023
	mov r3, #763
	ldr r4, =flappyLogo
	bl drawPicture
	
	
waitInput:						//waits until the user presses a button
	
	ldr r5, =0xFFFF	
	bl readSNES
	cmp r2, r5
	beq waitInput
	
checkInput:
	
	push {r4, r5, lr}		//no return values
	mov r4, r2
	ldr r5, =0xEFFF
	cmp r4, r5				//checks for start button. Terminates immediately if pressed
	bne waitInput

drawGame:

	mov r0, #0
	mov r1, #0
	mov r2, #1023
	mov r3, #763
	ldr r4, =pipesBackground
	bl drawPicture

	pop {r4, r5, lr}
	mov pc, lr
		
gameControls:

	push {r4, r5, r6}		//no return values
	mov   r6, #0			//set the game to play
	
waitGameInput:						//waits until the user presses a button
	
	
	
	ldr r5, =0xFFFF	
	bl readSNES
	cmp r2, r5
	beq waitGameInput
	
checkGameInput:
	
	
	mov r4, r2
	
	
	cmp r4, =0x3FEF			//checks for start button. Terminates immediately if pressed
	beq waitGameInput

	cmp r4, =0xEFFF			//checks for start button. Terminates immediately if pressed
	beq pauseMenu
	
dPadUP:	
	
	//code for up
	
pauseMenu:	//code for pause menu
	
	cmp r6, #0
	bne unpause
	
	mov r0, #0
	mov r1, #0
	mov r2, #1023
	mov r3, #763
	ldr r4, =pauseBackground
	bl drawPicture
	
	mov r6, #1			//set game to pause
	
	b waitGameInput
	

unpause:
	
	
	//clear pause background
	
	mov r6, #0			//set game to play
	b waitGameInput
	
	
	pop {r4, r5}
	mov pc, lr
	
haltLoop$:
	b		haltLoop$
	


.section .data
