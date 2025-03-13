# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printStr, 248
	.equ SYS_readStr, 249


# Read-only data section
	.section .rodata
input_prompt: .asciz "Enter command: "
newline:      .asciz "\n"


# Uninitialized data section
	.section .bss
str: .space 128


# Code section
	.section .text
	.globl _start


_start:
	# Print input prompt
	la a0, input_prompt
	li a7, SYS_printStr
	ecall

	# Read in input prompt
	la a0, str
	li a1, 128
	li a7, SYS_readStr
	ecall

	# Load the first character of the string as the command
	la t0, str
	lb t1, 0(t0)	# I or D command
	lb t2, 1(t0)	# The char to store

	# Check if command is valid
	li t3, 'I'
	li t4, 'D'
	beq t1, t3, continue
	beq t1, t4, continue
	
	# Exit
	li a0, 0
        li a7, SYS_exit
        ecall
	

continue:


# procedure init initializes the free list
# procedure arguments as follows:
#   a0 - address of block of memory to be used for free list
#   a1 - desired size of free list (number of nodes)
# procedure returns pointer to first node in free list
init:	  	
	mv t0, a0
	blez a1, init_r
init_l:   	
	sw zero, 0(t0)
	addi t0, t0, 8
	sw t0, -4(t0)
	addi a1, a1, -1
	bnez a1, init_l
	sw zero, -4(t0)
init_r:
	jalr zero, 0(ra)


# procedure alloc gets a node from the free list
# procedure argument as follows:
#   a0 - address of word containing the address of the first node in free list
# procedure returns pointer to unlinked node; 0 if free list empty
alloc:
	mv t0, a0
	lw a0, 0(a0)
	beqz a0, alloc_r  	#if free list is empty, return 0
	lw t1, 4(a0)
	sw t1, 0(t0)
	sw zero, 4(a0)
alloc_r:
	jalr zero, 0(ra)


# procedure free returns a node to the free list
# procedure arguments as follows:
#   a0 - address of word containing the address of the first node in free list
#   a1 - address of node that should be added to free list
free:
	lw t0, 0(a0)
	sw a1, 0(a0)
	sw zero, 0(a1)
	sw t0, 4(a1)
	jalr zero, 0(ra)


#done:
#	li a0, 0
#	li a7, SYS_exit
#	ecall
