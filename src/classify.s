.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Push
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    # Save args
    mv s0, a0  # s0 = argc
    mv s1, a1  # s1 = argv
    mv s2, a2  # s2 = print or not

    # Check argc
    addi t0, x0, 5
    bne s0, t0, error_89

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    addi a0, x0, 8
    jal malloc
    beq a0, x0, error_88
    mv s3, a0  # s3 = pointer to row and col of m0

    lw a0, 4(s1)
    add a1, s3, x0
    addi a2, s3, 4
    jal read_matrix
    mv s4, a0  # s4 = pointer to m0


    # Load pretrained m1
    addi a0, x0, 8
    jal malloc
    beq a0, x0, error_88
    mv s5, a0  # s5 = pointer to row and col of m1

    lw a0, 8(s1)
    add a1, s5, x0
    addi a2, s5, 4
    jal read_matrix
    mv s6, a0  # s6 = pointer to m1


    # Load input matrix
    addi a0, x0, 8
    jal malloc
    beq a0, x0, error_88
    mv s7, a0  # s7 = pointer to row and col of input

    lw a0, 12(s1)
    add a1, s7, x0
    addi a2, s7, 4
    jal read_matrix
    mv s8, a0  # s8 = pointer to input


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    
    lw t0, 0(s3)
    lw t1, 4(s7)
    mul t0, t0, t1
    slli a0, t0, 2
    jal malloc
    beq a0, x0, error_88
    mv s9, a0  # s9 = pointer to m0 * input

    mv a0, s4
    lw a1, 0(s3)
    lw a2, 4(s3)
    mv a3, s8
    lw a4, 0(s7)
    lw a5, 4(s7)
    mv a6, s9
    jal matmul

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    lw t0, 0(s3)
    lw t1, 4(s7)
    mul a1, t0, t1
    mv a0, s9
    jal relu


    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0, 0(s5)
    lw t1, 4(s7)
    mul t0, t0, t1
    slli a0, t0, 2
    jal malloc
    beq a0, x0, error_88
    mv s10, a0  # s10 = pointer to m1 * ReLU(m0 * input)

    mv a0, s6
    lw a1, 0(s5)
    lw a2, 4(s5)
    mv a3, s8
    lw a4, 0(s7)
    lw a5, 4(s7)
    mv a6, s10
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1, s10
    lw a2, 0(s5)
    lw a3, 4(s7)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw t0, 0(s5)
    lw t1, 4(s7)
    mul a1, t0, t1
    mv a0, s10
    jal argmax
    mv s11, a0  # s11 = index of the largest element in vector

    # Print classification
    bne s2, x0, skip_print
    mv a1, s11
    jal print_int



    # Print newline afterwards for clarity
    addi a1, x0, '\n'
    jal print_char


skip_print:
    # Free heap
    mv a0, s4
    jal free
    mv a0, s3
    jal free
    mv a0, s6
    jal free
    mv a0, s5
    jal free
    mv a0, s8
    jal free
    mv a0, s7
    jal free
    mv a0, s9
    jal free
    mv a0, s10
    jal free

    # Pop
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52


    ret


error_89:
    addi a1, x0, 89
    jal exit2

error_88:
    addi a1, x0, 88
    jal exit2
