.globl main
.section text

main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)   
    sd s1, 24(sp)   # file
    sd s2, 16(sp)    # buffer
    sd s3, 8(sp)     
    sd s4, 0(sp)

    mv s0, a0  # argc
    mv s1, a1  # argv

    la a0, input.text
    la a1, ra
    call fopen
    mv s1, a0

    




