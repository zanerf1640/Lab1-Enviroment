# This is the file for the addition function

.global add_q31

# Addtion functions
add_q31:

    lw t1, 0(a0)    # int a
    lw t2, 0(a1)    # int b

    add a0, t1, t2  # t3 = a[t1] + b[t2]

    ret
