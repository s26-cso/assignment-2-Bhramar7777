.data
inptfile :  .asciz "input.txt"
mode :      .asciz "r"
Yes :       .asciz "Yes\n"
No :        .asciz "No\n"
.text
.globl main
main:
    addi sp, sp, -32

    la a0, inptfile
    la a1, mode                         #FILE *fp = fopen("input.txt", "r");
    call fopen
    sw a0, 0(sp)                       #storing fp so that we can use it further


    bne x0, a0, else
    li a0, 1
    jal x0, exiit

    else:
        lw a0, 0(sp)                    # getting fp        fseek(fp, 0, SEEK_END);
        li a1, 0                        #a1=0
        li a2, 2                        #seek_end=2
        call fseek

        lw a0, 0(sp)                    #loading fp
        call ftell
        sw a0, 4(sp)                    # n = ftell(fp);



        lw t0, 4(sp)                    # t0 has n
        blt x0, t0, go
        la a0, Yes                      #printing Yes\n
        call printf
        lw a0, 0(sp)                    # loading fp
        call fclose
        jal x0, exiit

    go:
        li t1, 0                        # t1 has left = 0
        sw t1, 8(sp)
        lw t2, 4(sp)                    # t2 has n
        addi t2, t2, -1                 # now t2 is right = n-1
        sw t2, 12(sp)

        loop:
            lw t1, 8(sp)
            lw t2, 12(sp)
            bge t1, t2, exit

            lw a0, 0(sp)
            addi a1, t1, 0              # fseek(fp, left, SEEK_SET);
            li a2, 0
            call fseek

            lw a0, 0(sp)
            call fgetc                  # c1 = fgetc(fp);
            addi t3, a0, 0              # t3 has c1      

            lw a0, 0(sp)
            addi a1, t2, 0              # fseek(fp, right, SEEK_SET);
            li a2, 0
            call fseek

            lw a0, 0(sp)
            call fgetc                  # c2 = fgetc(fp);
            addi t4, a0, 0              # t4 has c2

            li t5, 10                   # '\n' asci 10
            bne t4, t5, else1
            addi t2, t2, -1             # right--;
            sw t2, 12(sp)               
            jal x0, loop

        else1:
            beq t3, t4, else2
            la a0, No
            call printf
            lw a0, 0(sp)
            call fclose
            jal x0, exiit

        else2:
            lw t1, 8(sp)
            lw t2, 12(sp)
            addi t1, t1, 1
            addi t2, t2, -1
            sw t1, 8(sp)
            sw t2, 12(sp)
            jal x0, loop

        exit:
            la a0, Yes
            call printf
            lw a0, 0(sp)
            call fclose

        exiit:
        addi sp, sp, 32
        ret



# #include <stdio.h>

# int main() {
#     FILE *fp = fopen("input.txt", "r");
#     If (fp == NULL) {
#         return 1;
#     }

#     // Move to end to get length
#     fseek(fp, 0, SEEK_END);
#     long n = ftell(fp);

#     If (n <= 0) {
#         printf("Yes\n"); // empty string is palindrome
#         fclose(fp);
#         return 0;
#     }

#     long left = 0;
#     long right = n - 1;

#     while (left < right) {
#         char c1, c2;

#         fseek(fp, left, SEEK_SET);
#         c1 = fgetc(fp);

#         fseek(fp, right, SEEK_SET);
#         c2 = fgetc(fp);

#         // Ignore newline at end (optional safety)
#         If (c2 == '\n') {
#             right--;
#             continue;
#         }

#         If (c1 != c2) {
#             printf("No\n");
#             fclose(fp);
#             return 0;
#         }

#         left++;
#         right--;
#     }

#     printf("Yes\n");
#     fclose(fp);
#     return 0;
# }


