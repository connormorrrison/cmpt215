# function numbers for environment calls
        .equ SYS_exit,      93
        .equ SYS_printInt,  244
        .equ SYS_readInt,   245
        .equ SYS_printChar, 246
        .equ SYS_readChar,  247
        .equ SYS_printStr,  248
        .equ SYS_readStr,   249

        .equ NL, '\n'       # new line character

.section .rodata
prompt:
        .string "Enter a string (max 100 characters): "

len_msg:
        .string "The length of the string is "

.section .data
buf:
        .space 100

.section .text
.global _start
_start:
        la a0, prompt           # print prompt string
        li a7, SYS_printStr
        ecall

        # read the string
        la a0, buf              # address of string buffer in a0
        li a1, 100              # size of string buffer in a1
        li a7, SYS_readStr      # function 249 => read_string
        ecall

        # compute its length
        la t0, buf              # use to to hold the address of the current char
        mv s0, zero             # use s0 for string length, initialize to 0
loop:   lbu t1, 0(t0)           # load byte unsigned (lbu) to t1
        beq t1, zero, done      # if the character is 0, we reached the end
        addi s0, s0, 1          # otherwise, increment count
        addi t0, t0, 1          # and move to next byte (character)
        j loop                  # loop again

done:   la a0, len_msg          # print len_msg string
        li a7, SYS_printStr
        ecall

        mv a0, s0               # print count
        li a7, SYS_printInt
        ecall

        li a0, NL               # print newline character
        li a7, SYS_printChar
        ecall

        li a0, 0                # exit(0)
        li a7, SYS_exit
        ecall
