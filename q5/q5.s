.section .data
buffer: .space 1024
filename: .asciz "input.txt"
mode: .asciz "r"
yes: .asciz "YES"   
no: .asciz "NO"

.section .text
.globl main



main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)   
    sd s1, 24(sp)   # file pointerr
    sd s2, 16(sp)    # s2 = number of bytes read
    sd s3, 8(sp)     # left indx
    sd s4, 0(sp)     # right indx

    mv s0, a0  # argc
    mv s1, a1  # argv

    la a0, filename   # filename 
    la a1, mode   # mode for file handling
    call fopen
    mv s1, a0  #  store file ptr (file *)
    beqz s1, file_error   # fopne fail measure -> null
    

# read file into buffer
    # fread(void *ptr, size_t size, size_t count, file *stream)
    # pass 4 args
    la a0, buffer  # loading in the place to read str into
    li a1, 1  # size of 1 charac
    li a2, 1024 # count needed in the fread function argument
    mv a3, s1   # saving file ptr temporarily
    call fread 

    mv s2, a0   # no of bytes read by fread in det by a0, stored in s2

    mv a0, s1
    call fclose

    #when (if) file is empty err handling
    beqz s2, res_YES

    # newline handling
    addi t0, s2, -1  #last index
    la t1, buffer
    add t1, t1, t0 
    lb t2, 0(t1)  # accessing last character
    
    li t3, 10     # '\n'
    bne t2, t3, skip_newline

    addi s2, s2, -1  # decrementing the no of bytes (s2) by 1 to ignore newline,

skip_newline:
    #initialize the left n right pointers
    li s3, 0         #left=0
    addi s4, s2, -1  # right pointer= no of bytes read-1


# starting loop
palindrome_loop:
    # stop when pointers cross or meet 
    bge s3, s4, res_YES
    # load buffer[left]
    la t0, buffer
    add t1, t0, s3  # buffer +left
    lb t2, 0(t1)

    #load buffer [right]
    add t1, t0, s4
    lb t3, 0(t1)

    # not palindrome check
    bne t2, t3, res_NO

    # iterate ptrs
    addi s3, s3, 1
    addi s4, s4,  -1

    
    j palindrome_loop


#output printing
res_YES:
    la a0, yes
    call puts  # adds newline
    j end

res_NO:
    la a0, no
    call puts
    j end 

file_error:
    la a0, no
    call puts
    j end 


end:
    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    ld s4, 0(sp)
    addi sp, sp, 48
    ret





    



