.data
source:
    .word   3
    .word   1
    .word   4
    .word   1
    .word   5
    .word   9
    .word   0
dest:
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0

.text
main:
    addi t0, x0, 0   # 初始化 k 为 0
    addi s0, x0, 0   # 初始化 sum 为 0
    la s1, source    # s1 指向 source
    la s2, dest      # s2 指向 dest
loop:
    slli s3, t0, 2   # s3 为 offset
    add t1, s1, s3   # t1 为 source[k] 的地址
    lw t2, 0(t1)     # t2 = source[k]
    beq t2, x0, exit # 将 t2 与 0 进行比较
    add a0, x0, t2   # 传入参数为 t2
    addi sp, sp, -8  # 压栈 2 个参数
    sw t0, 0(sp)     # 压栈第一个参数为局部变量 t0
    sw t2, 4(sp)     # 压栈第二个参数为局部变量 t2
    jal square       # 调用 square 函数
    lw t0, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8   # 恢复现场
    add t2, x0, a0   # t2 为 fun(source[k]) 的返回值
    add t3, s2, s3   # t3 为 source[k] 的地址
    sw t2, 0(t3)     # dest[k] = t2
    add s0, s0, t2   # sum += t2
    addi t0, t0, 1   # k++
    jal x0, loop
square:
    add t0, a0, x0   # t0 为传入的参数 x
    add t1, a0, x0   # t1 也是传入的参数 x
    addi t0, t0, 1   # t0 = x + 1
    addi t2, x0, -1  # t2 = -1
    mul t1, t1, t2   # t1 = -x
    mul a0, t0, t1   # a0 = (-x) * (x + 1)
    jr ra            # PC 返回到 ra 的地址
exit:
    add a0, x0, s0   # a0 = sum
    add a1, x0, x0   # a1 = 0
    ecall # Terminate ecall