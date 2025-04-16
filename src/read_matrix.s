.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Pop
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    # Save args
    mv s0, a0  # s0 = File name
    mv s1, a1  # s1 = Pointer to rows
    mv s2, a2  # s2 = Pointers to cols

    # Open file
    mv a1, s0
    add a2, x0, x0
    jal fopen
    addi t0, x0, -1
    beq a0, t0, error_90
    mv s0, a0  # s0 = fd

    # Read rows and cols
    addi a3, x0, 4
    mv a1, s0
    mv a2, s1
    jal fread
    addi t0, x0, 4
    bne a0, t0, error_91
    lw s1, 0(s1) # s1 = rows

    addi a3, x0, 4
    mv a1, s0
    mv a2, s2
    jal fread
    addi t0, x0, 4
    bne a0, t0, error_91
    lw s2, 0(s2) # s2 = cols

    # Size of matrix
    mul s3, s1, s2 # s3 = rows * cols

    # Allocate heap memory
    slli a0, s3, 2
    jal malloc
    beq a0, x0, error_88
    mv s4, a0  # s4 = pointer to heap

    # Read matrix
    mv a1, s0
    mv a2, s4
    slli a3, s3, 2
    jal fread
    slli t0, s3, 2
    bne a0, t0, error_91

    # Close file
    mv a1, s0
    jal fclose
    bne a0, x0, error_92

    # Return value
    mv a0, s4

    # Pop
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    ret

error_88:
    addi a1, x0, 88
    jal exit2

error_90:
    addi a1, x0, 90
    jal exit2

error_91:
    addi a1, x0, 91
    jal exit2

error_92:
    addi a1, x0, 92
    jal exit2
    