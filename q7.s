# function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_readStr, 249
	.equ SYS_printStr, 248
	.equ SYS_readInt, 245
	.equ SYS_printInt, 244


# Data section
	.section .data
root_ptr:	.word 0
free_ptr:	.word 0
buffer:		.space 20	# Buffer for reading input


# Node memory
nodes:		.space 180	# Space for 15 nodes (15 nodes x 3 words/node x 4 bytes/word = 180 bytes)


# Read-only data section
	.section .rodata
operation_prompt:      .asciz "Enter operation (I = insert, D = delete, S = sumupto): "
value_prompt:          .asciz "Enter integer value: "
insert_failed_message: .asciz "Insert failed: free list empty"
sum_message:           .asciz "Sum of values less than threshold: "
newline:               .asciz "\n"


# Code section
	.section .text
	.globl _start


################# DO NOT EDIT ####################
		# procedure init initializes the free list
        	# procedure arguments as follows:
        	#   a0 - address of block of memory to be used for free list
        	#   a1 - desired size of free list (number of nodes)
        	# procedure returns pointer to first node in free list
init:	  	mv t0, a0
	  	blez a1, init_r
init_l:   	sw zero, 0(t0)
		sw zero, 4(t0)
	  	addi t0, t0, 12
	  	sw t0, -4(t0)
	  	addi a1, a1, -1
	  	bnez a1, init_l
	  	sw zero, -4(t0)
init_r:   	jalr zero, 0(ra)


		# procedure alloc gets a node from the free list
        	# procedure argument as follows:
        	#   a0 - address of word containing the address of the first node in free list
        	# procedure returns pointer to unlinked node; 0 if free list empty
alloc:		mv t0, a0
		lw a0, 0(a0)
	  	beqz a0, alloc_r  	#if free list is empty, return 0
	 	lw t1, 8(a0)
	  	sw t1, 0(t0)
	  	sw zero, 8(a0)
alloc_r:  	jalr zero, 0(ra)


		# procedure free returns a node to the free list
        	# procedure arguments as follows:
        	#   a0 - address of word containing the address of the first node in free list
		#   a1 - address of node that should be added to free list
free:		lw t0, 0(a0)
	  	sw a1, 0(a0)
	  	sw zero, 0(a1)
		sw zero, 4(a1)
	  	sw t0, 8(a1)
	  	jalr zero, 0(ra)
################################################



# Insert procedure
# Parameters:
# a0 = integer value to insert
# a1 = address of word containing root address
# a2 = address of word containing free list head address
# Returns:
# a0 = 0 if successful, 1 if unsuccessful (free list empty)
insert:
	# TODO


# Delete procedure
# Parameters:
# a0 = integer value to delete
# a1 = address of word containing root address
# a3 = address of word containing free list head address
# Returns:
# none
delete:
	# TODO


# sumupto procedure
# Parameters
# a0 = integer threshold
# a1 = address of root node
# Returns:
# a0: sum of integers less than node
sumupto:
	# TODO


# Main program
_start:
	# Initialize tree and free list
	la a0, nodes	# Address of node memory
	li a1, 15	# 15 nodes
	jal ra init	# Initialize free list

	# Store free list head
	la t0, free_ptr
	sw a0, 0(t0)
	
	# Main loop
main_loop:
	# Prompt for operation
	la a0, operation_prompt
	li a7, SYS_printStr
	ecall

	# Read operation
	la a0, buffer
	li a1, 10	# Buffer size
	li a7, SYS_readStr
	ecall

	#  Prompt for value
	lb t0, buffer
	li t1, 'I'
	beq t0, t1, do_insert

do_insert:
	# Prompt for value
	la a0, value_prompt
	li a7, SYS_printStr
	ecall

	# Read value
	li a7, SYS_readInt
	ecall
	mv s0, a0	# Save value

	# Discard remaining characters
	la a0, buffer
	li a1, 10
	li a7, SYS_readStr
	ecall

	# Call insert
	# Parameters:
	# a0 = integer value to insert
	# a1 = address of word containing root address
	# a2 = address of word containing free list head address
	# Returns:
	# a0 = 0 if successful, 1 if unsuccessful (free list empty)
	mv a0, s0
	la a1, root_ptr
	la a2, free_ptr
	jal ra, insert


















