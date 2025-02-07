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
output_message:    .asciz "Modified string: "
newline:          .asciz "\n"

# Uninitialized data section
	.section .bss
input_string:        .space 41	# Enough for 40 chars + null terminator
output_string:       .space 41	# Enough for 40 chars + null terminator
character_to_remove: .space 1	# Store single character

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
	la a0, input_string
	li a1, 41
	ecall
	
read_character:
	# Print character prompt
	li a7, SYS_printStr
	la a0, prompt_character
	ecall

	# Read character
	li a7, SYS_readStr
	la a0, character_to_remove
	li a1, 2	# 1 (character) + 1 (newline) = 2
	ecall

	lb a1, character_to_remove	# Load the character to remove

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
	blez a2, exit

	######## IMPLEMENT #########
	# Call _ function
	# IMPLEMENT

	# Print output string prompt
	li a7, SYS_printStr
	la a0, output_string
	ecall

	# Print modified string
	li a7, SYS_printStr
	la a0, modified_string

	j read_n	# Loop to prompt for n

exit:
	li a0, 0
	li a7, SYS_exit
	ecall
	
# remove_repeated_characters():
# a0 = input string, a1 = character to remove, a2 = n, a3 = output string
# Return modified string in a0
remove_repeated_characters:
	mv t0, a0	# t0 = input string
	mv t1, a3	# t1 = output string




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
