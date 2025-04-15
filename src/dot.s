.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    addi t0, x0, 1
    blt a2, t0, error_length
    blt a3, t0, error_stride
    blt a4, t0, error_stride
    add t0, x0, x0
    add t1, x0, x0
    add t5, x0, a0
    add t6, x0, a1

loop_start:
    bge t0, a2, loop_end
    lw t2, 0(t5)
    lw t3, 0(t6)
    mul t2, t2, t3
    add t1, t1, t2
    
    slli t4, a3, 2
    add t5, t5, t4
    slli t4, a4, 2
    add t6, t6, t4
    addi t0, t0, 1
    j loop_start

loop_end:
    add a0, x0, t1
    ret

error_length:
    addi a0, x0, 75
    ret

error_stride:
    addi a0, x0, 76
    ret
