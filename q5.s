# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
	.section .rodata
prompt_n:      .asciz "Enter the number of elements (max 25): "
prompt_number: .asciz "Enter number: "
prompt_i:      .asciz "Enter i: "
prompt_j:      .asciz "Enter j: "
prompt_result: .asciz "Result: "
newline:       .asciz "\n"

# Uninitialized data section
	.section .bss
array:	.space 100	# 25 integers * 4 bytes

# Code section
	.section .text
	.globl _start

_start: 
	# Prompt for n
	la a0, prompt_n
	li a7, SYS_printStr
	ecall
	
	# Read in n
	li a7, SYS_readInt
	ecall
	mv s1, a0	# s1 = n
	
	# If n < 1, exit immediately
	li t0, 1
	blt s1, t0, exit

	# Ensure n <= 25
	li t0, 25
	bgt s1, t0, exit

	# Else array is <= 25, and read ints into array
	la s0, array
	li t1, 0	# Start counter at 0

read_number_loop:
	bge t1, s1, read_i_j	# Stop read_number_loop when we have read n numbers	

	# Prompt for number
	la a0, prompt_number
	li a7, SYS_printStr
	ecall

	# Read in number
	li a7, SYS_readInt
	ecall
	sw a0, 0(s0)
	addi s0, s0, 4	# Move to next element
	addi t1, t1, 1	# Increment counter
	
	# Repeat read_number_loop
	j read_number_loop

read_i_j:
	# Prompt for i
	la a0, prompt_i
	li a7, SYS_printStr
	ecall	

	# Read in i
	li a7, SYS_readInt
	ecall
	mv s2, a0	# s2 = i

	# Prompt for j
	la a0, prompt_j
	li a7, SYS_printStr
	ecall

	# Read in j
	li a7, SYS_readInt
	ecall
	mv s3, a0	# s3 = j

	# Call sum_range(array, n, i, j)
	la a0, array	# Array
	mv a1, s1	# a1 = n
	mv a2, s2	# a2 = i
	mv a3, s3	# a3 = j
	jal ra, sum_range

	mv t0, a0	# Save the returned sum in t0

	# Print prompt result
	la a0, prompt_result
	li a7, SYS_printStr
	ecall
	
	# Print sum returned by a0
	mv a0, t0
	li a7, SYS_printInt
	ecall

	# Print newline
	la a0, newline
	li a7, SYS_printStr
	ecall

exit:
	li a0, 0
	li a7, SYS_exit
	ecall

# sum_range(array, n, i, j):
# a0 = array pointer, a1 = n, a2 = i, a3 = j
# Return sum in a0
sum_range:
	# i = max(1, i)
	li t0, 1
	bge a2, t0, use_i	# If i >= 1, keep it as is
	mv a2, t0	# Otherwise, set i = 1

use_i:
	# j = min(n, j)
	ble a3, a1, skip_use_j	# If j <= n, keep it as is
	mv a3, a1	# Otherwise, set j = n

skip_use_j:
	# If i > j, return 0
	bgt a2, a3, return_zero

	li t4, 0	# t4 = sum = 0
	addi t2, a2, -1	# Convert 1-based indexing to 0-based by subtracting 1
	add t2, t2, t2 	# t2 = 2 * (i-1)
	add t2, t2, t2 	# t2 = 4 * (i-1)
	add t1, a0, t2	# t1 = address of array (0-based indexing)
	
sum_loop:
	lw t3, 0(t1)
	add t4, t4, t3	# sum += array[i]
	addi t1, t1, 4	# Move to next element
	addi a2, a2, 1	# i++
	ble a2, a3, sum_loop	# If i <= j, continue loop

	# Store final result in a0 and return
	mv a0, t4
	ret

return_zero:
	li a0, 0
	ret

