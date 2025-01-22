# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
	.section .rodata
prompt_n:       .asciz "Enter the number of integers: \n"
prompt_value:     .asciz "Enter an integer: \n"
output_message: .asciz "Count of numbers with absolute value 42: \n"

# Code section
	.section .text
	.globl _start

_start:
	# Print prompt for N
	la a0, prompt_n
	li a7, SYS_printStr
	ecall

	# Exit the program
	li a0, 0
	li a7, SYS_exit
	ecall
