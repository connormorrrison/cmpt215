# function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_readStr, 249
	.equ SYS_printStr, 248
	.equ SYS_readInt, 245
	.equ SYS_printInt, 244


# Data section
	.section .data
root_ptr:	.word 0			# Address of root node
free_ptr:	.word 0			# Address of free list head
buffer:		.space 20		# Buffer for reading input


# Node memory
nodes:		.space 180		# Space for 15 nodes (15 nodes x 3 words/node x 4 bytes/word = 180 bytes)


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


#################### INIT, ALLOC, AND FREE PROCEDURE ####################
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


#################### INSERT PROCEDURE ####################
# Insert procedure
# Parameters:
# a0 = integer value to insert
# a1 = address of word containing root address
# a2 = address of word containing free list head address
# Returns:
# a0 = 0 if successful, 1 if unsuccessful (free list empty)
insert:
	# Save registers
	addi sp, sp, -16
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)


	# Save parameters
	mv s0, a0				# Value to insert
	mv s1, a1				# Address of word containing the root
	mv s2, a2				# Address of word containing free list head


	# Check if the tree is empty
	lw t0, 0(s1)				# Address of word containing the root
	bnez t0, insert_not_empty


	# Otherwise, tree is empty, allocate new node
	mv a0, a2				# a2 = address of word containing free list head
	jal ra, alloc


	# Check if allocation successful
	beqz a0, insert_fail


	# Initialize a new node
	sw s0, 0(a0)				# Store value
	sw zero, 4(a0)				# Left child = NULL
	sw zero, 8(a0)				# Right child = NULL


	# Update root
	sw a0, 0(s1)


	# Return success
	li a0, 0
	j insert_exit


insert_not_empty:
	# Tree is not empty, call recursive insert helper
	mv a0, s0				# Value to insert
	lw a1, 0(s1)				# Root address
	mv a3, s1				# Root pointer address
	mv a4, s2				# Free list head address
	jal ra, insert_recursive


	# Check result from recursive call
	j insert_exit

insert_fail:
	# Return failure
	li a0, 1


insert_exit:
	# Restore registers
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp, 16
	ret


# Recursive helper function for insert
# Parameters:
# a0 = integer value to insert
# a1 = address of current node
# a3 = address of word containing root address
# a4 = address of word containing free list head address
# Returns:
# a0 = 0 if successful, 1 if unsuccessful (free list empty)
insert_recursive:
	# Save registers
	addi sp, sp, -24			# Make room on the stack for 4 registers
	sw ra, 0(sp)				# Save return address
	sw s0, 4(sp)				# Save register s0
	sw s1, 8(sp)				# ...
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)


	# Save parameters
	mv s0, a0				# Value to insert
	mv s1, a1				# Current node address
	mv s2, a3				# Root pointer address
	mv s3, a4				# Free list head address


	# Load current node's value
	lw s4, 0(s1)

	
	# If value == node value, skip duplicate insertion
	beq s0, s4, insert_recursive_duplicate

	
	# Value > node value, go left
	bgt s0, s4, insert_recursive_left

	
	# Value < node value, go right
	lw t0, 8(s1)				# Load right child
	beqz t0, insert_recursive_right_empty	# If right child is NULL


	# Otherwise, right child exists, recurse (placeholder)
	mv a0, s0				# Value to insert
	mv a1, t0				# Right child address
	mv a3, s2				# Free list head address
	jal ra, insert_recursive
	j insert_recursive_exit


insert_recursive_right_empty:
	# Right child is NULL, create new node
	mv a0, s3				# Free list head address
	jal ra, alloc


	# Check if the allocation was successful
	beqz a0, insert_recursive_fail

	
	# Initialized new node
	sw s0, 0(a0)				# Store value
	sw zero, 4(a0)				# Left child = NULL
	sw zero, 8(a0)				# Right child = NULL
	
	
	# Link new node as right child
	sw a0, 8(s1)

	
	# Return success
	li a0, 0
	j insert_recursive_exit


insert_recurive_left:
	# Check left child
	lw t0, 4(s1)				# Load left child
	beqz t0, insert_recursive_left_empty	# If left child is NULL


	# Left child exists, recurse
	mv a0, s0				# Value to insert
	mv a1, t0				# Left child address
	mv a3, s2				# Root pointer address
	mv a4, s3				# Free list head address
	jal ra, insert_recursive
	j insert_recursive_exit


insert_recursive_left_empty:
	# Left child is NULL, create new node
	mv a0, s3				# Free list head pointer
	jal ra, alloc


	# Check if node allocation successful
	beqz a0, insert_recrusive_fail


	# If successful, initialize new node
	sw s0, 0(a0)				# Store node value
	sw zero, 4(a0)				# Left child = NULL
	sw zero, 8(a0)				# Right child = NULL

	
	# Link new node as left child
	sw a0, 4(s1)


	# Return success
	li a0, 0
	insert_recursive_exit


insert_recursive_duplicate:
	# Duplicate value, do not insert
	li a0, 0
	j insert_recursive_exit


insert_recursive_fail:
	# Return fail
	li a0, 1


insert_recursive_exit:
	# Restore registers
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	addi sp, sp, 24
	ret


#################### DELETE PROCEDURE ####################
# Delete procedure
# Parameters:
# a0 = integer value to delete
# a1 = address of word containing root address
# a3 = address of word containing free list head address
# Returns:
# none
delete:
	# Save registers
	addi sp, sp, -16
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)


	# Save parameters
	mv s0, a0			# Value to delete
	mv s1, a1			# Address of word containing root
	mv s2, a2			# Address of word containing free list head


	# Check if tree is empty
	lw t0, 0(s1)
	beqz t0, delete_exit


	# Call recursive delete helper
	mv a0, s0			# Value to delete
	mv a1, s1			# Address of word containing root
	mv a2, s2			# Free list head address
	jal ra, delete_recursive


delete_exit:
	# Restore registers
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp, 16
	ret


# Recursive helper function for delete
delete_recursive:
	# Save registers
	addi sp, sp, -28
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)


	# Save parameters
	mv s0, a0				# Value to delete
	mv s1, a1				# Address of word containing current node's address
	mv s2, a2				# Address of word containing free list head


	# Load current node address
	lw s3, 0(s1)
	

	# Check if current node is NULL
	beqz s3, delete_recursive_exit
	

	# Load current node's value
	lw s4, 0(s3)


	# Compare value with current node's value
	beq s0, s4, delete_recursive_found	# Found the node to delete
	
	
	# Value > node value, go left
	bgt s0, s4, delete_recursive_left


	# Value < node value, go right
	addi a1, s3, 8				# Address of right child pointer
	jal ra, delete_recursive
	j delete_recursive_exit


delete_recursive_left:
	# Go to left child
	addi a1, s3, 4
	jal ra, delete_recursive
	j delete_recursive_exit


delete_recursive_found:
	# Found the node to delete


	# Check if node has no children 
	lw t0, 4(s3)				# Left child
	bnez t0, delete_recursive_has_children	# Branch if left child exists
	lw t1, 8(s3)				# Right child
	bnez t1, delete_recursive_has_children	# Branch if right child exists


	# Otherwise, the node has no children, and we delete
	sw zero, 0(s1)


	# Free the node
	mv a0, s2				# Free list head address
	mv a1, s3				# Node to free
	jal ra, free


	# Done, jump to exit
	j delete_recursive_exit
	

delete_recursive_has_children:
	# Check if node has only one child
	lw t0, 4(s3)				# Left child
	beqz t0, delete_recursive_right_only


	lw t0, 8(s3)				# Right child
	beqz t0, delete_recursive_left_only

	
	# Node has two children
	# Find successor (rightmost node in left subtree)
	lw s5, 4(s3)				# Start with left child
	addi t0, s3, 4				


# Finds the in-order successor (smallest value in right subtree)
delete_recursive_find_successor:
	# Check if current node has a right child
	lw t1, 8(s5)				# s5 points to the current node, add 8 to point to right child
	# If t1 equals 0, there is no right child
	# This means we have found the in-order successor (the left node)
	beqz t1, delete_recursive_found_successor
	

	# Otherwise, we have found a right child and move on to the right child
	addi t0, s5, 8				# Calculate address of right child pointer
	mv s5, t1				# Move to the right child
	j delete_recursive_find_successor	# This continues the loop until we reach a node with no right child

	
# When we reach here, it means we have found the in-order successor
delete_recursive_found_successor:
	# s5 now contains the successor node
	

	# Copy successor's value to node being deleted
	lw t1, 0(s5)				# Load successor value into t1
	sw t1, 0(s3)				# Store successor value into node being deleted (s3)


	# Now delete the successor node
	mv a0, t1				# Value to delete (successor's value)
	mv a1, t0				# Address of successor's pointer
	jal ra, delete_recursive
	

	# Exit delete
	j delete_recursive_exit 


delete_recursive_left_only:
	# Node has only left child
	lw t0, 4(s3)				# Left child
	sw t0, 0(s1)				# Update parent's pointer
	

	# Free the node
	mv a0, s2				# Free list head address
	mv a1, s3				# Node to free
	jal ra, free


	j delete_recursive_exit


delete_recursive_right_only:
	# Node has only right child
	lw t0, 8(s3)				# Right child
	sw t0, 0(s1)
	

	# Free the node
	mv a0, s2				# Free list head address
	mv a1, s3				# Node to free
	jal ra, free


delete_recursive_exit:
	# Restore registers
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	lw s5, 24(sp)
	addi sp, sp, 28
	ret
	

# Main program
_start:
	# Initialize tree and free list
	la a0, nodes			# Address of node memory
	li a1, 15			# 15 nodes
	jal ra init			# Initialize free list


	# Store free list head
	la t0, free_ptr
	sw a0, 0(t0)


main_loop:
	# Prompt for operation
	la a0, operation_prompt
	li a7, SYS_printStr
	ecall


	# Read operation
	la a0, buffer
	li a1, 10			# Buffer size
	li a7, SYS_readStr
	ecall


	#  Prompt for value
	lb t0, buffer
	li t1, 'I'
	beq t0, t1, do_insert
	li t1, 'D'
	beq t0, t1, do_delete
	li t1, 'S'
	beq t0, t1, do_sumupto
	j exit


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
	mv a0, s0			# a0 = integer value to insert
	la a1, root_ptr			# a1 = address of word containing root address
	la a2, free_ptr			# a2 = address of word containing free list head address
	jal ra, insert


	# Check result
	bnez a0, insert_failed
	j main_loop


insert_failed:
	la a0, insert_failed_message
	li a7, SYS_printStr
	ecall
	j main_loop


do_delete:
	# Prompt for value
	la a0, value_prompt
	li a7, SYS_printStr
	ecall

	
	# Read value
	li a7, SYS_readInt
	ecall
	mv s0, a0			# Save value


	# Discard remaining characters
	la a0, buffer
	li a1, 10
	li a7, SYS_readStr
	ecall

	
	# Call delete
	mv a0, s0			# Value to delete
	la a1, root_ptr			# Address of word containing root
	la a2, free_ptr			# Address of word containing free list head
	jal ra, delete

	
	j main_loop


do_sumupto:
	j main_loop


exit:
	li a7, SYS_exit
	li a0, 0
	ecall










