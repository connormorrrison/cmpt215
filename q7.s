# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printStr, 248
	.equ SYS_readStr, 249

# Read-only data section
	.section .rodata
prompt_input:   .asciz "Enter a string (max 20 characters): "
result_message: .asciz "Encoded string: "
newline:        .asciz "\n"

# Uninitialized data section
	.section .bss
str: .space 128	# Buffer for up to 127 chars + null

# Code section
	.section .text
	.globl _start

_start:
	# Print input prompt
	la a0, prompt_input
	li a7, SYS_printStr
	ecall

	# Read characters + null
	la a0, str
	li a1, 128	# Max number of bytes (including null terminator)
	li a7, SYS_readStr
	ecall

	la s0, str	# Load address of input string into s0

encoding_loop:
	# Load first character
	la t0, 0(s0)

	beqz t0, display_result	# If '\0' reached, we stop
	
	# Check if character is lowercase
	li t1, 'a'
	li t2, 'z'
	

display_result:
	# Print encoding message
	la a0, result_message
	li a7, SYS_printStr
	ecall

	# TODO add code for printing encoded string

	la a0, newline
	li a7, SYS_printStr
	ecall

exit:
	li a0, 0
	li a7, SYS_exit
	ecall
