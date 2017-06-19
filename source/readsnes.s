/**
	contains the draw functions
*/

.globl initGPIO

initGPIO:

	ldr	r0, =0x3F200000			//Initialize Latch
	mov	r1,	#27
	mov r2, #0b001
	bl	init_GPIO
	
	ldr	r0, =0x3F200004			//Initialize Data
	mov	r1,	#0
	mov r2, #0b000
	bl	init_GPIO
	
	ldr	r0, =0x3F200004			//Initializa Clock
	mov	r1,	#3
	mov r2, #0b001
	bl	init_GPIO



init_GPIO:						//param: r0 = address, r1 = GPIO line, r2 = func select value
	push {r4, r5}				//no return values
	ldr r4, [r0]				//intializes a single GPIO line
	
	mov r5, #0b111
	bic r4, r5, lsl r1
	
	mov r5, r2
	orr r4, r5, lsl r1
	
	str r4, [r0]
	pop {r4, r5}
	mov pc, lr

.globl readSNES	
readSNES:						//reads controller input, no param
	push {r4, r5, lr}			//returns the 16bit binary number representing input in r2
	mov	r4, #0					//initialize buttons to 0
	mov	r5, #0					//initialize counter to 0
	
	ldr r2, =0x186A0
	bl wait

	mov r1, #1
	mov r0, #9
	bl write_Pin				//set latch to 1

	mov r1, #1
	mov r0, #11
	bl write_Pin				//set clock to 1

	mov r2, #12 
	bl wait						//wait for 12 microseconds
	
	mov r1, #0
	mov r0, #9
	bl write_Pin				//set latch to 0

pulse:
	mov r2, #6
	bl wait						//wait for 6 microseconds
	
	mov r1, #0
	mov r0, #11
	bl write_Pin				//set clock to 0
	
	mov r2, #6
	bl wait						//wait for 6 microseconds

	mov r0, #10
	bl read_Pin					//read data

	mov r6, #2
	mul r4, r6					//shift buttons left then add read pin value
	add r4, r0

	mov r1, #1
	mov r0, #11
	bl write_Pin				//set clock to 1

	add r5, #1					//loop guard, stops once r5 = 16
	cmp r5, #16
	blt pulse
	
	mov r2, r4					//return buttons to r2 register
	pop {r4, r5, lr}
	mov	pc, lr
	
write_Pin:						//writes a bit(1 or 0) to a pin
	ldr r2, =0x3F200000			//param: r0 = pin number, r1 = bit to write
	mov r3, #1
	lsl r3, r0
	teq r1, #0
	streq r3, [r2, #40]
	strne r3, [r2, #28]
	mov	pc, lr
	
read_Pin:						//reads a bit(1 or 0) from a pin
	ldr	r2, =0x3F200000			//param: r0 = pin number
	ldr	r1, [r2, #52]			//return: returns the read bit in r0
	mov	r3, #1
	lsl	r3, r0
	and r1, r3
	teq	r1, #0
	moveq r0, #0
	movne r0, #1
	mov	pc, lr
	
wait:							//waits for selected amount of time
	ldr	r0, =0x3F003004			//param: r2 = # of nanoseconds waited
	ldr	r1, [r0]
	add	r1, r2
waitLoop:
	ldr	r3, [r0]
	cmp	r1, r3
	bhi	waitLoop
	mov	pc, lr
	
	


