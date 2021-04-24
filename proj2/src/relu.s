.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue 
    # use only t registers, no need for Prologue

    li t0, 1
    blt a1, t0, exit_8     # if(a1 < 1)

loop_start:
    li t0, 0               # i = 0

loop_continue:
    bge t0, a1, loop_end
    slli t1, t0, 2         # offset
    add t1, a0, t1         # t1 = &arr[i]
    lw t2, 0(t1)           # t2 = arr[i]
    blt t2, x0, change_arr # if(arr[i] < 0)
    addi t0, t0, 1         # t0++
    jal x0, loop_continue

loop_end:
    # Epilogue
	ret

change_arr:
    sw x0, 0(t1)           # arr[i] = 0
    jal x0, loop_continue

exit_8:
    addi a0, x0, 17
    addi a1, x0, 8
    ecall