# Function numbers for environment calls
	.equ SYS_exit, 93
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
array:	.space 100	# 25 integers * 4 bytes

# Code section
	.section .text
	.globl _start

_start: 
	# Prompt for n
	la a0, prompt_n
	li a7, SYS_printStr
	ecall
	
	# Read in n
	li a7, SYS_readInt
	ecall
	mv s1, a0	# s0 = n
	
	# Ensure n <= 25
	li t0, 25
	bgt s1, t0, exit

	# Else array is <= 25, and read ints into array
	la s0, array
	li t1, 0	# Start counter at 0

read_number_loop:
	# Prompt for number
	la a0, prompt_number
	li a7, SYS_printStr
	ecall

	# Read in number
	li a7, SYS_readInt
	ecall
	sw a0, 0(s0)
	addi s0, s0, 4
	addi t1, t1, 1
	
	# Repeat read_number_loop
	j read_number_loop

read_i_j_loop:
	# Prompt for i
	la a0, prompt_i
	li a7, SYS_printStr
	ecall	

	# Read in i
	li a7, SYS_readInt
	ecall
	mv s2, a0	# s2 = i

	# Prompt for j
	la a0, prompt_j
	li a7, SYS_printStr
	ecall

	# Read in j
	li a7, SYS_readInt
	ecall
	mv s3, a0	# s3 = j

exit:
	li a0, 0
	li a7, SYS_exit
	ecall





	#la a0, prompt
	#li a7, SYS_printStr
	#ecall
	
	#la s0, array
	#li s1, 25

loop:
	#li a7, SYS_readInt
	#ecall
	#sw a0, 0(s0)
	#addi s0, s0, 4
	#addi s1, s1, -1
	#bnez s1, loop

	#addi s0, s0, -4
	#li s1, 25

	#la a0, output
	#li a7, SYS_printStr
	#ecall

	# Exit
	li a0, 0
	li a7, SYS_exit
	ecall
