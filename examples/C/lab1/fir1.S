# fir.S
# assembly language of Finite Impulse Response (FIR)

// a0: base address of x
// a1: base address of c
// a2: base address of y, later used as pointer to y[j] in j loop
// a3: n
// a4: m

// t0: &y[n-m+1] to check termination of j loop
// t1: &c[m] to check termination of i loop
// t2: &x[j+m-1]
// t3: sum
// t4: pointer to c[i] in i loop
// t5: pointer to x[j-i+(m-1)]
// t6: value of c[i]
// a5: value of x[j-1+(m-1)]

.global fir

fir:
    addi sp, sp, -64     # allocate stack space for saved registers
    sd   s2, 0(sp)       # save s2
    sd   s3, 8(sp)       # save s3
    sd   s4, 16(sp)      # save s4
    sd   s5, 24(sp)      # save s5
    sd   s6, 32(sp)      # save s6
    sd   s7, 40(sp)      # save s7
    sd   s8, 48(sp)      # save s8
    sd   ra, 56(sp)      # save return address

    addi s2, a0, 0       # s2 = base address of x
    addi s3, a1, 0       # s3 = base address of c
    addi s4, a2, 0       # s4 = base address of y
    addi s5, a3, 0       # s5 = n
    addi s6, a4, 0       # s6 = m

    li s7, 0        # int i
    li s8, 0        # int j

    # outer loop termination (n-m+1)
    sub t0, s5, s6
    addi t0, t0, 1

    forj: bge s8, t0, donej
        li t3, 0    # sum = 0
        fori: bge s7, s6, donei
            # This is c[i]
            slli t4, s7, 2     # shift address by 2
            add t4, s3, t4     # t4 now holds the address of c[i]
            lw t6, 0(t4)       # load the value of c[i] into t6

            # This is x[j-i+(m-1)]
            sub t5, s8, s7     # calculate j-i
            addi t1, s6, -1    # calculate m-1
            add t5, t5, t1     # add m to get index in x array
            slli t5, t5, 2     # shift address by 2
            add t5, s2, t5     # t5 now holds the address of x[j-i+(m-1)]
            lw a5, 0(t5)       # load the value of x[j-i+(m-1)] into a5

            # multiply c[i] and x[j-i+(m-1)]
            mul t6, t6, a5

            # shift right by 31 (Q1.31 format)
            srai t6, t6, 31

            # add to sum
            add t3, t3, t6
            addi s7, s7, 1     # i++
            j    fori

        donei:
            slli t1, s8, 2     # shift address by 2
            add t2, s4, t1     # t2 now holds the address of y[j]
            sw t3, 0(t2)       # y[j] = sum
            li   s7, 0         # reset i = 0
            addi s8, s8, 1     # j++
            j    forj

    donej:
        ld s2, 0(sp)      # restore s2
        ld s3, 8(sp)      # restore s3
        ld s4, 16(sp)     # restore s4
        ld s5, 24(sp)     # restore s5
        ld s6, 32(sp)     # restore s6
        ld s7, 40(sp)     # restore s7
        ld s8, 48(sp)     # restore s8
        ld ra, 56(sp)     # restore return address
        addi sp, sp, 64   # deallocate stack space
        ret           # all done; return
