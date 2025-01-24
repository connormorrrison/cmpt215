# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printStr, 248
	.equ SYS_readStr, 249

# Read-only data section
	.section .rodata
prompt: .asciz "Enter a string: "
result_message: "String after Caesar Cipher encoding: "

# Uninitialized data section
	.section .bss
str: .space 128

# Code section
	.section .text
	.globl _start

_start:

exit:
	li a0, 0
	li a7, SYS_exit
	ecall
