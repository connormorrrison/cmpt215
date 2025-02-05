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

