.globl main # fior the linker (OS) to find main
.section .text



main:
    addi sp, sp, -64 # we're storing 4 items
    sd ra, 56(sp)
    sd s0, 48(sp)     # argc
    sd s1, 40(sp)    # argv
    sd s2, 32(sp)    # array pointer
    sd s3, 24(sp)
    sd s4, 16(sp)
    sd s5, 8(sp)
    sd s6, 0(sp)


    # after space alloc, we must save the vals of a0=argc and a1=argv into save regs since we will call maloc and atoi
    # the OS reads the inputs (argc and argv by this point, into s0 and s1?)
    mv s0, a0
    mv s1, a1 

    # we need to get argc-1 since input argc includes ./a.out while reading 
    addi a0, s0, -1   # putting into a0 since argc-1 is used temporarily
    slli a0, a0, 2    # *mul by 4 (2^2) calc the final n to iterate the loop to since an int is 4 bytes 
    call malloc       # alloc n space 

    # save array pointer , no need to save the a0 since its alr done with slli ig ?
    mv s2, a0  # this is same as doing int *arr = some sequence and that fetches you the first element of the sequence HERE A0 is the array 

    # initialixing the iterator i to 1
    li s3, 1


loop_input:
    bge s3, s0, done_loop_input

    #i iterate after storing
    slli t0, s3, 3  # incr the iterator by 8!  coz str char is 8 bytes or pointer is 8 bytes?
    add a0, s1, t0  # this is address of argv[i], s1=argv  , we are reusing a0 
    ld a0, 0(a0) # string val

    # convert into int w atoi
    call atoi

    addi t0, s3, -1
    slli t0, t0, 2  # shift the array pointer by 4 caus eits int
  
    add t0, s2, t0  # this is array + offset
    sw a0, 0(t0)  

    # iterating i
    addi s3, s3, 1  # i++
    j loop_input


done_loop_input:
    # alloc result array
    addi a0, s0, -1
    slli a0, a0, 2
    call malloc
    mv s4, a0

    # alloc stack artay
    addi a0, s0, -1
    slli a0, a0, 2
    call malloc
    mv s5, a0
     
    li s6, -1    # dis is stack top STACK HERE IS _ BTW?
    addi s3, s0, -2 # iterator i=n-1 (right to left)

next_grt_loop:
    blt s3, zero, grt_loop_done
    j while_loop



# while (stack not empty && arr[stack[top]] <= arr[i]) 
while_loop:
    blt s6, zero, while_loop_done #stop when stack is empty

    # t1=arr[i]
    slli t0, s3, 2  # iterator i*4
    add t0, s2, t0   # arr[i]
    lw t1, 0(t0)     # this is t1=t0

    # load stack[top] into t2
    slli t0, s6, 2  # but what exactly did i define s6 as :/
    add t0, s5, t0  # stack arr + top*4
    lw t2, 0(t0)    # store into stack[top]

    #loading arr[while iterator ]
    slli t0, t2, 2  # while iterator mul by 4
    add t0, s2, t0  # address -? input arr + t0
    lw t2, 0(t0)    # store t0 into t2  # arr[stack[top]]

    #  while loop  condtn checking and action
    bgt t2, t1, while_loop_done
    addi s6, s6, -1
    j while_loop

while_loop_done:
 blt s6, zero, decrement 
 slli t0, s6, 2
 add t0, s5, t0
 lw t1, 0(t0)
 j store_res

pop:
    addi s6, s6, -1


    # give the len(arr) here arr is the og input arr ie, our a0 array
    # need for loop, front, pop, empty and push functs


grt_loop_done:
    li s3, 0
    j print_in_loop


# need to store result
store_res:
    slli t0, s3, 2
    add t0, s4, t0
    sw t1, 0(t0)

    # puttin i on stack
    addi s6, s6, 1   # incr iterator of for loop nio!
    slli t0, s6, 2
    add t0, s5, t0
    sw s3, 0(t0)

    # dec i
    addi s3, s3, -1
    j next_grt_loop

decrement:
    li t1, -1  # t1=-1
    j store_res

#printing the result
print_in_loop:
    addi t0, s0, -1     # n
    bge s3, t0, printing_loop_done          # s3 is 0, ie the iterator i
    slli t0, s3, 2 # iterating for next
    add t0, s4, t0                          # calc address ? , s4 is result array
    lw a1, 0(t0)                            # the val from result array

    

    # how to print, need to go back to ra to print 
    la a0, fmt
    call printf   # calling the printf like fmt

    addi s3, s3, 1
    j print_in_loop
    
    


# ending, need to load back
printing_loop_done:
    ld s6, 0(sp)
    ld s5, 8(sp)
    ld s4, 16(sp)
    ld s3, 24(sp)
    ld s2, 32(sp)
    ld s1, 40(sp)
    ld s0, 48(sp)
    ld ra, 56(sp)
    addi sp, sp, 64
    li a0, 0            # return 0 in the main funct
    ret
    
.section .rodata
fmt: .asciz "%d "
# print newline at end
newline: .asciz "\n"7