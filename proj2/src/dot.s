.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    li t0, 1
    blt a2, t0, exit_5
    blt a3, t0, exit_6
    blt a4, t0, exit_6

    # Prologue
    addi sp, sp, -4
    sw s0, 0(sp)

loop_start:
    li s0, 0              # res = 0
    li t0, 0              # t0 = 0

loop_continue:
    bge t0, a2, loop_end  # if(t0 >= a2)
    slli t1, t0, 2        
    mul t2, t1, a3        # offset of v0
    mul t3, t1, a4        # offset of v1
    add t2, a0, t2        # t2 = &v0[t0]
    add t3, a1, t3        # t3 = &v1[t0]
    lw t2, 0(t2)          # t2 = v0[t0]
    lw t3, 0(t3)          # t3 = v1[t0]
    mul t1, t2, t3        # t1 = v0[t0] * vt[t0]
    add s0, s0, t1        # res += t1
    addi t0, t0, 1        # t0++
    jal x0, loop_continue

loop_end:
    mv a0, s0             # result = res
    # Epilogue
    lw s0, 0(sp)
    addi sp, sp, 4
    ret

exit_5:
    li a0, 17
    li a1, 5
    ecall 

exit_6:
    li a0, 17
    li a1, 6
    ecall