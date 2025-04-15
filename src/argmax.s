.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi t0, x0, 1
    blt a1, t0, error_exit
    add t0, x0, x0
    add t1, x0, x0
    lw t2, 0(a0)
    addi a0, a0, 4
    addi t0, t0, 1

loop_start:
    bge t0, a1, loop_end
    lw t3, 0(a0)
    bge t2, t3, loop_continue
    add t2, x0, t3
    add t1, x0, t0

loop_continue:
    addi t0, t0, 1
    addi a0, a0, 4
    j loop_start

loop_end:
    add a0, x0, t1
    ret

error_exit:
    addi a0, x0, 77
    ret
