.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp, sp, -32    # we save ra and s0, each 8 bytes =16 bytes
    sd ra, 24(sp)
    sd s0, 16(sp)

    mv s0, a0           # saving input val (a0) before calling malloc
    li a0, 24           # sizeof(struct node) is val(4) + left ptr(8) +right ptr(8) + padding (4)
    call malloc         # ALLOCATE MEM (part of creating a new node is having ptr(a0) pointing to new node)

    sw s0, 0(a0)        # node->val=val
    sd zero, 8(a0)      #node->left=NULL
    sd zero, 16(a0)     # node->right=NULL

    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret                 # returning pointer in a0


# null checking is checking if zero 
#inserts val into BST and resturns the updated given root
insert:
    beq a0, zero, base_case  # base case condtn                    | if root==null, create node
    lw t0, 0(a0)             # loading the t0=root->val from a0, offset is 0   
    blt a1, t0, go_left      # left subtree recursive funct branching   | if root->val<val   
    bgt a1, t0, go_right     # right subtree recursive funct branching | if root->right>val 
    ret                                                          #  | val = root->val 



# inserting in left subtree
go_left:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    mv s0, a0   #saving root
    mv s1, a1   # saving the val

    ld a0, 8(s0)    #a0=root->left
    mv a1, s1       # saving the return address=root->left bfr calling insert
    call insert     #recursing

    sd a0, 8(s0)    #sd root->left to return 
    mv a0, s0       # returning og root a0

    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret


# inserting in right subtree
go_right:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    mv s0, a0
    mv s1, a1

    ld a0, 16(s0)
    mv a1, s1
    call insert

    sd a0, 16(s0)
    mv a0, s0

    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

#creates new node when the root==null
base_case:
    addi sp, sp, -32
    sd ra, 24(sp)

    mv a0, a1   # pass val
    call make_node

    ld ra, 24(sp)
    addi sp, sp, 32
    ret


#search bst funct, arguments: struct node *root, int val
get:
    #case 1 root==null ie, not found
    beq a0, zero, ret_null

    # case 2 root->val=val  ie, found
    lw t0, 0(a0) # loading the root->val into t0
    beq a1, t0, found

    #when if root->val<val , need to go right
    blt t0, a1, get_r   #going right
    j get_l           # or else, go left  


ret_null:
    mv a0, zero      # rets NULL
    ret

found:
    ret   # rets the current node


#specific tree searches
#left
get_l:
    addi sp, sp, -16
    sd ra, 8(sp)

    ld a0, 8(a0)  # get left child to call get(leftchild, val)
    call get

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

#right
get_r:
    addi sp, sp, -16
    sd ra, 8(sp)

    ld a0, 16(a0)
    call get

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

# getAtMost arguments: struct node *root, int val
#returns the biggest val in  after "val" in bst
getAtMost:
    li t2, -1  #setting the default val=-1
    mv t1, a1  # t1= current node
    mv t0, a0  # t0= val

loop:
    beq t1, zero, done  #when if at null, end
    lw t3, 0(t1)        #current node's val
    beq t3, t0, exact   #if the node->val==val, return val itslef
    blt t3, t0, go_atmost_right #if node->val<val its a possible node
    ld t1, 8(t1)        # else condt: go left
    j loop 


go_atmost_right:
    mv t2, t3           # update possible node ans
    ld t1, 16(t1)       # move right to continue scanning for poss val since node->val was less than val
    j loop

exact:
    mv a0, t0 # save t0 back into a0
    ret

done:
    mv a0, t2  # return ans
    ret



