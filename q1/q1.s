.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp, sp, -16 # we save ra and s0, each 8 bytes =16 bytes
    sd ra, 8(sp)
    sd s0, 0(sp)

    mv s0, a0
    li a0, 24
    call malloc

    sw s0, 0(a0)
    sd zero, 8(a0)
    sd zero, 16(a0)

    ld s0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16
    ret   # return what

insert():
# null checking is checking if zero 
#call function
# jump to label

insert:
    beq a0, zero, base_case  # base case condtn                    | root==null
    lw t0, 0(a0)  # loading the root->val from a0, offset is 0     | root->val
    blt a1, t0, go_left  # left branch recursive funct branching   | root->left   is a1 = val ?
    bgt a1, t0, go_right  # right branch recursive funct branching | root->right 
    ret      # return what ?                                                        | val = root->val 


# imp,  is BRANCHING, DIFF FROM FUNCT CALLING?, YOULL HAVE TO SAVE THE RETURN ADDRESS
# need to store and call funct and save and return
go_left:
    addi sp, sp, -24
    sd ra, 16(sp)  # this supp to be  ra?  (FOR 4 BYTES, USE SW AND GREATER USE SD ra is a pointer=8bytes)
    sd s0, 8(sp)
    sd s1, 0(sp)
    mv s0, a0  #dis the root
    mv s1, a1 # dis the val

    # call insert
    ld a0, 8(s0)
    mv a1, s1
    call insert

    #store vals to return
    sd a0, 8(s0)    # returned node
    mv a0, s0       #ret val =og root

    ld s1, 0(sp)
    ld s0, 8(sp)
    ld ra, 16(sp)
    addi sp, sp, 24
    #return 
    ret 



go_right:
    addi sp, sp, -24
    sd ra, 16(sp)  # this supp to be  ra?  (FOR 4 BYTES, USE SW AND GREATER USE SD ra is a pointer=8bytes)
    sd s0, 8(sp)
    sd s1, 0(sp)
    mv s0, a0  #dis the root
    mv s1, a1 # dis the val

    # call insert
    ld a0, 16(s0) #right
    mv a1, s1
    call insert

    #store vals to return
    sd a0, 16(s0)    # returned node
    mv a0, s0       #ret val =og root

    ld s1, 0(sp)
    ld s0, 8(sp)
    ld ra, 16(sp)
    addi sp, sp, 24
    #return 
    ret 



base_case:
    # if root val ==nul, ie zero
    mv a0, a1
    call make_node
    ret

get: # two base cases 
    #case 1 root==null
    beq a0, zero, ret_null

    # case 2 root->val=val
    lw t0, 0(a0) # loading the root->val into t0
    beq a1, t0, found

    blt t0, a1, get_l
    bge, a1, t0, get_r


ret_null:
    mv a0, zero
    ret

found:
    ret

get_l:
    ld a0, 8(a0)
    call get
    ret

get_r:
    ld a0, 16(a0)
    call get
    ret

getAtMost:
    li t2, -1
    mv t1, a1
    mv t0, a0

loop:
    beq t1, zero, done
    lw t3, 0(t1)
    beq t3, t0, exact
    blt t3, t0, go_atmost_right
    ld t1, 8(t1)
    j loop #happens


go_atmost_right:
    mv t2, t3
    ld t1, 16(t1)
    j loop

exact:
    mv a0, t0
    ret

done:
    mv a0, t2
    ret



