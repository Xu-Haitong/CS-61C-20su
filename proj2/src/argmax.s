.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)


    li t0, 1               # t0 = 1
    blt a1, t0, exit_7     # if(a1 < 1)

loop_start:
    li s0, -1              # s0 = -1 (max_index)
    li s1, -1              # s1 = -1 (max_value)
    li t0, 0               # t0 = 0 

loop_continue:
    bge t0, a1, loop_end       # if(t0 >= a1)
    slli t1, t0, 2             # offset
    add t1, a0, t1             # t1 = &vector[t0]
    lw t1, 0(t1)               # t1 = vector[t0]
    bge s1, t1, loop_goback    # if(max_value >= vector[t0])
    mv s0, t0                  # max_index = t0
    mv s1, t1                  # max_value = vector[i]

loop_goback:
    addi t0, t0, 1         # t0++
    jal x0, loop_continue

loop_end:
    mv a0, s0              # result = max_index
    # Epilogue
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 8
    ret

exit_7:
    li a0, 17
    li a1, 7
    ecall