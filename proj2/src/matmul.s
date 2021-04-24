.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    li t0, 1             # t0 = 1
    blt a1, t0, exit_2
    blt a2, t0, exit_2
    blt a4, t0, exit_3
    blt a5, t0, exit_3 
    bne a2, a4, exit_4

    # Prologue
    # we will call dot(int *, int *, int, int, int), so ra will change during call
    addi sp, sp, -4
    sw ra, 0(sp)

    li t0, 0                        # t0 = 0         =>  i = 0
outer_loop_start:
    bge t0, a1, outer_loop_end      # if(t0 < a1)    

    li t1, 0                        # t1 = 0         =>  j = 0
inner_loop_start:
    bge t1, a5, inner_loop_end      # if(t1 < a5)    
    mul t2, t0, a5                  # t2 = i * k
    add t2, t1, t2                  # t2 = j + i * k
    slli t2, t2, 2                  # t2 is offset
    add t2, a6, t2                  # t2 = &d[i][j]

    addi, sp, sp, -40               # push t0, t1, t2, a0-a6
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw a0, 12(sp)
    sw a1, 16(sp)
    sw a2, 20(sp)
    sw a3, 24(sp)
    sw a4, 28(sp)
    sw a5, 32(sp)
    sw a6, 36(sp)
    mul t3, t0, a2                  # t3 = i * m
    slli t3, t3, 2                  # t3 is offset
    add t3, a0, t3                  # t3 = &m0[i][0]
    slli t4, t1, 2                  # t4 is offset
    add t4, a3, t4                  # t4 = &m1[0][j]
    mv t5, a2                       # t5 = m
    mv t6, a5                       # t6 = k
    mv a0, t3                       # set five parameters for dot(int *, int *, int, int, int)
    mv a1, t4
    mv a2, t5
    li a3, 1
    mv a4, t6
    jal ra, dot                     # call dot(int *, int *, int, int, int)

    mv t3, a0                       # t3 is result
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw a0, 12(sp)
    lw a1, 16(sp)
    lw a2, 20(sp)
    lw a3, 24(sp)
    lw a4, 28(sp)
    lw a5, 32(sp)
    lw a6, 36(sp)
    addi, sp, sp, 40                # pop t0, t1, t2, a0-a6
    sw t3, 0(t2)                    # *(d + j + i * k) = dot(m0 + i * c0, m1 + j, m, 1, c1);
    addi t1, t1, 1                  # t1++  =>  j++ 
    jal x0, inner_loop_start

inner_loop_end:
    addi t0, t0, 1                  # t0++  =>  i++ 
    jal x0, outer_loop_start        

outer_loop_end:
    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

exit_2:
    li a0, 17
    li a1, 2
    ecall

exit_3:
    li a0, 17
    li a1, 3
    ecall

exit_4:
    li a0, 17
    li a1, 4
    ecall