# Function numbers for environment calls
	.equ SYS_exit,93
	.equ SYS_readStr, 249
	.equ SYS_printStr, 248
	.equ SYS_readInt, 245

# Read-only data section
	.section .rodata
prompt_string:    .asciz "Enter string: "
prompt_character: .asciz "Enter characters: "
prompt_n:         .asciz "Enter n: "
output_string:    .asciz "Modified string: "
newline:          .asciz "\n"

# Uninitialized data section
	.section .bss
original_string: .space 41	# Enough for 40 chars + null terminator
modified_string: .space 41	# Enough for 40 chars + null terminator

# Code section
.section .text
.globl _start

_start:
	# Print string prompt
	li a7, SYS_printStr
	la a0, prompt_string
	ecall

	# Read string
	li a7, SYS_readStr
	la a0, original_string
	li a1, 41
	ecall
	
read_character:
	# Print character prompt
	li a7, SYS_printStr
	la a0, prompt_character
	ecall

	# Read character
	li a7, SYS_readStr
	la a0, modified_string
	li a1, 41
	ecall

read_n:
	# Print n prompt
	li a7, SYS_printStr
	la a0, prompt_n
	ecall
	
	# Read n
	li a7, SYS_readInt
	ecall
	
	mv a2, a0	# a2 = n

	# If n <= 0, exit
	ble a2, 0, exit

exit:
	li a0, 0
	li a7, SYS_exit
	ecall
	




	######### TESTING #########
	# TEST: Print output prompt
	la a0, output_string
	li a7, SYS_printStr
	ecall

	# Print original string
	la a0, original_string
	li a7, SYS_printStr
	ecall

	# Exit
	li a7, SYS_exit
	li a0, 0
	ecall
