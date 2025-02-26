# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
prompt_i: .asciz "Enter i: "
prompt_j: .asciz "Enter j: "
prompt_k: .asciz "Enter k: "

# Code section
	.section .text
	.globl _start

_start:
	# Prompt for i
	la a0, prompt_i
	li a7, SYS_printStr
	ecall

	# Read in i
	li a7, SYS_readInt
	ecall
	mv s0, a0

	# Check if i < 0
	bltz s0, exit


	# Prompt for j
        la a0, prompt_j
	li a7, SYS_printStr
        ecall

	# Read in j
        li a7, SYS_readInt
        ecall
        mv s1, a0

	# Check if j < 0
	bltz s1, exit


	# Prompt for k
        la a0, prompt_k
	li a7, SYS_printStr
        ecall

        # Read in k
        li a7, SYS_readInt
        ecall
        mv s2, a0

	# Check if k < 0
	bltz s2, exit

exit:
	li a0, 0
	li a7, SYS_exit
	ecall
