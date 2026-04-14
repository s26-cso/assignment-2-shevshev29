.section .data
filename: .asciz "input.txt"
mode: .asciz "r"
yes: .asciz "Yes"   
no: .asciz "No"

left_buf: .space 1
right_buf: .space 1

.section .text
.globl main



main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)   
    sd s1, 24(sp)    # file pointerr
    sd s2, 16(sp)    # s2 = number of bytes read
    sd s3, 8(sp)     # left indx
    sd s4, 0(sp)     # right indx

    mv s0, a0  # argc
    mv s1, a1  # argv

    la a0, filename   # filename 
    la a1, mode   # mode for file handling
    call fopen
    mv s1, a0  #  store file ptr (file *)
    beqz s1, file_error   #fopne fail measure -> null
    
    # getting file len with fseek and ftell
    mv a0, s1
    li a1, 0
    li a2, 2          # seek_end 
    call fseek        # moves ptr to end

    mv a0, s1
    call ftell        # gives file size
    mv s2, a0         # s2=file length, no of bytes read

    beqz s2, res_YES  # empty file

    # newline handling

    mv a0, s1
    addi a1, s2, -1   # go to end (last element)
    li a2, 0          # seek_set
    call fseek

    # read the last byte into right_buf
    la a0, right_buf
    li a1, 1
    li a2, 1
    mv a3, s1
    call fread

    #checking if the last char read is newline '\n'
    la t0, right_buf
    lb t1, 0(t0) # accessing last character

    li t2, 10  # this is ASCII newline
    bne t1, t2, skip_newline
    addi s2, s2, -1   # decrementing the no of bytes (s2) by 1 to ignore newline
 
skip_newline:
    #initialize the left n right pointers
    li s3, 0         # left=0
    addi s4, s2, -1  # right pointer= no of bytes read-1


# starting loop
palindrome_loop:
    # stop when pointers cross or meet 
    bge s3, s4, res_YES
    # load buffer[left]
    mv a0, s1
    mv a1, s3
    li a2, 0
    call fseek # seek to the left and read 1 byte

    la a0, left_buf
    li a1, 1
    li a2, 1
    mv a3, s1
    call fread

    #load buffer [right] seek to the right and read 1 byte
    mv a0, s1
    mv a1, s4
    li a2, 0
    call fseek

    la a0, right_buf
    li a1, 1
    li a2, 1
    mv a3, s1
    call fread

    # not palindrome check
    la t0, left_buf
    lb t1, 0(t0)

    la t0, right_buf
    lb t2, 0(t0)

    # not a palindrome
    bne t1, t2, res_NO

    # iterate ptrs
    addi s3, s3, 1
    addi s4, s4, -1

    j palindrome_loop


#output printing
res_YES:
    mv a0, s1
    call fclose
    la a0, yes
    call puts  # adds newline
    j end

res_NO:
    mv a0, s1
    call fclose
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

