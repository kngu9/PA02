@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ Program part 0: initial declarations
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.globl _start

.equ RXFE, 0x10
.equ TXFF, 0x20

.equ OFFSET_FR, 0x018
.equ IO_ADDRESS, 0x101f1000

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ Program part 1: definition of main.
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


@main program
_start:
	mov sp,#0x100000		@ set up stack

	ldr r4,=0x101f1000
	@ ASCII codes stored at [r4] get printed

	bl get_int
	mov r5, r0
	bl get_int
	mov r6, r0

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@       Your code starts here      @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

loop:
	cmp r5, #22
	beq c2
	cmp r5, #27
	beq c3

c1:
	mov r1, #'z'
	str r1, [r4]
	mov r1, #'\r'
	str r1, [r4]
	mov r1, #'\n'
	str r1, [r4]
	b loop_n

c2:
	mov r1, #'2'
	str r1, [r4]
	mov r1, #'2'
	str r1, [r4]
	mov r1, #'\r'
	str r1, [r4]
	mov r1, #'\n'
	str r1, [r4]
	b loop_n

c3:
	mov r1, #'2'
	str r1, [r4]
	mov r1, #'7'
	str r1, [r4]
	mov r1, #'\r'
	str r1, [r4]
	mov r1, #'\n'
	str r1, [r4]
	b loop_n

loop_n:
	add r5, r5, #1
	cmp r5, r6
	ble loop
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@        Your code ends here       @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

my_exit: 			@ print "END" on a new line
	mov r1, #'\r'
	str r1, [r4]
	mov r1, #'\n'
	str r1, [r4]
	mov r1, #'E'
	str r1, [r4]
	mov r1, #'N'
	str r1, [r4]
	mov r1, #'D'
	str r1, [r4]

the_end:			@ do infinite loop at the end
	b the_end

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ Program part 2: definition of functions
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ r0 should be a buffer that can receive the data.
@ The buffer should have size at least 1000 bytes.
get_int:
	@preamble
	push {r4, r5, r6, lr}

	@ main body
	ldr r4, =IO_ADDRESS
	mov r5, #0
	mov r6, #10

get_int_loop:
	bl get_char
	cmp r0, #'0'
	blt get_int_exit
	cmp r0, #'9'
	bgt get_int_exit

	sub r0, r0, #'0'
	mul r5, r6, r5
	add r5, r5, r0

	b get_int_loop

get_int_exit:
	mov r0, r5
	mov r5, #13
	str r5, [r4]
	mov r5, #10
	str r5, [r4]

	@ wrap-up
	pop {r4, r5, r6, lr}
	bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

get_char:
	@preamble
	push {r2, r3, r4, lr}

	@ main body
	ldr r4,=IO_ADDRESS		@ r4 := 0x 101f 1000

get_char_wait:
	ldr r2,[r4,#OFFSET_FR]		@ load IO flag register to r2
	and r3,r2,#RXFE			@ mask non receive fifo empty bits
	cmp r3, #0			@ check if r3 == 0
	bne get_char_wait		@ wait if not ready (if r3 != 0)

	ldr r0,[r4]
	str r0, [r4]

	@ wrap-up
	pop {r2, r3, r4, lr}
	bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
