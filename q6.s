# Function calls for environment calls
	.equ SYS_exit, 93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
	.section .rodata
prompt_array: .asciz "Enter 10 integers: "

# Uninitialized data section
	.section .bss
array: .space 40	# 10 integers * 4 bytes each

# Code section
	.section .text
	.globl _start

_start:
	# Initialize array
	la s0, array	# s0 is array pointer
	li s1, 10

loop:
	# Prompt for array
	la a0, prompt_array
	li a7, SYS_printStr
	ecall

	# Read integer
	li a7, SYS_readInt
	ecall
	sw a0, 0(s0)	# Store at current pointer
	addi s0, s0 4	# Move pointer to next position

exit:
	li a0, 0
	li a7, SYS_exit
	ecall
