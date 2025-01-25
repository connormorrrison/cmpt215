# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printStr, 248
	.equ SYS_readStr, 249

# Read-only data section
	.section .rodata
prompt_input:   .asciz "Enter a string (max 20 characters): "
result_message: .asciz "Encoded string: "
newline:        .asciz "\n"

# Uninitialized data section
	.section .bss
unencoded_str: .space 21	# Space for unencoded string (127 chars + null)
encoded_str:   .space 21	# Space for encoded string (127 chars + null)

# Code section
	.section .text
	.globl _start

_start:
	# Print input prompt
	la a0, prompt_input
	li a7, SYS_printStr
	ecall

	# Read characters + null
	la a0, unencoded_str
	li a1, 21	# Max number of bytes (including null terminator)
	li a7, SYS_readStr
	ecall

	la s0, unencoded_str	# Load address of input string into s0
	la s1, encoded_str	# Load address of output string into s1

encoding_loop:
	# ASCII uppercase letters range: 65-90
	# ASCII lowercase letters range: 97-122
	lb t0, 0(s0)	# Load the first character
	beqz t0, display_result	# If '\0' reached, stop
	
	# Check if character is lowercase
	li t1, 'a'
	li t2, 'z'
	blt t0, t1, check_uppercase	# If first character less than 97-122, branch to check_uppercase
	bgt t0, t2, encoding_skip	# If char > z, it's a non-alphabetic char, so skip

	# If we get to this point, char is lowercase, so handle it
	addi t0, t0, 15	# 15 position shift right
	bgt t0, t2, wrap_lowercase

	j store_char
	
wrap_lowercase:
	addi t0, t0, -26
	
	j store_char

check_uppercase:
	# Check uppercase
	li t1, 'A'
	li t2, 'Z'
	blt t0, t1, encoding_skip	# If char < A (65), it is a non-alphabetic char, so skip
	bgt t0, t2, encoding_skip	# If char > Z (90), it is also non-alphabetic, so skip
	
	# If we get to this point, char is uppercase, so handle it
	addi t0, t0, 15	# 15 position shift right
	bgt t0, t2, wrap_uppercase

	j store_char

wrap_uppercase:
	addi t0, t0, -26
	
	j store_char

encoding_skip:
	# For non-alphanumeric characters without modification
	j store_char

store_char:
	sb t0, 0(s1)	# Store char from t0 to s1, at offset 0
	addi s0, s0, 1
	addi s1, s1, 1
	
	j encoding_loop

display_result:
	# Print encoding message
	la a0, result_message
	li a7, SYS_printStr
	ecall	

	# Printing encoded string
	la a0, encoded_str
	li a7, SYS_printStr
	ecall

exit:
	li a0, 0
	li a7, SYS_exit
	ecall
