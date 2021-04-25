.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Linux :   java -jar ../tools/venus.jar assembly/test_read_matrix.s
    # Windows : java -jar ..\tools\venus.jar assembly\test_read_matrix.s

    # Read matrix into memory
    # allocate memory for rows and cols
    la s0 file_path
    li a0 4
    jal ra, malloc
    mv s1, a0             # s1 = &rows
    li a0 4
    jal ra, malloc
    mv s2, a0             # s2 = &cols
    
    # call read_matrix
    mv a0, s0
    mv a1, s1
    mv a2, s2
    jal ra, read_matrix
    mv s0, a0              # s0 is the pointer to the matrix

    # Print out elements of matrix
    lw s1, 0(s1)
    lw s2, 0(s2)
    mv a0, s0
    mv a1, s1
    mv a2, s2
    jal ra, print_int_array

    # Terminate the program
    jal ra, exit