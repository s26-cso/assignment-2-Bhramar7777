.text
.globl make_node
.globl insert
.globl get
.globl getAtMost
.extern malloc

make_node:
    addi sp, sp, -16
    sd ra, 0(sp)
    sd a0, 8(sp)           

    li a0, 24                   # size of struct 
    call malloc

    ld t0, 8(sp)
    sw t0, 0(a0)                # node->val = value
    sd x0, 8(a0)                # node->left = NULL
    sd x0, 16(a0)               # node->right = NULL

    ld ra, 0(sp)
    addi sp, sp, 16
    ret


insert:
    addi sp, sp, -32
    sd ra, 0(sp)
    sd a0, 8(sp)
    sd a1, 16(sp)

    bne a0, x0, exiti
    ld a0, 16(sp)
    call make_node
    jal x0, exit1i

    exiti:
        lw t0, 0(a0)                    # t0 = root->val
        blt a1, t0, elsei
        beq a1, t0, exit1i
        ld t1, 16(a0)
        addi a0, t1, 0
        ld a1, 16(sp)
        call insert
        ld t2, 8(sp)
        addi t3, t2, 16
        sd a0, 0(t3)
        addi a0, t2, 0
        jal x0, exit1i

    elsei:
        lw t0, 0(a0)
        ld t1, 8(a0)                     # load root->left
        addi a0, t1, 0
        ld a1, 16(sp)
        call insert
        ld t2, 8(sp)
        addi t3, t2, 8
        sd a0, 0(t3)
        addi a0, t2, 0

    exit1i:
        ld ra, 0(sp)
        addi sp, sp, 32
        ret


get:
    addi sp, sp, -32
    sd ra, 0(sp)
    sd a0, 8(sp)
    sd a1, 16(sp)

    bne a0, x0, exitg
    addi a0, x0, 0
    jal x0, exit1g

    exitg:
        lw t0, 0(a0)
        bne t0, a1, exit2
        addi a0, a0, 0
        jal x0, exit1g

    exit2:
        lw t0, 0(a0)
        bge a1, t0, elseg
        ld t1, 8(a0)
        addi a0, t1, 0
        ld a1, 16(sp)
        call get
        jal x0, exit1g

    elseg:
        ld t1, 16(a0)
        addi a0, t1, 0
        ld a1, 16(sp)
        call get
        jal x0, exit1g

    exit1g:
        ld ra, 0(sp)
        addi sp, sp, 32
        ret


getAtMost:
    addi sp, sp, -32
    sd ra, 0(sp)
    sd a0, 8(sp)
    sd a1, 16(sp)
    
    li t1, -1                       # ans = -1

    loop:
        beq a1, x0, exitge
        lw t2, 0(a1)
        blt a0, t2, elsege
        addi t1, t2, 0
        ld t2, 16(a1)
        addi a1, t2, 0
        jal x0, loop

    elsege:
        ld t2, 8(a1)
        addi a1, t2, 0
        jal x0, loop

    exitge:
        addi a0, t1, 0
        ld ra, 0(sp)
        addi sp, sp, 32
        ret



# #include <stdio.h>
# #include <stdlib.h>

# struct Node {
#     int val;
#     struct Node* left;
#     struct Node* right;
# };


# // 1. make_node
# struct Node* make_node(int val) {
#     struct Node* node = (struct Node*)malloc(sizeof(struct Node));
#     node->val = val;
#     node->left = NULL;
#     node->right = NULL;     
#     return node;
# }


# // 2. insert
# struct Node* insert(struct Node* root, int val) {
#     If (root == NULL) {
#         return make_node(val);
#     }

#     If (val < root->val) {
#         root->left = insert(root->left, val);
#     } else if (val > root->val) {
#         root->right = insert(root->right, val);
#     }

#     return root;
# }


# // 3. get (search)
# struct Node* get(struct Node* root, int val) {
#     If (root == NULL) return NULL;

#     If (root->val == val) return root;

#     If (val < root->val){
#         return get(root->left, val);
    }
#     eelse
#         return get(root->right, val);
# }


# // 4. getAtMost
# int getAtMost(int val, struct Node* root) {
#     int ans = -1;

#     while (root != NULL) {
#         If (root->val <= val) {
#             ans = root->val;        // possible answer
#             root = root->right;     // try for bigger
#         } else {
#             root = root->left;
#         }
#     }

#     return ans;
# }