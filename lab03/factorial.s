.globl factorial

.data
n: .word 8

.text
main:
    la t0, n                # t0 保存 n 的地址
    lw a0, 0(t0)            # a0 = n = 8
    jal ra, factorial       # 调用 factional 函数

    addi a1, a0, 0          # a1 是 factional 函数的返回值
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
    beq s1, x0, end          # 判断 n != 0
    mul s0, s0, s1           # res *= n
    addi s1, s1, -1          # n--
    jal x0, loop
end:    
    add a0 s0 x0
    jr ra