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

	# Print prompt result
	la a0, prompt_result
	li a7, SYS_printStr
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
# Parameters:
#   a0 = array pointer
#   a1 = n
#   a2 = i
#   a3 = j
# Return sum
sum_range:
	# i = max(1, i)
	li t0, 1	# t0 = 1
	bge a2, t0, use_i	# If a2 (i) >= t0 (1), branch to store i
	mv a2, t0

use_i:
	# j = min(n, j)
	bgt a3, a1, use_j	# If a3 (j) >= a1 (n), branch to store_j
	
	# Else a3 (j) < a1 (n), fall down to use_j
	mv a3, a1

use_j:
	# If i > j, return 0
	bgt a2, a3, return_zero

	# Else, we sum from i to j
	li t2, 0	# t2 = 0 (sum counter)

	addi t1, a2, -1	# Minus 1 from a2 (i) and store in t1
	add t2, t1, t1	# t2 = 2 * (i - 1)
	add t2, t2, t2	# t2 = 4 * (i - 1)
	add t1, a0, t2 	# t1 = array + 4 * (i - 1)
	

return_zero:
	li a0, 0
	ret

