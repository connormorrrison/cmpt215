# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
	.section .rodata
prompt: .asciz "Enter up to 25 integers:\n"
output: .asciz "Returned value: \n"

# Uninitialized data section
	.section .bss
array:	.space 100

# Code section
	.section .text
	.globl _start

_start: 
	la a0, prompt
	li a7, SYS_printStr
	ecall
	
	la s0, array
	li s1, 25

loop:
	li a7, SYS_readInt
	ecall
	sw a0, 0(s0)
	addi s0, s0, 4
	addi s1, s1, -1
	bnez s1, loop

	addi s0, s0, -4
	li s1, 25

	la a0, output
	li a7, SYS_printStr
	ecall

	# Exit
	li a0, 0
	li a7, SYS_exit
	ecall
