.globl factorial

.data
n: .word 8

.text
main:
    la t0, n                # t0 = &n
    lw a0, 0(t0)            # a0 = n 
    jal ra, factorial       # call factional(int)

    addi a1, a0, 0          # a1 = factional(n)
    addi a0, x0, 1          # a0 = 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    addi s0, x0, 1           # res = 1
    add  s1, a0, x0          # n = n
loop:
    beq s1, x0, end          # if(n == 0)
    mul s0, s0, s1           # res *= n
    addi s1, s1, -1          # n--
    jal x0, loop
end:    
    add a0 s0 x0
    jr ra