.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi t0, x0, 1
    bge a1, t0, else
    addi a0, x0, 78
    ret
else:
    add t0, x0, x0  #t0用来记录循环次数
   
loop_start:
    bge t0, a1, loop_end
    lw t1, 0(a0)  #t1用来读值
    bge t1, x0, loop_continue
    add t1, x0, x0
    
loop_continue:
    sw t1, 0(a0)
    addi a0, a0, 4
    addi t0, t0, 1
    j loop_start

loop_end:


    # Epilogue

    
	ret
