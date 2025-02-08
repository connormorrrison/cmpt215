# Function numbers for environment calls
	.equ SYS_exit,93
	.equ SYS_readStr, 249
	.equ SYS_printStr, 248
	.equ SYS_readInt, 245

# Read-only data section
	.section .rodata
prompt_string:    .asciz "Enter string: "
prompt_character: .asciz "Enter character: "
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

main:
	# Print n prompt
	li a7, SYS_printStr
	la a0, prompt_n
	ecall
	
	# Read n
	li a7, SYS_readInt
	ecall
	mv a2, a0	# a2 = n

	# If n <= 0, exit early
	blez a2, exit

	# Call function
	la a0, input_string
	la a3, output_string
	jal ra, remove_repeated_characters

	# Print output string prompt
	li a7, SYS_printStr
	la a0, output_string
	ecall

	# Print modified string
	li a7, SYS_printStr
	la a0, output_string

	j main	# Loop to prompt for n

valid_n:
	la a0, input_string
	la a3, output_string
	jal ra, remove_repeated_characters

exit:
	li a0, 0
	li a7, SYS_exit
	ecall

# remove_repeated_characters:
#
# a0 = input string
# a1 = target character
# a2 = n 
# a3 = output string
#
# t0 = current input character
# t1 = current output position
# t2 = counter for occurrences of target character
# t3 = current character
# t4 = counter for copy loop
remove_repeated_characters:
	# Store input, and output string pointers
	mv t0, a0
	mv t1, a3
	li t2, 0

process_character:
	lb t3, 0(t0)	# Load current character
	beqz t3, done	# If null terminator, branch to done

	# If the current character equals the target character, increment target counter
	beq t3, a1, accumulate_target
    
not_target:
	beq t2, zero, copy_current	# Counter for target occurrences is zero, branch to copy_current

	# Compare if (occurrence counter) == (n), branch to skip_copy
	beq t2, a2, skip_copy
	
	# Otherwise, copy the rest of the available run (ie. number of target occurrences != n).
	j copy_previous

accumulate_target:
	addi t2, t2, 1	# Increment counter for target occurrences
	j next_character

skip_copy:
	# Run length equals n, don't copy the run anymore
	li t2, 0	# Reset counter
	
	# Continue copying non-target current character
	sb t3, 0(t1)
	addi t1, t1, 1
	j next_character

copy_previous:
	# Copy the entire run stored in t2 (which is not equal to n)
	mv t4, t2	# t4 = number of target characters to copy

copy_loop:
	beqz t4, copy_current
	sb a1, 0(t1)	# Copy the target character into output
	addi t1, t1, 1
	addi t4, t4, -1
	j copy_loop

copy_current:
	li t2, 0	# Reset run counter
	sb t3, 0(t1)	# Copy the current non-target character
	addi t1, t1, 1

next_character:
	addi t0, t0, 1	# Advance input pointer
	j process_character

done:
	# If a pending run exists, process it
	bgtz t2, done_process_run
	j finish

done_process_run:
	# If the remaining run equals n, skip
	beq t2, a2, finish
	mv t4, t2	# t4 = remaining run count

done_copy_loop:
	beqz t4, finish
	sb a1, 0(t1)	# Copy target character into output
	addi t1, t1, 1
	addi t4, t4, -1
	j done_copy_loop

finish:
	sb zero, 0(t1)	# Null terminate output string
	ret
