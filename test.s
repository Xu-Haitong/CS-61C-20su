.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH> 
    
    # Windows : java -jar tools\venus.jar src\main.s -ms -1 tests\inputs\mnist\bin\m0.bin tests\inputs\mnist\bin\m1.bin tests\inputs\mnist\bin\inputs\mnist_input3.bin tests\outputs\test_mnist_main\student_mnist_outputs.bin

    # Linux : java -jar tools/venus.jar src/main.s -ms -1 tests/inputs/mnist/bin/m0.bin tests/inputs/mnist/bin/m1.bin tests/inputs/mnist/bin/inputs/mnist_input0.bin  tests/outputs/test_mnist_main/student_mnist_outputs.bin

    # verify the number of command line arguments
    li t0, 5
    bne a0, t0, exit_49

    # Prologue
    addi sp, sp, -64
    sw s0, 0(sp)
	sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)  
    sw ra, 36(sp)

    # save arguments
    mv s0, a0
    mv s1, a1
    mv s2, a2

	# =====================================
    # LOAD MATRICES
    # =====================================

    # load m0
    lw a0, 4(s1)
    addi a1, sp, 40
    addi a2, sp, 44
    jal ra, read_matrix
    mv s3, a0            # s3 is the pointer to m0
  
    # load m1
    lw a0, 8(s1)
    addi a1, sp, 48
    addi a2, sp, 52
    jal ra, read_matrix
    mv s4, a0            # s4 is the pointer to m1

    # load input matrix
    lw a0, 12(s1)
    addi a1, sp, 56
    addi a2, sp, 60
    jal ra, read_matrix
    mv s5, a0            # s5 is the pointer to input matrix

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # malloc for hidden_layer
    lw t0, 40(sp)
    lw t1, 60(sp) 
    mul t0, t0, t1
    slli t0, t0, 2
    mv a0, t0
    jal ra, malloc
    blt a0, x0, exit_48
    mv s6, a0            # s6 is the pointer to hidden_layer

    # m0 * input
    mv a0, s3
    lw a1, 40(sp)
    lw a2, 44(sp)
    mv a3, s5
    lw a4, 56(sp)
    lw a5, 60(sp)
    mv a6, s6
    jal ra, matmul

    # relu()
    lw t0, 40(sp)
    lw t1, 60(sp)
    mul t0, t0, t1
    mv a0, s6
    mv a1, t0
    jal ra, relu

    # malloc for scores
    lw t0, 48(sp)
    lw t1, 60(sp)
    mul t0, t0, t1
    slli t0, t0, 2
    mv a0, t0
    jal ra, malloc
    blt a0, x0, exit_48
    mv s7, a0             # s7 is the pointer to scores

    # m1 * hidden_layer
    mv a0, s4
    lw a1, 48(sp)
    lw a2, 52(sp)
    mv a3, s6
    lw a4, 40(sp)
    lw a5, 60(sp)
    mv a6, s7
    jal ra, matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1, s7
    lw a2, 48(sp)
    lw a3, 60(sp)
    jal ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw t0, 48(sp)
    lw t1, 60(sp)
    mv a0, s7
    mul a1, t0, t1
    jal ra, argmax
    mv s8, a0          # s8 is the result

    # Print classification
    bne s2, x0, end
    mv a1, s8
    jal ra, print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    jal ra, print_char
    
end:
    # output
    mv a0, s8

    #Epilogue  
    lw s0, 0(sp)
	lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)  
    lw ra, 36(sp)
    addi sp, sp, 64

    ret

exit_49:
    li a1, 49
    jal ra, exit2 

exit_48:
    li a1, 48
    j exit2