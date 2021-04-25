.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)       # file_path
    sw s1, 8(sp)       # p_matrix
    sw s2, 12(sp)      # rows
    sw s3, 16(sp)      # cols
    sw s4, 20(sp)      # 1
    sw s5, 24(sp)      # 4
    sw s6, 28(sp)      # fd

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    li s4, 1
    li s5, 4

    # fopen file
    mv a1, s0
    li a2, 1
    jal ra, fopen
    li t0, -1
    beq a0, t0, exit_53
    mv s6, a0           # s6 is file descripter

    # fwrite rows and cols
    addi sp, sp, -4
    sw s2, 0(sp)
    mv a1, s6
    mv a2, sp
    mv a3, s4
    mv a4, s5
    jal ra, fwrite
    bne a0, s4, exit_54
    lw s2, 0(sp)
    addi sp, sp, 4
    addi sp, sp, -4
    sw s3, 0(sp)
    mv a1, s6
    mv a2, sp
    mv a3, s4
    mv a4, s5
    jal ra, fwrite
    bne a0, s4, exit_54
    lw s3, 0(sp)
    addi sp, sp, 4

    # fwrite matrix
    mul t0, s2, s3
    mv a1, s6
    mv a2, s1
    mv a3, t0
    mv a4, s5
    jal ra, fwrite
    mul t0, s2, s3
    bne a0, t0, exit_54

    # fclose
    mv a1, s6
    jal ra, fclose
    bne a0, x0, exit_55

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)       # file_path
    lw s1, 8(sp)       # p_matrix
    lw s2, 12(sp)      # rows
    lw s3, 16(sp)      # cols
    lw s4, 20(sp)      # 1
    lw s5, 24(sp)      # 4
    lw s6, 28(sp)      # fd
    addi sp, sp, 32
    ret


exit_53:
    li a1 53
    jal ra, exit2

exit_54:
    li a1 54
    jal ra, exit2

exit_55:
    li a1 55
    jal ra, exit2