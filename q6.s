# Function numbers for environment calls
	.equ SYS_exit,93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
	.section .rodata
prompt_n:      .asciz "Enter the number of elements (max 25): "
prompt_number: .asciz "Enter number: "
prompt_i:      .asciz "Enter i: "
prompt_j:      .asciz "Enter j: "
prompt_result: .asciz "Result: "
newline:       .asciz "\n"

# Uninitialized data section
	.section .bss
array: .space 100      # space for 25 integers (25*4 bytes)

# Code section
.section .text
.globl _start

_start:
