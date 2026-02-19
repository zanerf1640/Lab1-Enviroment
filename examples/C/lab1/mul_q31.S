# This is the file for the multiplication function

.global mult_q31

# Multiplication functions
mult_q31:

    lw t0, 0(a0) # lower 32 for int a
    lw t1, 4(a0) # upper 32 for int a

    lw t2, 0(a1) # lower 32 for int b
    lw t3, 4(a1) # upper 32 for int b

    mul a2, t0, t2  # multiply lower parts

    mulh t4, t0, t2 # capture the carry over of the lower end
    mul t5, t0, t3  # low a * high b
    mul t6, t1, t2  # high a * low b

    add t4, t4, t5  # add t5 to t4
    add a3, t4, t6  # add t4 to t6

    slli t1, a3, 1  # shift left by 1 to get 32-bit result
    slri t2, a2, 31 # shift right by 1 to get 32-bit result
    or a0, t1, t2   # combine the lower and upper

    ret # return value
