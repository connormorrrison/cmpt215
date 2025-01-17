# Fuction numbers for ecalls
	.equ SYS_exit, 93
	.equ SYS_printStr, 248

# Read-only data section
	.section .rodata

hello_world_string:
	.string "\nHello World!\n"

# Code section
	.section .text
	.globl _start

_start:
	la a0, hello_world_string
	li a7, SYS_printStr
	ecall

	li a0, 0
	li a7, SYS_exit
	ecall
