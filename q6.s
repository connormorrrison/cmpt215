# Function calls for environment calls
	.equ SYS_exit, 93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
	.section .rodata
prompt_array:      .asciz "Enter 10 integers: \n"
prompt_m:          .asciz "Enter an integer M to search for: "
found_message:     .asciz "Found at position: "
not_found_message: .asciz "Not found.\n"
newline:           .asciz "\n"

# Uninitialized data section
	.section .bss
array: .space 40	# 10 integers * 4 bytes each

# Code section
	.section .text
	.globl _start

_start:
	# Prompt for array input
	la a0, prompt_array
        li a7, SYS_printStr
        ecall

	# Read 10 integers into the array
	la s0, array	# s0 = current array pointer position
	li s1, 10	# s1 = how many integers left to read

input_loop:
	# Read integer
	li a7, SYS_readInt
	ecall
	sw a0, 0(s0)	# Store integer at current pointer position
	addi s0, s0, 4	# Move pointer to next position
	addi s1, s1, -1	# Decrement counter
	bnez s1, input_loop

search_start:
        # Prompt for integer M
        la a0, prompt_m
        li a7, SYS_printStr
        ecall

        # Read integer M
        li a7, SYS_readInt
        ecall
        mv s2, a0	# Store M in s2

        # Reset array pointer for searching
        la s0, array	# Point back to start of array
        li s1, 10	# 10 elements to search
	li s3, 1	# s3 = position index (1 to 10)

search_loop:
        beqz s1, not_found	# If s0 = 0, out of elements

        lw t1, 0(s0)	# Load integer from current array position
        bge t1, s2, found	# If array element >= m, found match

	# Move to next array element
	addi s0, s0, 4
	addi s1, s1, -1
	addi s3, s3, 1
	j search_loop	# Repeat the search loop

found:
	# Print found_message
	la a0, found_message
	li a7, SYS_printStr
	ecall

	# Print position
	mv a0, s3
	li a7, SYS_printInt
	ecall

	la a0, newline
	li a7, SYS_printStr
	ecall

	j search_start	# Prompt for next m

not_found:
	# Print not_found_message once no match, then exit
	la a0, not_found_message
	li a7, SYS_printStr
	ecall

exit:
	li a0, 0
	li a7, SYS_exit
	ecall
