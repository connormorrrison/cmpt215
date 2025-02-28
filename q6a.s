# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248
	.equ SYS_printFloat, 250


# Read-only data section
	.section .rodata
prompt_k:       .asciz "Enter k: "
result_message: .asciz "Result: "
newline:        .asciz "\n"


# Code section
	.section .text
	.globl _start


_start:
	# Prompt for k
	la a0, prompt_k
	li a7, SYS_printStr
	ecall

	# Read in k
	li a7, SYS_readInt
	ecall
	mv s0, a0


	# Compute constants
	li t0, 1
	fcvt.s.w f0, t0			# f0 = 1.0

	li t0, 2
	fcvt.s.w f1, t0			# f1 = 2.0
	
	li t0, 6
	fcvt.s.w f2, t0			# f2 = 6.0

	li t0, 3
	fcvt.s.w f3, t0
	fsqrt.s f3, f3			# f3 = sqrt(3)

	fdiv.s f4, f0, f3		# f4 = 1/sqrt(3) (t_0)


	# Counter for loop_tk
	li t1, 0			# i = 0


loop_tk:
	beq t1, s0, end_loop_tk		# If i == k, exit loop
	
	# Calculate next t_{i+1}
	fmul.s f5, f4, f4		# t_i^2
	fadd.s f5, f5, f0		# t_i^2 + 1
	fsqrt.s f5, f5			# sqrt(t_i^2 + 1)
	fsub.s f5, f5, f0		# sqrt(t_i^2 + 1) - 1
	fdiv.s f4, f5, f4		# (sqrt(t_i^2 + 1) - 1)/t_i


	# Increment counter for loop_tk
	addi t1, t1, 1
	j loop_tk


end_loop_tk:
	# Calculate n = 6 * 2^k	
	# Calculate (2^k)
	li t2, 1
	sll t2, t2, s0			# t2 = 2^k

	# Calculate 6 * 2^k 
	sll t3, t2, 2
	sll t4, t2, 1
	add t2, t3, t4			# t2 = 6 * 2^k = (4 * t2) + (2 * t2)

	
	# Calculate P_n = n * t_k	
	fcvt.s.w f2, t2
	fmul.s f4, f2, f4		# f4 = n * t_k


print_results:
	# Print result message
	la a0, result_message
	li a7, SYS_printStr
	ecall

	# Print result
	fmv.x.s a0, f4
	li a1, 'E'			# Exponent notation
	li a2, 6			# 6 decimal digits
	li a7, SYS_printFloat
	ecall

	# Print newline
	la a0, newline
	li a7, SYS_printStr
	ecall


exit:
	li a0, 0
	li a7, SYS_exit
	ecall
