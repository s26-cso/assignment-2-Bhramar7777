.data
fmt:    .asciz "%d "
nwlne:  .asciz "\n"
.text
.globl main
.extern atoi
.extern printf
.extern malloc
.extern free
main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)                   # s0 has n 
    sd s1, 40(sp)                   # s1 has top
    sd s2, 32(sp)                   # s2 has for loop i
    sd s3, 24(sp)                   # s3 has a[]
    sd s4, 16(sp)                   # s4 has stack[]
    sd s5, 8(sp)                    # s5 has ans[]
    sd s6, 0(sp)                    # s6 has argv

    addi s0, a0, -1                 # s0 = n-1
    addi s6, a1, 0                  # s6 has argv 
    li s1, -1                       # top = -1
    li s2, 0                        # i = 0

    slli a0, s0, 2                  # a[n]
    call malloc
    addi s3, a0, 0

    slli a0, s0, 2                  # stack[n]
    call malloc
    addi s4, a0, 0

    slli a0, s0, 2                  # ans[n]
    call malloc
    addi s5, a0, 0

loop1:
    bge s2, s0, exit1               
    slli t3, s2, 3
    addi t3, t3, 8
    add t3, s6, t3                  # atoi(argv[i + 1]);
    ld a0, 0(t3)
    call atoi
    addi t4, a0, 0

    slli t3, s2, 2
    add t3, s3, t3
    sw t4, 0(t3)                    # storing the value which is in t4 (i.e atoi(argv[i + 1]);) in address of a[i]

    slli t3, s2, 2
    add t3, s5, t3
    sw s1, 0(t3)                    # ans[i] = -1

    addi s2, s2, 1
    jal x0, loop1
exit1:
    li s2, 0
loop2:
    bge s2, s0, exit2
    loop3:
        blt s1, x0, exit3

        slli t3, s2, 2
        add t3, s3, t3
        lw t4, 0(t3)                # t4 = a[i]

        slli t3, s1, 2
        add t3, s4, t3
        lw t6, 0(t3)                # t6 = stack[top]
        slli t3, t6, 2
        add t3, s3, t3
        lw t6, 0(t3)                # t6 = arr[stack[top]]

        bge t6, t4, exit3
        slli t3, s1, 2
        add t3, s4, t3
        lw t4, 0(t3)
        slli t4, t4, 2
        add t6, s5, t4
        sw s2, 0(t6)                # result[stack[top]] = i
        addi s1, s1, -1             # top--
        jal x0, loop3
    exit3:
        addi s1, s1, 1              # top++
        slli t3, s1, 2
        add t3, t3, s4
        sw s2, 0(t3)                # stack[top] = i

        addi s2, s2, 1
        jal x0, loop2
exit2:
    li s2, 0
loop4:
    bge s2, s0, exit4
    slli t3, s2, 2
    add t3, s5, t3
    lw t4, 0(t3)                    # t4 = ans[i]
    addi a1, t4, 0
    la a0, fmt
    call printf
    addi s2, s2, 1
    jal x0, loop4
exit4:
    la a0, nwlne
    call printf

    addi a0, s3, 0
    call free                       # free(a)
    addi a0, s4, 0
    call free                       # free(stack)
    addi a0, s5, 0
    call free                       # free(ans)                                  

    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)
    ld s5, 8(sp)
    ld s6, 0(sp)
    addi sp, sp, 64
    ret




# #include <stdio.h>
# #include <stdlib.h>
# int main(int argc, char *argv[]) {
#     int n = argc - 1;

#     int *arr   = malloc(n * sizeof(int));
#     int *ans   = malloc(n * sizeof(int));
#     int *stack = malloc(n * sizeof(int));

#     int top = -1;

#     for (int i = 0; i < n; i++) {
#         arr[i] = atoi(argv[i + 1]);
#         ans[i] = -1;
#     }

#     for (int i = 0; i < n; i++) {
#         while (top >= 0 && arr[i] > arr[stack[top]]) {
#             ans[stack[top]] = i;
#             top--;
#         }
#         stack[++top] = i;
#     }

#     for (int i = 0; i < n; i++) {
#         printf("%d ", ans[i]);
#     }
#     printf("\n");

#     free(arr);
#     free(ans);
#     free(stack);

#     return 0;
# }


