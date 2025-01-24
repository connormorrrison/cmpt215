# Function calls for environment calls
	.equ SYS_exit, 93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
	.section .rodata
prompt_array:      .asciz "Enter 10 integers: "
prompt_m:          .asciz "Enter an integer M to search for: "
found_message:     .asciz "Found at position: "
not_found_message: .asicz "Not found.\n"
newline:           .asciz "\n"

# Uninitialized data section
	.section .bss
array: .space 40	# 10 integers * 4 bytes each

# Code section
	.section .text
	.globl _start

_start:
	# Initialize array
	la s0, array	# s0 = array pointer
	li s1, 10	# s1 = counter for number of elements

input_loop:
	# Prompt for array
	la a0, prompt_array
	li a7, SYS_printStr
	ecall

	# Read integer
	li a7, SYS_readInt
	ecall
	sw a0, 0(s0)	# Store integer at current pointer
	addi s0, s0, 4	# Move pointer to next position (move 4 bytes)
	addi s1, s1, -1	# Decrement counter (effectively decrease available array size)
	bnez s1, input_loop

search_start:
	# Prompt for input integer M
	la a0, prompt_m
	li a7, SYS_printStr
	ecall

	# Read integer M
	li a7, SYS_readInt
	ecall
	mv s2, a0	# Move integer M from register a0 to s2

	# Reset array pointer and element counter
	la s0, array
	li s1, 1

search_loop:
	li 

exit:
	li a0, 0
	li a7, SYS_exit
	ecall
