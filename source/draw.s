/**
	contains the draw functions
*/

.globl drawImage
drawImage:								//r0, r1 = starting x, y positions
	push {r5, r6, r7, r8, r9, r10, lr}		//r2, r3 = image width and height
	mov	r5,	r0							//r4 = address of image
	mov	r6,	r1
	mov     r7,     r4
	mov	r8,	r2
        mov     r10,    r5
	mov	r9,	r3
	add     r8,     r5
	add     r9,     r6
	
drawImageLoop:
	mov	r0,	r5							//passing x for ro which is used by the Draw pixel function 
	mov	r1,	r6							//passing y for r1 which is used by the Draw pixel formula 
	
	ldrh r2, [r7],#2					//setting pixel color by loading it from the data section. We load hald word

	bl	DrawPixel
	add	r5,	#1			//increment x position
	cmp	r5,	r8			//compare with image with
	blt	drawImageLoop
	//sub r5, r8			//reset x
        mov     r5,     r10	
        add	r6,	#1			//increment Y
	cmp	r6,	r9			//compare y with image height
	blt	drawImageLoop
	pop {r5, r6, r7, r8, r9, r10, pc}
    

/* Draw Pixel
 *  r0 - x
 *  r1 - y
 *  r2 - color
 */

DrawPixel:
	push {r4}
	offset	.req	r4

	// offset = (y * 1024) + x = x + (y << 10)
	add offset, r0, r1, lsl #10
	
	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl offset, #1

	// store the colour (half word) at framebuffer pointer + offset

	ldr r0, =FrameBufferPointer
	ldr r0, [r0]
	strh r2, [r0, offset]

	pop {r4}
	bx lr


.globl clearScreen
clearScreen:
	mov	r4,	#0			//x value
	mov	r5,	#0			//Y value
	mov	r6,	#0			//black color
	ldr	r7,	=1023			//Width of screen
	ldr	r8,	=767			//Height of the screen
	
Looping:
	mov	r0,	r4			//Setting x 
	mov	r1,	r5			//Setting y
	mov	r2,	r6			//setting pixel color
	push {lr}
	bl	DrawPixel
	pop {lr}
	add	r4,	#1			//increment x by 1
	cmp	r4,	r7			//compare with width
	blt	Looping
	mov	r4,	#0			//reset x
	add	r5,	#1			//increment Y by 1
	cmp	r5,	r8			//compare with height
	blt	Looping
	
	mov	pc,	lr			//return
