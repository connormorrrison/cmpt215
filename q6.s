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
str:         .space 128
free_space:  .space 120	# 15 nodes (15 nodes x 2 words/node x 4 bytes/word = 120 bytes)
list_head:   .word 0	# Pointer to head of the sorted linked list
char_buffer: .space 2

# Code section
	.section .text
	.globl _start


_start:
	jal main
	
	# Exit
	li a0, 0
	li a7, SYS_exit
	ecall


# Main to initialize list
main:
	# Initialize free list
	la a0, free_space
	li a1, 15	# Number of nodes
	jal init	

	# Initialize head to 0
	la t0, list_head
	sw zero, 0(t0)	# lList head now equals 0
	
	j input_loop

input_loop:
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
        lb t1, 0(t0)    # Command letter (I, D, or P)
        lb t2, 1(t0)    # The char to store

        # Check if command is valid
        li t3, 'I'
        li t4, 'D'
	li t5, 'P'
	
	# Call appropriate function
        beq t1, t3, pre_insert
        beq t1, t4, pre_delete
	beq t1, t5, pre_print

	# If the command is not valid
	j exit


pre_insert:
	# Parameters
	# a0 = ASCII code of letter
	# a1 = address of memory word containing pointer to list head
	# a2 = address of memory word containing pointer to free list
	mv a0, t2
	la a1, list_head
	la a2, free_space

	jal insert

	j input_loop
	

pre_delete:
	# Parameters
	# a0 = ASCII code of letter
	# a1 = address of memory word containing pointer to list head
	# a2 = address of memory word containing pointer to free list
	mv a0, t2
	la a1, list_head
	la a2, free_space
	
	jal delete
	
	j input_loop


pre_print:
	jal print_list

	j input_loop


print_list:
	# Implement


# Parameters:
# 	a0 = ASCII code of letter
# 	a1 = address of memory word containing pointer to list head
# 	a2 = address of memory word containing pointer to free list
# Returns:
# 	a0 = 0 on insertion/duplicate found; 1 if free list was empty
insert:
	# Implement


# Parameters:
# 	a0 = ASCII code of letter
# 	a1 = address of memory word containing pointer to list head
# 	a2 = address of memory word containing pointer to free list
# Returns:
#	a0 = 0 always
delete:
	# Implement


exit:
	li a0, 0
	li a7, SYS_exit
	ecall

####################################################################################################
# Provided: Do not edit
####################################################################################################


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
