.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    addi t0, x0, 1
    blt a1, t0, error_m0
    blt a2, t0, error_m0
    blt a4, t0, error_m1
    blt a5, t0, error_m1
    bne a2, a4, error_match
    
    # Prologue
    add t0, x0, x0 # i
    add t1, x0, x0 # j
    add t6, x0, a3 # m1 pointer

outer_loop_start:
    bge t0, a1, outer_loop_end

inner_loop_start:
    bge t1, a5, inner_loop_end

    #Push a0-6, t0-2
    addi sp, sp, -40
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw t0, 28(sp)
    sw t1, 32(sp)
    sw t6, 36(sp)

    #Call dot
    add a1, x0, t6
    addi a3, x0, 1
    add a4, x0, a5
    jal ra, dot
    add t3, x0, a0 # t3: store return value

    #Pop
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    lw t0, 28(sp)
    lw t1, 32(sp)
    lw t6, 36(sp)
    addi sp, sp, 40

    #Write value
    sw t3, 0(a6)

    #++
    addi t6, t6, 4
    addi a6, a6, 4
    addi t1, t1, 1
    j inner_loop_start

inner_loop_end:

    #i, j
    add t1, x0, x0
    addi t0, t0, 1

    #pointers of m0, m1
    add t6, x0, a3
    slli t5, a2, 2
    add a0, a0, t5
    j outer_loop_start


outer_loop_end:
    
    add a0, x0, x0
    ret

error_m0:

    addi a0, x0, 72
    ret

error_m1:

    addi a0, x0, 73
    ret

error_match:

    addi a0, x0, 74
    ret
