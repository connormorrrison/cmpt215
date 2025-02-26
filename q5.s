# Function numbers for environment calls
	.equ SYS_exit, 93
	.equ SYS_printInt, 244
	.equ SYS_readInt, 245
	.equ SYS_printStr, 248

# Read-only data section
prompt_i:       .asciz "Enter i: "
prompt_j:       .asciz "Enter j: "
prompt_k:       .asciz "Enter k: "
result_message: .asciz "C215 result: "
newline:        .asicz "\n"

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


	# Call recursive function
	mv a0, s0		# a0 = i
	mv a1, s1		# a1 = j
	mv a2, s2		# a2 = k
	call c215

exit:
	li a0, 0
	li a7, SYS_exit
	ecall

# Arguments:
# a0 = i
# a1 = j
# a2 = k
# Returns:
# a0 = result
c215:
	addi sp, sp, -12	# Allocate 12 bytes on the stack
	sw ra, 0(sp)		# Save return address
	sw s0, 4(sp)		# Save s0
	sw s1, 8(sp)		# ...
	sw s2, 12(sp)
	
	# Save arguments
	mv s0, a0		# s0 = i
	mv s1, a1		# s1 = j
	mv s2, a2		# s2 = k

	# Base case (c215(1, 1, 1))
	bnez s0, not_base_case
	bnez s1, not_base_case
	bnez s2, not_base_case
	li a0, 1
	j c215_exit		

not_base_case:
	# First recursive call c215([(k+1)/2], [(i+j)/4], [|i-j|/2])
	# Calculate (k+1)/2
	addi t0, s2, 1		# t0 = k+1
	srai t0, t0, 1		# t0 = (k+1)/2

	# Calculate (i+j)/4
	addi t1, s0, s1		# t1 = (i+j)
	srai t1, t1, 2 		# t1 = i+j)/4

	# Calculate |i-j|/2
	sub t2, s0, s1		# t2 = i-j
	neg t3, t2		# t3 = -(i-j)
	max t2, t2, t3		# t2 = |i-j|
	srai t2, t2, 1		# t2 = |i-j|/2
	

        # Second recursive call c215([(i+k)/2], [|i-k|/2], [(j+3)/4])
        # Calculate (i+k)/2
        # Calculate |i-k|/2
        # Calcualte (j+3)/4

        # Third recursive call c215([(i+j)/4], [|j-k|/2], [(i+1)/4])
        # Calculate (i+j)/4
        # Calculate |j-k|/2
        # Calcualte (i+1)/4

	# Result = term1 + term2 + term3 + 1


c215_exit:
	lw ra, 0(sp)		# Restore return address
	lw s0, 4(sp)		# Restore s0
	lw s1, 8(sp)		# ...
	lw s2, 12(sp)
	addi sp, sp, 12		# Deallocate 12 bytes on the stack
	ret

