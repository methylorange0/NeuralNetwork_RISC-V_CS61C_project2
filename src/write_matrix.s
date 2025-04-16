.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Push
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    # Save args
    mv s0, a0   # s0 = pointer to filename
    mv s1, a1   # s1 = pointer to matrix
    mv s2, a2   # s2 = rows
    mv s3, a3   # s3 = cols

    # Open file
    mv a1, s0
    addi a2, x0, 1
    jal fopen
    addi t0, x0, -1
    beq a0, t0, error_93
    mv s0, a0   # s0 = fd

    # Write rows and cols
    addi a0, x0, 8
    jal malloc
    sw s2, 0(a0)
    sw s3, 4(a0)
    mv a1, s0
    mv a2, a0
    addi a3, x0, 2
    addi a4, x0, 4
    jal fwrite
    addi t0, x0, 2
    bne a0, t0, error_94

    # Number of items
    mul s4, s2, s3  # s4 = number of items

    # Write matrix
    mv a1, s0
    mv a2, s1
    mv a3, s4
    addi a4, x0, 4
    jal fwrite
    bne a0, s4, error_94

    # Close file
    mv a1, s0
    jal fclose
    bne a0, x0, error_95

    # Pop
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    ret


error_93:
    addi a1, x0, 93
    jal exit2

error_94:
    addi a1, x0, 94
    jal exit2

error_95:
    addi a1, x0, 95
    jal exit2