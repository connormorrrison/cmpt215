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
	addi s0, s0, 4
	addi t1, t1, 1
	
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

	# Print integer
	
	# Print newline
	la a0, newline
	li a7, SYS_printStr
	ecall

# Parameters:
# a0 = array
# a1 = n
# a2 = i
# a3 = j
sum_subarray:
	# ex. n = 7
	# ex. i = 6
	# ex. j = 9	

	# Compute max
	# ex. max(1, i) = max(1, 6) = 6
	li t0, 1	# Load lower bound (1, )
	bge a2, t0, use_i

	# Compute min
	# ex. min(n, j) = min(7, 9) = 7

use_i:
	mv t1, a2	# lower

exit:
	li a0, 0
	li a7, SYS_exit
	ecall
