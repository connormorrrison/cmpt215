# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
	.section .rodata
prompt_n:       .asciz "Enter the number of integers: \n"
prompt_val:     .asciz "Enter an integer: \n"
output_message: .asciz "Count of numbers with absolute value 42: \n"


