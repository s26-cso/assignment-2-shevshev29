.globl main # fior the linker (OS) to find main
.section .text



main:
    addi sp, sp, -64 
    sd ra, 56(sp)
    sd s0, 48(sp)     # argc
    sd s1, 40(sp)    # argv
    sd s2, 32(sp)    # array pointer
    sd s3, 24(sp)   # iterator i for loop
    sd s4, 16(sp)   # result array
    sd s5, 8(sp)    # stack array
    sd s6, 0(sp)    # index of top of stack


    # after space alloc, we must save the vals of a0=argc and a1=argv into save regs since we will call maloc and atoi
    mv s0, a0
    mv s1, a1 

    
    addi a0, s0, -1   #no of elems=argc-1 since input argc includes ./a.out while reading 
    slli a0, a0, 2    # *mul by 4 (2^2) to  calc the final n to iterate the loop to since an int is 4 bytes 
    call malloc  

    # save array pointer, points to array
    mv s2, a0    # this is same as doing int *arr = some sequence and that fetches you the first element of the sequence HERE A0 is the array 

    # initialixing the iterator i to 1 
    li s3, 1     # ie, argv[1]


loop_input:
    bge s3, s0, done_loop_input

    #get argv[i]
    slli t0, s3, 3  # incr the iterator by 8!  coz each argv element is a pointer
    add a0, s1, t0  # this is address of argv[i], s1=argv
    ld a0, 0(a0)    #load  string (char*)

    # convert into int w atoi
    call atoi

    addi t0, s3, -1
    slli t0, t0, 2  # (i-1)*4 .shift the array pointer by 4 cause array has ints
  
    add t0, s2, t0  # this is array + offset
    sw a0, 0(t0)  

    # increment i
    addi s3, s3, 1  # i++
    j loop_input


done_loop_input:
    # alloc result array
    addi a0, s0, -1
    slli a0, a0, 2
    call malloc
    mv s4, a0  # result array

    # alloc stack array (to store indices)
    addi a0, s0, -1
    slli a0, a0, 2
    call malloc
    mv s5, a0  # s5 is stack
     
    li s6, -1    # this is stack top index , currently initialized to show stack empty (-1)
    addi s3, s0, -2 # iterator i=n-1 (right to left)

next_grt_loop:
    blt s3, zero, grt_loop_done
    j while_loop



# while (stack not empty && arr[stack[top]] <= arr[i]) 
while_loop:
    blt s6, zero, while_loop_done #stopif stack is empty

    # t1=arr[i]
    slli t0, s3, 2  # iterator i*4
    add t0, s2, t0   # arr[i]
    lw t1, 0(t0)     # this is t1=t0

    # load stack[top] into t2
    slli t0, s6, 2 
    add t0, s5, t0  # stack arr + top*4
    lw t2, 0(t0)    # store into t2=stack[top]

    #loading arr[while iterator ]
    slli t0, t2, 2  # while iterator mul by 4
    add t0, s2, t0  # address -> input arr + t0
    lw t2, 0(t0)    # store t0 into t2=arr[stack[top]]

    #  while loop  condtn checking and action
    bgt t2, t1, while_loop_done
    #while loop else condtn
    addi s6, s6, -1
    j while_loop

while_loop_done:
 blt s6, zero, decrement  #when stack empty, cannot find greater element
 slli t0, s6, 2           # else ans=stack[top]
 add t0, s5, t0
 lw t1, 0(t0)             # t1=index of next greater elem
 j store_res



grt_loop_done:
    li s3, 0
    j print_in_loop


# need to store result
#result[i] = index of next greater element
store_res:
    # find address of result[i]
    slli t0, s3, 2   # i*4 (int size)
    add t0, s4, t0   # res +offset
    sw t1, 0(t0) # store result[i]

    # puttin i(current index) on stack
    addi s6, s6, 1   #increment stack topfor push
    slli t0, s6, 2   # top*4 (stack iterator)
    add t0, s5, t0   # stack+offset
    sw s3, 0(t0)     # store stack top index=iterator (i)

    # moving to nnext element on left
    addi s3, s3, -1
    j next_grt_loop

decrement:
    li t1, -1  # t1=-1, ie, stack is empty= no greater element exists
    j store_res

#printing the result
print_in_loop:
    addi t0, s0, -1   # n (argc-1)
    bge s3, t0, printing_loop_done      # stop printing when i>=n     
    slli t0, s3, 2    # i*4
    add t0, s4, t0    # t0=result+offset
    lw a1, 0(t0)      # load result][i] from result array


    # printf("%d ", result[i]) 
    la a0, fmt    # a0 is format string
    call printf   # calling the printf like fmt

    #incrementing to next index in loop
    addi s3, s3, 1
    j print_in_loop

    
    


# ending, need to load back
printing_loop_done:
    # print newline at end
    la a0, newline
    call printf

    ld s6, 0(sp)
    ld s5, 8(sp)
    ld s4, 16(sp)
    ld s3, 24(sp)
    ld s2, 32(sp)
    ld s1, 40(sp)
    ld s0, 48(sp)
    ld ra, 56(sp)
    addi sp, sp, 64
    li a0, 0           
    ret
    


.section .rodata
fmt: .asciz "%d "
newline: .asciz "\n"