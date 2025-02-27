# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248
	.equ SYS_printFloat, 250


# Read-only data section
	.section .rodata
prompt_k:       .asciz "Enter k: "
result_message: .asciz "Result: "
newline:        .asciz "\n"


# Code section
	.section .text
	.globl _start


_start:
	# Prompt for k
	la a0, prompt_k
	li a7, SYS_printStr
	ecall

	# Read in k
	li a7, SYS_readInt
	ecall
	mv s0, a0


	# Compute constants
	# Convert 1 to float
	li t0, 1
	fcvt.s.w f0, t0

	# Convert 2 to float
	li t0, 2
	fcvt.s.w f1, t0
	
	# Convert 6 to float
	li t0, 6
	fcvt.s.w f2, t0


	
