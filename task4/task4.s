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
	@ ASCII codes stored
	@ at [r4] get printed

	@ get input
	bl get_int
	mov r5, r0
	bl get_int
	mov r6, r0

	@ mov a to r0 b to r1
        mov r0, r5
        mov r1, r6

	@ branch to the function you write
        bl  foo

	@ print the number in r0 after branching back from your function
        bl  print10

        @ branch to exit
        b my_exit

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@       Your code starts here      @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

foo:
    add r5, r5, r6
    cmp r5, #9
    bgt c2

c1:
    add r5, r5, #48
    mov r1, r5
    str r1, [r4]
    mov r1, #'\r'
    str r1, [r4]
    mov r1, #'\n'
    str r1, [r4]
    b my_exit

c2:
    mov r1, #'?'
    str r1, [r4]
    mov r1, #'\r'
    str r1, [r4]
    mov r1, #'\n'
    str r1, [r4]
    b my_exit

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

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ author: Brandon Lawrence
@
@ div: computes result of integer division r0/r1
@
@ results: r0 = r0/r1
@          r1 = r0 mod r1

div:
@preamble
	push {r2, r3, r4, r5, r6, r7, r8, lr}

div_main:
	@r0 holds numerator
	@r1 holds denominator

	mov r4, #1
	mov r5, #-1

	cmp r1, #0
	moveq r3, #0
	beq div_exit
	mullt r6, r4, r5
	movlt r4, r6
	mullt r6, r1, r5
	movlt r1, r6

	cmp r0, #0
	mullt r6, r4, r5
	movlt r4, r6
	mullt r6, r0, r5
	movlt r0, r6

	mov r7, r0
	mov r8, r1

	mov r3,#0
	mov r2,r1


div_counter:		@sets r2 to the largest multiple
	cmp r2,r0	@of 2 smaller than r0
	lsrgt r2,r2,#1
	bge div_loop
	lsl r2,r2,#1
	b div_counter

div_loop:
	cmp r2,r1
	blt div_exit

	lsl r3,r3,#1	@r3 stores result
	cmp r0,r2
	subge r0,r0,r2
	addge r3,r3,#1

	lsr r2,r2,#1
	b div_loop

div_exit:
	mul r0,r3,r4
	mul r6, r3, r8
	sub r1, r7, r6

@wrap-up
	pop {r2, r3, r4, r5, r6, r7, r8, lr}
	bx lr

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

print10:
	@ print10 preamble
	push {r0, r1, r4, r5, r6, r7, lr}

	@ print10 main body
	ldr r4,=0x101f1000
	@ ASCII codes stored
	@ at [r4] get printed

	mov r5, r0
	cmp r5, #0
	movlt r6, #'-'
	strlt r6, [r4]
	movlt r7, #-1
	mullt r0, r5, r7

	bl print10_helper

	@ print newline
	mov r5, #13
	str r5, [r4]
	mov r5, #10
	str r5, [r4]

	@ print_number wrap-up
	pop {r0, r1, r4, r5, r6, r7, lr}
	bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

print10_helper:
	@ print10_helper preamble
	push {r0, r1, r4, r5, r6, r7, lr}

	@ print10_helper main body
	ldr r4,=0x101f1000
	@ ASCII codes stored
	@ at [r4] get printed

	cmp r0, #10
	addlt r6, r0, #'0'
	strlt r6, [r4]
	blt print10_helper_exit

	mov r1, #10
	bl div
	bl print10_helper
	add r6, r1, #'0'
	str r6, [r4]

print10_helper_exit:
	@ print10_helper wrap-up
	pop {r0, r1, r4, r5, r6, r7, lr}

	bx lr
