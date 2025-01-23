# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
	.section .rodata
prompt_n:       .asciz "Enter the number of integers: "
prompt_value:   .asciz "Enter an integer: "
output_message: .asciz "Count of numbers with absolute value 42: "
newline:        .asciz "\n"

# Code section
	.section .text
	.globl _start

_start:
	# Print prompt for N
	la a0, prompt_n
	li a7, SYS_printStr
	ecall

	# Read N
	li a7, SYS_readInt
	ecall
	mv s0, a0	# Move value from a0 to s0

	# Exit if N <= 0
	blez s0, exit

	# Initialize counters
	mv s1, zero	# Intialize s1 to 0; s1 = count of numbers with value 42
	mv s2, zero	# Intialize s2 to 0; loop counter

loop:
	# Check if processed N numbers
	beq s2, s0, result

	la a0, prompt_value
	li a7, SYS_printStr
	ecall

	li a7, SYS_readInt
	ecall	# Input in a0

	# Get absolute value
	mv t0, a0
	bgez t0, skip_abs	# If value >= 0, skip negation
	neg t0, t0

skip_abs:
	# Check if number is 42
	li t1, 42
	bne t0, t1, skip_count
	addi s1, s1, 1	# Increment s1 count

skip_count:
	# Increment loop counter and continue
	addi s2, s2, 1
	j loop

result:
	# Print result message
	la a0, output_message
	li a7, SYS_printStr
	ecall

	# Print result count
	mv a0, s1
	li a7, SYS_printInt
	ecall

	la a0, newline
	li a7, SYS_printStr
	ecall

exit:
	li a0, 0
	li a7, SYS_exit
	ecall
