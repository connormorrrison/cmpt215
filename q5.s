# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
	.section .rodata
prompt_n:       .asciz "Enter the number of integers: \n"
prompt_value:   .asciz "Enter an integer: \n"
output_message: .asciz "Count of numbers with value 42: \n"

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

	# Initialize counter for loop
	mv s1, zero	# Intialize s1 to 0; s1 = count of numbers with value 42
	mv s2, zero	# Intialize s2 to 0; loop counter

loop:
	# Check if processed N numbers
	beq s2, s0, done
	
	la a0, prompt_value
	li a7, SYS_printStr
	ecall

	li a7, SYS_readInt
	ecall

	abs t0, a0	# Get the absolute value of value in a0, then store in t0
	li t1 42
	beq t0, t1, abs_counter

loop_counter:
	addi s2, s2, 1
	j loop
	

abs_counter:
	addi s1, s1, 1
	j loop


done:
	# Exit the program
	li a0, 0
	li a7, SYS_exit
	ecall
