.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:
    #
    # see read_matrix.c C code with comparison
    #

    # Prologue
	addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)     # &file_path
    sw s1, 8(sp)     # &rows
    sw s2, 12(sp)    # &cols
    sw s3, 16(sp)    # fd
    sw s4, 20(sp)    # s4 = 4
    sw s5, 24(sp)    # size = 4 * rows * cols
    sw s6, 28(sp)    # p_matrix       
    
    mv s0 a0
    mv s1 a1
    mv s2 a2

    # open file
    mv a1 s0
    li a2 0
    jal ra, fopen
    li t0, -1
    beq a0, t0, exit_50
    mv s3 a0                # s3 is file descripter

    # read the number of rows and columns
    li s4 4
    mv a1 s3
    mv a2 s1
    mv a3 s4
    jal ra, fread
    bne a0, s4, exit_51
    mv a1 s3
    mv a2 s2
    mv a3 s4
    jal ra, fread
    bne a0, s4, exit_51

    # allocate memory for matrix
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t0, t0, t1
    slli s5, t0, 2  
    mv a0, s5
    jal ra, malloc
    mv s6, a0               # s6 is p_matrix

    # read matrix
    mv a1, s3
    mv a2, s6
    mv a3, s5
    jal ra, fread
    bne a0, s5, exit_51

    # fclose
    mv a1 s3
    jal ra, fclose
    bne a0, x0, exit_52

    # output result
    mv a0, s6

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32
    ret

exit_50:
    li a1, 50
    jal ra, exit2

exit_51:
    li a1, 51
    jal ra, exit2

exit_52:
    li a1, 52
    jal ra, exit2